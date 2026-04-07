import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    await _tts.setLanguage('zh-CN');
    await _tts.setSpeechRate(0.4);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // iOS specific
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    await init();
    await _tts.speak(text);
  }

  Future<void> speakCharacter(String character, String pinyin) async {
    await init();
    // Speak the character/word directly
    await _tts.speak(character);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
