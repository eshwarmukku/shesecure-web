// Conditional export to select platform-specific implementation
export 'speech_helper_io.dart' if (dart.library.html) 'speech_helper_web.dart';
