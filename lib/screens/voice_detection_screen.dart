import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceDetectionScreen extends StatefulWidget {
  const VoiceDetectionScreen({super.key});

  @override
  State<VoiceDetectionScreen> createState() => _VoiceDetectionScreenState();
}

class _VoiceDetectionScreenState extends State<VoiceDetectionScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  bool _speechAvailable = false;
  bool _isDangerDetected = false;
  String _status = "Tap the button to start voice monitoring.";
  String _lastWords = "";

  final List<String> distressKeywords = [
    "help",
    "save me",
    "danger",
    "police",
    "emergency",
    "attack",
    "stop",
    "bachao",
    "madad",
    "help me",
  ];

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final permission = await Permission.microphone.request();

    if (!permission.isGranted) {
      setState(() {
        _status = "Microphone permission denied.";
      });
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (!mounted) return;
        setState(() {
          _status = "Speech status: $status";
          if (status == "done" || status == "notListening") {
            _isListening = false;
          }
        });
      },
      onError: (errorNotification) {
        if (!mounted) return;
        setState(() {
          _status = "Speech error: ${errorNotification.errorMsg}";
          _isListening = false;
        });
      },
    );

    if (!mounted) return;
    setState(() {
      _speechAvailable = available;
      _status = available
          ? "Voice monitoring ready."
          : "Speech recognition not available on this device.";
    });
  }

  void _startListening() async {
    if (!_speechAvailable) return;

    setState(() {
      _isDangerDetected = false;
      _lastWords = "";
      _isListening = true;
      _status = "Listening for distress words...";
    });

    await _speech.listen(
      onResult: (result) {
        final words = result.recognizedWords.toLowerCase();

        if (!mounted) return;
        setState(() {
          _lastWords = result.recognizedWords;
        });

        for (final keyword in distressKeywords) {
          if (words.contains(keyword)) {
            _triggerDangerAlert(keyword);
            break;
          }
        }
      },
      listenMode: stt.ListenMode.confirmation,
      partialResults: true,
      listenFor: const Duration(seconds: 20),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _status = "Monitoring stopped.";
    });
  }

  void _triggerDangerAlert(String keyword) {
    setState(() {
      _isDangerDetected = true;
      _isListening = false;
      _status = "Distress keyword detected: \"$keyword\"";
    });

    _speech.stop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Emergency threat detected. Alert should be triggered."),
        backgroundColor: Colors.redAccent,
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1D2939),
          title: const Text(
            "Danger Detected",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "A distress phrase was detected. You can now trigger SOS, notify contacts, and share live location.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("SOS flow can start here."),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text(
                "Trigger SOS",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2939),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _isDangerDetected
        ? Colors.redAccent
        : _isListening
        ? Colors.orangeAccent
        : Colors.greenAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101828),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Voice Distress Detection",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AI voice monitoring",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "The app checks for distress phrases and can help trigger an alert.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D2939),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 92,
                      width: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withOpacity(0.15),
                      ),
                      child: Icon(
                        _isDangerDetected
                            ? Icons.warning_rounded
                            : _isListening
                            ? Icons.mic_rounded
                            : Icons.mic_off_rounded,
                        color: statusColor,
                        size: 46,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isDangerDetected
                          ? "Danger detected"
                          : _isListening
                          ? "Listening..."
                          : "Idle",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _lastWords.isEmpty
                          ? "No speech detected yet"
                          : _lastWords,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isListening
                            ? _stopListening
                            : _startListening,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isListening
                              ? Colors.redAccent
                              : const Color(0xFF7F56D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _isListening ? "Stop Listening" : "Start Listening",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _infoCard(
                icon: Icons.bolt_rounded,
                title: "Detected Words",
                value: _lastWords.isEmpty ? "None" : _lastWords,
                iconColor: Colors.blueAccent,
              ),

              const SizedBox(height: 14),

              _infoCard(
                icon: Icons.shield_rounded,
                title: "Safety Status",
                value: _isDangerDetected
                    ? "Threat alert active"
                    : "Normal monitoring",
                iconColor: _isDangerDetected
                    ? Colors.redAccent
                    : Colors.greenAccent,
              ),

              const SizedBox(height: 14),

              _infoCard(
                icon: Icons.notifications_active_rounded,
                title: "Action",
                value: _isDangerDetected
                    ? "SOS can be triggered now"
                    : "Waiting for distress signal",
                iconColor: Colors.orangeAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
