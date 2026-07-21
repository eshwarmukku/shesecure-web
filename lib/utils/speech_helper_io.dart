// IO implementation that wraps speech_to_text and permission_handler for mobile/desktop
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechHelper {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<bool> initialize({required Function(String) onStatus, required Function(dynamic) onError}) async {
    final permission = await Permission.microphone.request();
    if (!permission.isGranted) return false;

    final available = await _speech.initialize(
      onStatus: (status) => onStatus(status),
      onError: (err) => onError(err),
    );

    return available;
  }

  Future<void> listen({required Function(dynamic) onResult}) async {
    await _speech.listen(
      onResult: onResult,
      listenMode: stt.ListenMode.confirmation,
      partialResults: true,
      listenFor: const Duration(seconds: 20),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
