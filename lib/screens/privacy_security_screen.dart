import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool biometricLock = true;
  bool shareLiveLocation = true;
  bool emergencyAutoAlert = true;
  bool allowBackgroundMonitoring = true;
  bool showProfilePublicly = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      biometricLock = prefs.getBool('biometricLock') ?? true;
      shareLiveLocation = prefs.getBool('shareLiveLocation') ?? true;
      emergencyAutoAlert = prefs.getBool('emergencyAutoAlert') ?? true;
      allowBackgroundMonitoring =
          prefs.getBool('allowBackgroundMonitoring') ?? true;
      showProfilePublicly = prefs.getBool('showProfilePublicly') ?? false;
    });
  }

  Future<void> saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget settingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2939),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.purpleAccent.withOpacity(0.15),
            child: Icon(icon, color: Colors.purpleAccent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF7F56D9),
          ),
        ],
      ),
    );
  }

  Widget infoCard(String title, String description, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2939),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent.withOpacity(0.15),
            child: Icon(icon, color: Colors.blueAccent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('biometricLock');
    await prefs.remove('shareLiveLocation');
    await prefs.remove('emergencyAutoAlert');
    await prefs.remove('allowBackgroundMonitoring');
    await prefs.remove('showProfilePublicly');

    setState(() {
      biometricLock = true;
      shareLiveLocation = true;
      emergencyAutoAlert = true;
      allowBackgroundMonitoring = true;
      showProfilePublicly = false;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Privacy settings reset")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101828),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Privacy & Security",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const ClampingScrollPhysics(), // Removes the elastic bounce/stretch behavior
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Control your safety preferences",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Choose what SheSecure can access and how it behaves in the background.",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              infoCard(
                "Your data stays private",
                "These settings control only app behavior on this device.",
                Icons.lock_rounded,
              ),

              settingSwitch(
                title: "Biometric Lock",
                subtitle: "Require fingerprint or face unlock to open the app.",
                value: biometricLock,
                icon: Icons.fingerprint_rounded,
                onChanged: (value) async {
                  setState(() => biometricLock = value);
                  await saveSetting('biometricLock', value);
                },
              ),

              settingSwitch(
                title: "Share Live Location",
                subtitle:
                    "Allow trusted contacts to see your live location during SOS.",
                value: shareLiveLocation,
                icon: Icons.location_on_rounded,
                onChanged: (value) async {
                  setState(() => shareLiveLocation = value);
                  await saveSetting('shareLiveLocation', value);
                },
              ),

              settingSwitch(
                title: "Auto Emergency Alert",
                subtitle:
                    "Trigger alert automatically when danger is detected.",
                value: emergencyAutoAlert,
                icon: Icons.warning_rounded,
                onChanged: (value) async {
                  setState(() => emergencyAutoAlert = value);
                  await saveSetting('emergencyAutoAlert', value);
                },
              ),

              settingSwitch(
                title: "Background Monitoring",
                subtitle:
                    "Let the app monitor voice and safety in the background.",
                value: allowBackgroundMonitoring,
                icon: Icons.notifications_active_rounded,
                onChanged: (value) async {
                  setState(() => allowBackgroundMonitoring = value);
                  await saveSetting('allowBackgroundMonitoring', value);
                },
              ),

              settingSwitch(
                title: "Public Profile Visibility",
                subtitle:
                    "Show profile details to others in community features.",
                value: showProfilePublicly,
                icon: Icons.visibility_rounded,
                onChanged: (value) async {
                  setState(() => showProfilePublicly = value);
                  await saveSetting('showProfilePublicly', value);
                },
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: resetSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Reset Settings",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
