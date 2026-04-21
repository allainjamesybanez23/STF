import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  late FlutterTts flutterTts;

  Future<void> init() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> speakZoneStatus(String zone) async {
    String message = switch (zone) {
      'RED' => 'Heavy traffic. Cut your engine to save fuel.',
      'CAUTION' => 'Slow traffic ahead. Proceed carefully.',
      'GREEN' => 'Open road. Drive freely and efficiently.',
      _ => 'Safe driving ahead.',
    };
    await flutterTts.speak(message);
  }

  Future<void> speak(String message) async {
    if (message.isNotEmpty) {
      await flutterTts.speak(message);
    }
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}
