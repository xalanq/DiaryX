package com.xalanq.diaryx

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var mediaPipeLLMHandler: MediaPipeLLMHandler
    private var eventChannel: EventChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize MediaPipe LLM handler
        mediaPipeLLMHandler = MediaPipeLLMHandler(this)

        // Set up MethodChannel for MediaPipe LLM operations
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.xalanq.diaryx/mediapipe_llm")
            .setMethodCallHandler(mediaPipeLLMHandler)

        // Set up EventChannel for streaming operations
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.xalanq.diaryx/mediapipe_llm_stream")
        eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                mediaPipeLLMHandler.setEventSink(events)
            }

            override fun onCancel(arguments: Any?) {
                mediaPipeLLMHandler.setEventSink(null)
            }
        })
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::mediaPipeLLMHandler.isInitialized) {
            mediaPipeLLMHandler.dispose()
        }
    }
}
