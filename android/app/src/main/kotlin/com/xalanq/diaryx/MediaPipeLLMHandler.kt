package com.xalanq.diaryx

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import android.util.Log
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.framework.image.MPImage
import com.google.mediapipe.tasks.genai.llminference.GraphOptions
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import com.google.mediapipe.tasks.genai.llminference.LlmInferenceSession
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.File

private const val TAG = "MediaPipeLLMHandler"

class MediaPipeLLMHandler(private val context: Context) : MethodChannel.MethodCallHandler {

    private var llmInference: LlmInference? = null
    private var llmSession: LlmInferenceSession? = null
    private var streamingJob: Job? = null
    private var eventSink: EventChannel.EventSink? = null
    private val coroutineScope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    // Configuration parameters
    private var maxTokens: Int = 512
    private var topK: Int = 40
    private var topP: Float = 0.95f
    private var temperature: Float = 0.8f
    private var accelerator: String = "GPU"
    private var maxNumImages: Int = 1

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> initialize(call, result)
            "chatCompletion" -> chatCompletion(call, result)
            "startStreamingCompletion" -> startStreamingCompletion(call, result)
            "cancelStreaming" -> cancelStreaming(result)
            "resetSession" -> resetSession(result)
            "isAvailable" -> isAvailable(result)
            "cleanup" -> cleanup(result)
            else -> result.notImplemented()
        }
    }

    private fun initialize(call: MethodCall, result: MethodChannel.Result) {
        coroutineScope.launch(Dispatchers.IO) {
            try {
                val modelPath = call.argument<String>("modelPath") ?: run {
                    withContext(Dispatchers.Main) {
                        result.error("INVALID_ARGUMENT", "Model path is required", null)
                    }
                    return@launch
                }

                // Extract configuration parameters
                maxTokens = call.argument<Int>("maxTokens") ?: 512
                topK = call.argument<Int>("topK") ?: 40
                topP = call.argument<Double>("topP")?.toFloat() ?: 0.95f
                temperature = call.argument<Double>("temperature")?.toFloat() ?: 0.8f
                accelerator = call.argument<String>("accelerator") ?: "GPU"
                maxNumImages = call.argument<Int>("maxNumImages") ?: 1

                Log.d(TAG, "Initializing MediaPipe LLM with model: $modelPath")
                Log.d(TAG, "Config - maxTokens: $maxTokens, topK: $topK, topP: $topP, temp: $temperature")

                // Check if model file exists
                val modelFile = File(modelPath)
                if (!modelFile.exists()) {
                    withContext(Dispatchers.Main) {
                        result.error("MODEL_NOT_FOUND", "Model file not found: $modelPath", null)
                    }
                    return@launch
                }

                // Determine preferred backend
                val preferredBackend = when (accelerator.uppercase()) {
                    "CPU" -> LlmInference.Backend.CPU
                    "GPU" -> LlmInference.Backend.GPU
                    else -> LlmInference.Backend.GPU
                }

                // Create LLM Inference options
                val inferenceOptions = LlmInference.LlmInferenceOptions.builder()
                    .setModelPath(modelPath)
                    .setMaxTokens(maxTokens)
                    .setPreferredBackend(preferredBackend)
                    .setMaxNumImages(maxNumImages)
                    .build()

                // Create LLM Inference instance
                llmInference = LlmInference.createFromOptions(context, inferenceOptions)

                // Create LLM Inference Session
                val sessionOptions = LlmInferenceSession.LlmInferenceSessionOptions.builder()
                    .setTopK(topK)
                    .setTopP(topP)
                    .setTemperature(temperature)
                    .setGraphOptions(
                        GraphOptions.builder()
                            .setEnableVisionModality(maxNumImages > 0)
                            .build()
                    )
                    .build()

                llmSession = LlmInferenceSession.createFromOptions(
                    llmInference!!,
                    sessionOptions
                )

                Log.d(TAG, "MediaPipe LLM initialized successfully")

                withContext(Dispatchers.Main) {
                    result.success(mapOf("success" to true))
                }

            } catch (e: Exception) {
                Log.e(TAG, "Failed to initialize MediaPipe LLM", e)
                withContext(Dispatchers.Main) {
                    val errorMessage = cleanUpMediapipeErrorMessage(e.message ?: "Unknown error")
                    result.success(mapOf(
                        "success" to false,
                        "error" to errorMessage
                    ))
                }
            }
        }
    }

    private fun chatCompletion(call: MethodCall, result: MethodChannel.Result) {
        coroutineScope.launch(Dispatchers.IO) {
            try {
                val session = llmSession ?: run {
                    withContext(Dispatchers.Main) {
                        result.error("NOT_INITIALIZED", "LLM not initialized", null)
                    }
                    return@launch
                }

                val messages = call.argument<List<Map<String, Any>>>("messages") ?: run {
                    withContext(Dispatchers.Main) {
                        result.error("INVALID_ARGUMENT", "Messages are required", null)
                    }
                    return@launch
                }

                Log.d(TAG, "Processing chat completion with ${messages.size} messages")

                // Process messages and add to session
                for (message in messages) {
                    processMessage(session, message)
                }

                // Generate response synchronously
                var fullResponse = ""
                val responseCompleter = CompletableDeferred<String>()

                session.generateResponseAsync { partialResult: String, done: Boolean ->
                    fullResponse += partialResult
                    if (done) {
                        Log.d(TAG, "Chat completion finished, response length: ${fullResponse.length}")
                        responseCompleter.complete(fullResponse)
                    }
                }

                val response = responseCompleter.await()

                withContext(Dispatchers.Main) {
                    result.success(mapOf(
                        "success" to true,
                        "response" to response
                    ))
                }

            } catch (e: Exception) {
                Log.e(TAG, "Chat completion failed", e)
                withContext(Dispatchers.Main) {
                    val errorMessage = cleanUpMediapipeErrorMessage(e.message ?: "Unknown error")
                    result.success(mapOf(
                        "success" to false,
                        "error" to errorMessage
                    ))
                }
            }
        }
    }

    private fun startStreamingCompletion(call: MethodCall, result: MethodChannel.Result) {
        streamingJob?.cancel()

        streamingJob = coroutineScope.launch(Dispatchers.IO) {
            try {
                val session = llmSession ?: run {
                    withContext(Dispatchers.Main) {
                        result.error("NOT_INITIALIZED", "LLM not initialized", null)
                    }
                    return@launch
                }

                val messages = call.argument<List<Map<String, Any>>>("messages") ?: run {
                    withContext(Dispatchers.Main) {
                        result.error("INVALID_ARGUMENT", "Messages are required", null)
                    }
                    return@launch
                }

                Log.d(TAG, "Starting streaming completion with ${messages.size} messages")

                // Process messages and add to session
                for (message in messages) {
                    processMessage(session, message)
                }

                withContext(Dispatchers.Main) {
                    result.success(null)
                }

                // Start streaming response
                session.generateResponseAsync { partialResult: String, done: Boolean ->
                    eventSink?.let { sink ->
                        if (done) {
                            Log.d(TAG, "Streaming completion finished")
                            sink.success(mapOf(
                                "type" to "done"
                            ))
                        } else {
                            sink.success(mapOf(
                                "type" to "chunk",
                                "content" to partialResult
                            ))
                        }
                    }
                }

            } catch (e: Exception) {
                Log.e(TAG, "Streaming completion failed", e)

                eventSink?.let { sink ->
                    val errorMessage = cleanUpMediapipeErrorMessage(e.message ?: "Unknown error")
                    sink.success(mapOf(
                        "type" to "error",
                        "error" to errorMessage
                    ))
                }

                if (!streamingJob!!.isCompleted) {
                    withContext(Dispatchers.Main) {
                        result.error("STREAMING_ERROR", "Streaming failed", null)
                    }
                }
            }
        }
    }

    private fun cancelStreaming(result: MethodChannel.Result) {
        Log.d(TAG, "Cancelling streaming completion")
        streamingJob?.cancel()
        streamingJob = null
        result.success(null)
    }

    private fun resetSession(result: MethodChannel.Result) {
        coroutineScope.launch(Dispatchers.IO) {
            try {
                val inference = llmInference ?: run {
                    withContext(Dispatchers.Main) {
                        result.error("NOT_INITIALIZED", "LLM not initialized", null)
                    }
                    return@launch
                }

                Log.d(TAG, "Resetting LLM session")

                // Close existing session
                llmSession?.close()

                // Create new session with same options
                val sessionOptions = LlmInferenceSession.LlmInferenceSessionOptions.builder()
                    .setTopK(topK)
                    .setTopP(topP)
                    .setTemperature(temperature)
                    .setGraphOptions(
                        GraphOptions.builder()
                            .setEnableVisionModality(maxNumImages > 0)
                            .build()
                    )
                    .build()

                llmSession = LlmInferenceSession.createFromOptions(inference, sessionOptions)

                Log.d(TAG, "LLM session reset successfully")

                withContext(Dispatchers.Main) {
                    result.success(null)
                }

            } catch (e: Exception) {
                Log.e(TAG, "Failed to reset LLM session", e)
                withContext(Dispatchers.Main) {
                    result.error("RESET_ERROR", e.message ?: "Unknown error", null)
                }
            }
        }
    }

    private fun isAvailable(result: MethodChannel.Result) {
        val available = llmInference != null && llmSession != null
        result.success(mapOf("available" to available))
    }

    private fun cleanup(result: MethodChannel.Result) {
        coroutineScope.launch(Dispatchers.IO) {
            try {
                Log.d(TAG, "Cleaning up MediaPipe LLM resources")

                streamingJob?.cancel()
                streamingJob = null

                llmSession?.close()
                llmSession = null

                llmInference?.close()
                llmInference = null

                Log.d(TAG, "MediaPipe LLM cleanup completed")

                withContext(Dispatchers.Main) {
                    result.success(null)
                }

            } catch (e: Exception) {
                Log.e(TAG, "Error during cleanup", e)
                withContext(Dispatchers.Main) {
                    result.error("CLEANUP_ERROR", e.message ?: "Unknown error", null)
                }
            }
        }
    }

    fun setEventSink(eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }

    private fun processMessage(session: LlmInferenceSession, message: Map<String, Any>) {
        val content = message["content"] as? String
        if (!content.isNullOrEmpty()) {
            session.addQueryChunk(content)
        }

        // Process images if present
        val images = message["images"] as? List<Map<String, Any>>
        images?.forEach { imageItem ->
            val imageData = imageItem["data"] as? String
            val imageType = imageItem["type"] as? String

            if (imageData != null && imageType != null) {
                when (imageType) {
                    "base64" -> {
                        try {
                            val bitmap = decodeBase64ToBitmap(imageData)
                            session.addImage(BitmapImageBuilder(bitmap).build())
                        } catch (e: Exception) {
                            Log.e(TAG, "Failed to decode base64 image", e)
                        }
                    }
                    "url" -> {
                        // Handle URL-based images if needed
                        Log.w(TAG, "URL-based images not yet supported")
                    }
                }
            }
        }

        // Note: Audio processing would be added here when MediaPipe supports it
        // val audios = message["audios"] as? List<Map<String, Any>>
        // audios?.forEach { audioItem ->
        //     // Process audio when MediaPipe adds support
        // }
    }

    private fun decodeBase64ToBitmap(base64String: String): Bitmap {
        val decodedBytes = Base64.decode(base64String, Base64.DEFAULT)
        return BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
    }

    private fun cleanUpMediapipeErrorMessage(message: String): String {
        // Clean up MediaPipe error messages to be more user-friendly
        return when {
            message.contains("INVALID_ARGUMENT") -> "Invalid model configuration or input"
            message.contains("NOT_FOUND") -> "Model file not found"
            message.contains("PERMISSION_DENIED") -> "Permission denied accessing model file"
            message.contains("RESOURCE_EXHAUSTED") -> "Insufficient memory or resources"
            message.contains("DEADLINE_EXCEEDED") -> "Operation timed out"
            message.contains("UNAVAILABLE") -> "Service temporarily unavailable"
            else -> message
        }
    }

    fun dispose() {
        coroutineScope.cancel()
        streamingJob?.cancel()

        try {
            llmSession?.close()
            llmInference?.close()
        } catch (e: Exception) {
            Log.e(TAG, "Error disposing MediaPipe LLM handler", e)
        }

        llmSession = null
        llmInference = null
        eventSink = null
    }
}
