// Web stub implementation - minimal no-op implementation so web builds succeed.

class SpeechHelper {
  /// Initializes speech helper on web - returns false as web stub (not available)
  Future<bool> initialize({required Function(String) onStatus, required Function onError}) async {
    // Web: leave as unavailable
    return false;
  }

  Future<void> listen({required Function(dynamic) onResult}) async {
    // No-op for web
    return;
  }

  Future<void> stop() async {
    return;
  }
}
