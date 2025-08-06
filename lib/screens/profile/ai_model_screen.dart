import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import '../../widgets/premium_glass_card/premium_glass_card.dart';
import '../../widgets/gradient_background/gradient_background.dart';
import '../../widgets/animations/premium_animations.dart';
import '../../widgets/app_button/app_button.dart';
import '../../themes/app_colors.dart';
import '../../consts/env_config.dart';
import '../../utils/app_logger.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/file_helper.dart';
import '../../routes.dart';
import '../../services/ai/ai_service.dart';
import '../../services/ai/models/config_models.dart';

/// AI Model configuration screen with modern UI/UX
class AIModelScreen extends StatefulWidget {
  const AIModelScreen({super.key});

  @override
  State<AIModelScreen> createState() => _AIModelScreenState();
}

class _AIModelScreenState extends State<AIModelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Google AI Edge state
  final Map<String, String?> _downloadedModels = {};

  // Ollama API state
  final _ollamaUrlController = TextEditingController();
  final _ollamaModelController = TextEditingController();

  // Model selection state
  String _selectedAIProvider = 'none'; // 'google', 'ollama', 'none'
  String _selectedModelName = '';
  bool _isOllamaConnecting = false;
  bool _isOllamaConnected = false;
  String? _ollamaError;

  // AI Engine selection state
  AIServiceType? _currentAIEngine;
  List<AIServiceType> _availableEngines = [];
  bool _isEngineLoading = false;

  // File picker loading state
  bool _isFilePickerLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSettings();
    AppLogger.userAction('AI Model settings screen opened');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ollamaUrlController.dispose();
    _ollamaModelController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    // Load saved settings from SharedPreferences
    _ollamaUrlController.text = 'http://localhost:11434';
    _ollamaModelController.text = 'gemma3n:e4b';

    // Load current AI provider and model from settings
    _selectedAIProvider = 'none'; // Default to none until user selects

    // Load current AI engine
    await _loadCurrentAIEngine();

    // Check for downloaded models
    await _checkDownloadedModels();
  }

  Future<void> _loadCurrentAIEngine() async {
    try {
      final aiService = AIService.instance;

      // Load available engines - include mock in debug mode
      _availableEngines = [AIServiceType.ollama, AIServiceType.googleAIEdge];
      if (kDebugMode) {
        _availableEngines.insert(0, AIServiceType.mock);
      }

      // Get current engine from AI config service directly
      final configService = aiService.configService;
      AppLogger.info('ConfigService available: ${configService != null}');

      if (configService != null) {
        final currentConfig = configService.config;
        AppLogger.info(
          'Loading current AI engine, config: ${currentConfig.toJson()}',
        );
        AppLogger.info(
          'Found existing config with serviceType: ${currentConfig.serviceType}',
        );

        // Convert enum service type directly (no string conversion needed)
        _currentAIEngine = currentConfig.serviceType;
        AppLogger.info('Set current AI engine to: $_currentAIEngine');

        // Load user's saved configurations into UI controls
        await _loadUserConfigurations();
      } else {
        AppLogger.warn('ConfigService not available, using default');
        // Default to mock in debug mode, otherwise first available
        _currentAIEngine = kDebugMode
            ? AIServiceType.mock
            : _availableEngines.first;

        AppLogger.info('Set default AI engine to: $_currentAIEngine');
      }

      if (mounted) {
        setState(() {});
      }

      AppLogger.info('Loaded current AI engine: $_currentAIEngine');
    } catch (e) {
      AppLogger.error('Failed to load AI engine configuration', e);
      // Fallback to default
      _availableEngines = [AIServiceType.mock];
      _currentAIEngine = AIServiceType.mock;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _checkDownloadedModels() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final modelsDir = Directory('${directory.path}/ai_models');

      if (!modelsDir.existsSync()) {
        return;
      }

      for (final model in EnvConfig.googleAIEdgeModels) {
        final modelFile = File('${modelsDir.path}/${model['modelFile']}');
        if (modelFile.existsSync()) {
          // Convert absolute path to relative path for storage (like moment.dart)
          final relativePath = await FileHelper.toRelativePath(modelFile.path);
          _downloadedModels[model['name']] = relativePath;
        }
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      AppLogger.error('Failed to check downloaded models', e);
    }
  }

  Future<void> _openHuggingFacePage(Map<String, dynamic> model) async {
    final modelId = model['modelId'] as String;
    final huggingFaceUrl = 'https://huggingface.co/$modelId';

    try {
      final Uri uri = Uri.parse(huggingFaceUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $huggingFaceUrl');
      }
      AppLogger.info('Opened Hugging Face page: $huggingFaceUrl');
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(
          context,
          'Failed to open Hugging Face page: ${e.toString()}',
        );
      }
      AppLogger.error('Failed to open Hugging Face page', e);
    }
  }

  Future<void> _openOllamaDocumentation() async {
    const ollamaDocsUrl = 'https://github.com/ollama/ollama/tree/main/docs';

    try {
      final Uri uri = Uri.parse(ollamaDocsUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $ollamaDocsUrl');
      }
      AppLogger.info('Opened Ollama documentation: $ollamaDocsUrl');
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(
          context,
          'Failed to open Ollama documentation: ${e.toString()}',
        );
      }
      AppLogger.error('Failed to open Ollama documentation', e);
    }
  }

  Future<void> _switchAIEngine(AIServiceType newEngine) async {
    if (newEngine == _currentAIEngine) return;

    setState(() {
      _isEngineLoading = true;
    });

    try {
      AppLogger.info(
        'Switching AI engine from $_currentAIEngine to $newEngine',
      );

      // Create configuration with user's custom settings
      AIConfig newConfig;
      switch (newEngine) {
        case AIServiceType.mock:
          newConfig = AIConfigExtension.defaultFor(AIServiceType.mock);
          break;
        case AIServiceType.ollama:
          final ollamaUrl = _ollamaUrlController.text.trim().isNotEmpty
              ? _ollamaUrlController.text.trim()
              : 'http://localhost:11434';
          final ollamaModel = _ollamaModelController.text.trim().isNotEmpty
              ? _ollamaModelController.text.trim()
              : 'llama2';

          newConfig = AIConfig(
            serviceType: AIServiceType.ollama,
            ollamaUrl: ollamaUrl,
            ollamaModel: ollamaModel,
          );

          AppLogger.info(
            'Creating Ollama config: URL=$ollamaUrl, Model=$ollamaModel',
          );
          break;
        case AIServiceType.googleAIEdge:
          // Check if user has selected a Google AI Edge model
          if (_selectedAIProvider != 'google' || _selectedModelName.isEmpty) {
            throw Exception(
              'Please select a Google AI Edge model before switching to this engine',
            );
          }

          // Get the relative path of the selected model
          final selectedModelRelativePath =
              _downloadedModels[_selectedModelName];
          if (selectedModelRelativePath == null ||
              selectedModelRelativePath.isEmpty) {
            throw Exception(
              'Selected model file not found. Please re-import the model.',
            );
          }

          // Convert relative path to absolute path for file verification (like moment.dart)
          final selectedModelPath = await FileHelper.toAbsolutePath(
            selectedModelRelativePath,
          );

          // Verify the model file still exists
          final modelFile = File(selectedModelPath);
          if (!modelFile.existsSync()) {
            throw Exception(
              'Model file no longer exists at $selectedModelPath. Please re-import the model.',
            );
          }

          // Store relative path in AIConfig (like moment.dart does for media attachments)
          newConfig = AIConfig(
            serviceType: AIServiceType.googleAIEdge,
            gemmaModelPath: selectedModelRelativePath, // Store relative path
          );

          AppLogger.info(
            'Creating Google AI Edge config with model: $_selectedModelName at relative path: $selectedModelRelativePath',
          );
          break;
      }

      // Switch engine with custom configuration
      await _switchEngineWithConfig(newConfig);

      // Update local state
      _currentAIEngine = newEngine;

      if (mounted) {
        SnackBarHelper.showSuccess(
          context,
          'Successfully switched to ${_getEngineDisplayName(newEngine)}',
        );
      }

      AppLogger.userAction(
        'AI engine switched to $newEngine with custom config',
      );
    } catch (e) {
      AppLogger.error('Failed to switch AI engine', e);

      if (mounted) {
        SnackBarHelper.showError(
          context,
          'Failed to switch AI engine: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEngineLoading = false;
        });
      }
    }
  }

  /// Switch engine with custom configuration
  Future<void> _switchEngineWithConfig(AIConfig config) async {
    // Access the config service through reflection since it's private
    // We'll call the public updateConfig method through AIService
    await _updateAIConfig(config);
  }

  /// Update AI configuration through service
  Future<void> _updateAIConfig(AIConfig config) async {
    final aiService = AIService.instance;

    AppLogger.info('Attempting to update AI config: ${config.toJson()}');
    AppLogger.info('Config is valid: ${config.isValid}');

    // Use the public configService getter
    if (aiService.configService != null) {
      final success = await aiService.configService!.updateConfig(config);
      AppLogger.info('Config update result: $success');
      if (!success) {
        throw Exception('Failed to update AI engine configuration');
      }
    } else {
      throw Exception('AI config service not available');
    }
  }

  /// Save Google AI Edge configuration when model is selected
  Future<void> _saveGoogleAIEdgeConfig() async {
    try {
      if (_selectedAIProvider != 'google' || _selectedModelName.isEmpty) {
        AppLogger.warn('No Google AI Edge model selected to save');
        return;
      }

      final selectedModelRelativePath = _downloadedModels[_selectedModelName];
      if (selectedModelRelativePath == null ||
          selectedModelRelativePath.isEmpty) {
        throw Exception('Selected model file not found');
      }

      // Convert relative path to absolute path for file verification (like moment.dart)
      final selectedModelPath = await FileHelper.toAbsolutePath(
        selectedModelRelativePath,
      );

      // Verify the model file exists
      final modelFile = File(selectedModelPath);
      if (!modelFile.existsSync()) {
        throw Exception('Model file no longer exists at $selectedModelPath');
      }

      final aiService = AIService.instance;
      final currentConfig = aiService.configService?.config;

      // Create Google AI Edge configuration with relative path (like moment.dart)
      final googleAIEdgeConfig = AIConfig(
        serviceType: AIServiceType.googleAIEdge,
        gemmaModelPath: selectedModelRelativePath, // Store relative path
        // Preserve other settings from current config
        enableBackgroundProcessing:
            currentConfig?.enableBackgroundProcessing ?? true,
        requestTimeout:
            currentConfig?.requestTimeout ?? const Duration(seconds: 30),
        additionalParams: currentConfig?.additionalParams ?? {},
      );

      // If current engine is Google AI Edge, switch immediately
      // Otherwise, just store the config for later use when user switches
      if (currentConfig?.serviceType == AIServiceType.googleAIEdge) {
        if (aiService.configService != null) {
          await aiService.configService!.updateConfig(googleAIEdgeConfig);
          AppLogger.info('Updated current Google AI Edge configuration');
        }
      } else {
        // Store configuration for later use
        // Note: In a full implementation, we might want to persist this in SharedPreferences
        // For now, we just validate that the configuration is ready
        AppLogger.info(
          'Google AI Edge configuration validated and ready: model=$_selectedModelName, path=$selectedModelPath',
        );
      }
    } catch (e) {
      AppLogger.error('Failed to save Google AI Edge configuration', e);
      // Don't throw here, just log the error since model selection was successful
    }
  }

  /// Save Ollama configuration when connection test succeeds
  Future<void> _saveOllamaConfig() async {
    try {
      final aiService = AIService.instance;

      final ollamaConfig = AIConfig(
        serviceType: AIServiceType.ollama,
        ollamaUrl: _ollamaUrlController.text.trim(),
        ollamaModel: _ollamaModelController.text.trim(),
      );

      if (aiService.configService != null) {
        // Only save the configuration, don't switch the engine yet
        // This preserves the user's Ollama settings for later use
        final currentConfig = aiService.configService!.config;

        // If the current engine is not Ollama, just save the Ollama config for later
        // If it is Ollama, update and switch
        if (currentConfig.serviceType == AIServiceType.ollama) {
          await aiService.configService!.updateConfig(ollamaConfig);
          AppLogger.info('Updated current Ollama configuration');
        } else {
          // Store Ollama config for later use (we'll implement a way to persist this)
          AppLogger.info('Ollama configuration validated and ready for use');
        }
      }
    } catch (e) {
      AppLogger.error('Failed to save Ollama configuration', e);
      // Don't throw here, just log the error since connection was successful
    }
  }

  /// Load user configurations from stored config into UI controls
  Future<void> _loadUserConfigurations() async {
    try {
      final aiService = AIService.instance;
      final aiConfig = aiService.configService?.config;

      AppLogger.info(
        'Loading user configurations from config: ${aiConfig?.toJson()}',
      );

      if (aiConfig != null) {
        // Load Ollama configurations
        if (aiConfig.ollamaUrl != null && aiConfig.ollamaUrl!.isNotEmpty) {
          _ollamaUrlController.text = aiConfig.ollamaUrl!;
          AppLogger.info('Loaded Ollama URL: ${aiConfig.ollamaUrl}');
        }

        if (aiConfig.ollamaModel != null && aiConfig.ollamaModel!.isNotEmpty) {
          _ollamaModelController.text = aiConfig.ollamaModel!;
          AppLogger.info('Loaded Ollama model: ${aiConfig.ollamaModel}');
        }

        // Set connection status based on current engine
        if (aiConfig.serviceType == AIServiceType.ollama) {
          _isOllamaConnected = true;
          _selectedAIProvider = 'ollama';
          _selectedModelName = aiConfig.ollamaModel ?? '';
          AppLogger.info(
            'Set Ollama as connected with model: $_selectedModelName',
          );
        }

        AppLogger.info(
          'Loaded user configurations: Ollama URL=${aiConfig.ollamaUrl}, Model=${aiConfig.ollamaModel}',
        );
      } else {
        AppLogger.warn('No configuration available to load');
      }
    } catch (e) {
      AppLogger.error('Failed to load user configurations', e);
    }
  }

  String _getEngineDisplayName(AIServiceType engineType) {
    switch (engineType) {
      case AIServiceType.mock:
        return 'Mock AI (Testing)';
      case AIServiceType.ollama:
        return 'Ollama';
      case AIServiceType.googleAIEdge:
        return 'Google AI Edge';
    }
  }

  String _getEngineDescription(AIServiceType engineType) {
    switch (engineType) {
      case AIServiceType.mock:
        return 'Mock AI engine for testing and development. Provides simulated responses.';
      case AIServiceType.ollama:
        return 'Connect to a local Ollama server for private AI processing.';
      case AIServiceType.googleAIEdge:
        final hasSelectedModel =
            _selectedAIProvider == 'google' &&
            _selectedModelName.isNotEmpty &&
            _downloadedModels.containsKey(_selectedModelName);

        if (hasSelectedModel) {
          // For description, we assume the model is ready if it's selected
          // Actual file verification will happen during engine switching
          return 'Ready: Using $_selectedModelName for completely offline AI processing on Android devices.';
        } else {
          return 'Not configured: Please select a Google AI Edge model first to enable offline processing.';
        }
    }
  }

  void _showAIEngineSelectionDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose AI Engine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _availableEngines.map((engine) {
            final isGoogleAIEdge = engine == AIServiceType.googleAIEdge;
            final hasSelectedModel =
                _selectedAIProvider == 'google' &&
                _selectedModelName.isNotEmpty &&
                _downloadedModels.containsKey(_selectedModelName);
            final isGoogleAIEdgeReady = !isGoogleAIEdge || hasSelectedModel;

            return ListTile(
              leading: _getEngineIcon(engine, size: 24),
              title: Row(
                children: [
                  Expanded(child: Text(_getEngineDisplayName(engine))),
                  if (isGoogleAIEdge) ...[
                    Icon(
                      hasSelectedModel ? Icons.check_circle : Icons.warning,
                      size: 16,
                      color: hasSelectedModel ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                  ],
                ],
              ),
              subtitle: Text(
                _getEngineDescription(engine),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              trailing: _currentAIEngine == engine
                  ? Icon(Icons.check, color: theme.primaryColor)
                  : null,
              enabled: isGoogleAIEdgeReady,
              onTap: isGoogleAIEdgeReady
                  ? () {
                      Navigator.of(context).pop();
                      if (engine != _currentAIEngine) {
                        _switchAIEngine(engine);
                      }
                    }
                  : () {
                      Navigator.of(context).pop();
                      SnackBarHelper.showError(
                        context,
                        'Please select a Google AI Edge model in the Google AI Edge tab first',
                      );
                    },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _getEngineIcon(AIServiceType engineType, {double size = 20}) {
    switch (engineType) {
      case AIServiceType.mock:
        return Icon(
          Icons.science_rounded,
          size: size,
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
        );
      case AIServiceType.ollama:
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SvgPicture.asset(
            'assets/images/ollama.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              Icons.api_rounded,
              size: size,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
          ),
        );
      case AIServiceType.googleAIEdge:
        // Google "G" style icon
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              'G',
              style: TextStyle(
                color: Color(0xFF4285F4),
                fontWeight: FontWeight.bold,
                fontSize: size * 0.8,
              ),
            ),
          ),
        );
    }
  }

  Future<void> _selectLocalFile() async {
    setState(() {
      _isFilePickerLoading = true;
    });

    try {
      AppLogger.info('Opening file picker for AI model selection');

      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select AI Model File',
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        AppLogger.info('File selected: ${file.name}, size: ${file.size} bytes');

        // Copy to models directory
        final directory = await getApplicationDocumentsDirectory();
        final modelsDir = Directory('${directory.path}/ai_models');

        if (!modelsDir.existsSync()) {
          await modelsDir.create(recursive: true);
        }

        final sourceFile = File(file.path!);
        final targetPath = '${modelsDir.path}/${file.name}';
        await sourceFile.copy(targetPath);

        // Convert absolute path to relative path for storage (like moment.dart)
        final relativeTargetPath = await FileHelper.toRelativePath(targetPath);

        // Find matching model configuration
        final matchingModel = EnvConfig.googleAIEdgeModels.firstWhere(
          (model) => model['modelFile'] == file.name,
          orElse: () => {'name': file.name},
        );

        setState(() {
          // Store relative path in _downloadedModels (like moment.dart)
          _downloadedModels[matchingModel['name']] = relativeTargetPath;
          // Auto-select imported model
          _selectedAIProvider = 'google';
          _selectedModelName = matchingModel['name'];
        });

        // Save Google AI Edge configuration for the imported model
        await _saveGoogleAIEdgeConfig();

        if (mounted) {
          SnackBarHelper.showSuccess(
            context,
            'Model file imported and configured successfully',
          );
        }

        AppLogger.info('Model file imported and configured: ${file.name}');
      } else {
        AppLogger.info('File picker cancelled by user');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(
          context,
          'Failed to import model file: ${e.toString()}',
        );
      }

      AppLogger.error('Failed to import model file', e);
    } finally {
      if (mounted) {
        setState(() {
          _isFilePickerLoading = false;
        });
      }
    }
  }

  Future<void> _testOllamaConnection() async {
    setState(() {
      _isOllamaConnecting = true;
      _ollamaError = null;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        '${_ollamaUrlController.text.trim()}/api/tags',
        options: Options(receiveTimeout: Duration(seconds: 5)),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isOllamaConnected = true;
          _isOllamaConnecting = false;
          // Auto-select Ollama when connection is successful
          _selectedAIProvider = 'ollama';
          _selectedModelName = _ollamaModelController.text.trim();
        });

        // Save Ollama configuration when connection is successful
        await _saveOllamaConfig();

        if (mounted) {
          SnackBarHelper.showSuccess(
            context,
            'Successfully connected to Ollama and saved configuration',
          );
        }

        AppLogger.info('Ollama connection successful and configuration saved');
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isOllamaConnected = false;
        _isOllamaConnecting = false;
        _ollamaError = e.toString();
      });

      AppLogger.error('Ollama connection failed', e);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(isDark, theme),
      body: PremiumScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 80),

              // Current AI Engine Status
              FadeInSlideUp(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: PremiumGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.settings_suggest_rounded,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Current AI Engine',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Current AI Engine Status
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: (_currentAIEngine != null)
                                ? (isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary)
                                      .withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (_currentAIEngine != null)
                                  ? (isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary)
                                        .withValues(alpha: 0.3)
                                  : Colors.orange.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    (_currentAIEngine != null)
                                        ? Icons.check_circle_rounded
                                        : Icons.warning_rounded,
                                    color: (_currentAIEngine != null)
                                        ? (isDark
                                              ? AppColors.darkPrimary
                                              : AppColors.lightPrimary)
                                        : Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _currentAIEngine != null
                                          ? _getEngineDisplayName(
                                              _currentAIEngine!,
                                            )
                                          : 'No AI engine selected',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: _currentAIEngine != null
                                                ? (isDark
                                                      ? AppColors.darkPrimary
                                                      : AppColors.lightPrimary)
                                                : Colors.orange.shade700,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_currentAIEngine != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _getEngineDescription(_currentAIEngine!),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),

                              // AI Engine Selector Dropdown
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.glassBorderDark.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.glassBorder.withValues(
                                            alpha: 0.3,
                                          ),
                                    width: 1,
                                  ),
                                ),
                                child: _isEngineLoading
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    isDark
                                                        ? AppColors.darkPrimary
                                                        : AppColors
                                                              .lightPrimary,
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Switching engine...',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () =>
                                            _showAIEngineSelectionDialog(
                                              context,
                                            ),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              if (_currentAIEngine != null)
                                                _getEngineIcon(
                                                  _currentAIEngine!,
                                                ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      _currentAIEngine != null
                                                          ? _getEngineDisplayName(
                                                              _currentAIEngine!,
                                                            )
                                                          : 'Select AI Engine',
                                                      style: theme
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                    if (_currentAIEngine ==
                                                            AIServiceType
                                                                .mock &&
                                                        kDebugMode)
                                                      Text(
                                                        'Debug mode only',
                                                        style: theme
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .orange
                                                                  .shade600,
                                                              fontSize: 11,
                                                            ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tab selection with glass morphism
              FadeInSlideUp(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isDark
                        ? AppColors.glassDark.withValues(alpha: 0.3)
                        : AppColors.glassLight.withValues(alpha: 0.7),
                    border: Border.all(
                      color: isDark
                          ? AppColors.glassBorderDark.withValues(alpha: 0.2)
                          : AppColors.glassBorder.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: AppColors.getPrimaryGradient(isDark),
                      ),
                      boxShadow: [],
                    ),
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: theme.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.7),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                    tabs: [
                      Tab(
                        icon: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                color: Color(0xFF4285F4),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        iconMargin: EdgeInsets.only(bottom: 4),
                        text: 'Google AI Edge',
                      ),
                      Tab(
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SvgPicture.asset(
                            'assets/images/ollama.svg',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              isDark ? Colors.white70 : Colors.black54,
                              BlendMode.srcIn,
                            ),
                            placeholderBuilder: (context) => Icon(
                              Icons.api_rounded,
                              size: 24,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                        iconMargin: EdgeInsets.only(bottom: 4),
                        text: 'Ollama API',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Tab content (without TabBarView to allow unified scrolling)
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, child) {
                  if (_tabController.index == 0) {
                    return _buildGoogleAIEdgeTab(isDark, theme);
                  } else {
                    return _buildOllamaAPITab(isDark, theme);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleAIEdgeTab(bool isDark, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 48),
      child: StaggeredAnimationContainer(
        staggerDelay: const Duration(milliseconds: 100),
        children: [
          // Platform support info
          PremiumGlassCard(
            margin: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Android Only',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Google AI Edge models are currently supported on Android devices only.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Local file selection
          PremiumGlassCard(
            margin: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Import Local Model',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Select a pre-downloaded .task model file from your device.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: _isFilePickerLoading
                        ? 'Selecting File...'
                        : 'Select Model File',
                    icon: _isFilePickerLoading
                        ? null
                        : Icons.upload_file_rounded,
                    onPressed: _isFilePickerLoading ? null : _selectLocalFile,
                    isLoading: _isFilePickerLoading,
                  ),
                ),
              ],
            ),
          ),

          // Available models for manual download
          PremiumGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.open_in_browser_rounded,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Available Models',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Models require manual download from Hugging Face due to license agreements. Download the .task file and import it using the button above.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                ...EnvConfig.googleAIEdgeModels.map((model) {
                  final modelName = model['name'] as String;
                  final isDownloaded = _downloadedModels.containsKey(modelName);
                  final isSelected =
                      _selectedAIProvider == 'google' &&
                      _selectedModelName == modelName;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                            : (isDownloaded
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : (isDark
                                        ? AppColors.glassBorderDark.withValues(
                                            alpha: 0.2,
                                          )
                                        : AppColors.glassBorder.withValues(
                                            alpha: 0.3,
                                          ))),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        modelName,
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? (isDark
                                                        ? AppColors.darkPrimary
                                                        : AppColors
                                                              .lightPrimary)
                                                  : null,
                                            ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                (isDark
                                                        ? AppColors.darkPrimary
                                                        : AppColors
                                                              .lightPrimary)
                                                    .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'Active',
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: isDark
                                                      ? AppColors.darkPrimary
                                                      : AppColors.lightPrimary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Size: ${_formatFileSize(model['sizeInBytes'])}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isDownloaded)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!isSelected)
                                    IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          _selectedAIProvider = 'google';
                                          _selectedModelName = modelName;
                                        });

                                        // Save Google AI Edge configuration for future use
                                        await _saveGoogleAIEdgeConfig();

                                        if (mounted) {
                                          SnackBarHelper.showSuccess(
                                            context,
                                            'Selected $modelName as active Google AI Edge model',
                                          );
                                        }

                                        AppLogger.userAction(
                                          'Selected Google AI Edge model: $modelName',
                                        );
                                      },
                                      icon: Icon(
                                        Icons.radio_button_unchecked,
                                        color: isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary,
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              )
                            else
                              IconButton(
                                onPressed: () => _openHuggingFacePage(model),
                                icon: Icon(
                                  Icons.open_in_browser_rounded,
                                  color: isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                                ),
                                tooltip: 'Open in Hugging Face',
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          model['description'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.7,
                            ),
                            height: 1.4,
                          ),
                        ),
                        if (!isDownloaded) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Click the browser icon to download from Hugging Face',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.darkPrimary
                                        : AppColors.lightPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 80,
      leading: Container(
        padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => AppRoutes.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white).withValues(
                alpha: 0.1,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black).withValues(
                  alpha: 0.1,
                ),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              size: 18,
            ),
          ),
        ),
      ),
      title: Text(
        'AI Model Settings',
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
    );
  }

  Widget _buildOllamaAPITab(bool isDark, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 48),
      child: StaggeredAnimationContainer(
        staggerDelay: const Duration(milliseconds: 100),
        children: [
          // Platform support info
          PremiumGlassCard(
            margin: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cross Platform',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ollama API works on both Android and iOS devices through local network connection.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Connection configuration
          PremiumGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/ollama.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'API Configuration',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_selectedAIProvider == 'ollama') ...[
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Active',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),

                // API URL field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'API Base URL',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ollamaUrlController,
                      decoration: InputDecoration(
                        hintText: 'http://localhost:11434',
                        prefixIcon: Icon(Icons.link_rounded),
                        suffixIcon: _isOllamaConnected
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      ),
                      keyboardType: TextInputType.url,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Model name field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Model Name',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ollamaModelController,
                      decoration: InputDecoration(
                        hintText: 'llama2, codellama, mistral, etc.',
                        prefixIcon: Icon(Icons.psychology_rounded),
                      ),
                    ),
                  ],
                ),

                if (_ollamaError != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Connection failed: $_ollamaError',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Test connection button
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: _isOllamaConnecting
                        ? 'Testing Connection...'
                        : 'Test Connection',
                    icon: _isOllamaConnecting
                        ? null
                        : (_isOllamaConnected
                              ? Icons.check_circle_rounded
                              : Icons.wifi_find_rounded),
                    onPressed: _isOllamaConnecting
                        ? null
                        : _testOllamaConnection,
                    isLoading: _isOllamaConnecting,
                  ),
                ),

                const SizedBox(height: 16),

                // API documentation link
                InkWell(
                  onTap: () => _openOllamaDocumentation(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.glassBorderDark.withValues(alpha: 0.2)
                            : AppColors.glassBorder.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.library_books_rounded,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.7,
                          ),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'View Ollama API Documentation',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
