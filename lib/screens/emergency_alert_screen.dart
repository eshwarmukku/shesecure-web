import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/alert_service.dart';
import '../services/session_manager.dart';

class EmergencyAlertScreen extends StatefulWidget {
  const EmergencyAlertScreen({super.key});

  @override
  State<EmergencyAlertScreen> createState() => _EmergencyAlertScreenState();
}

class _EmergencyAlertScreenState extends State<EmergencyAlertScreen> {
  bool isAlertActive = false;
  bool locationShared = false;
  bool contactsNotified = false;
  int? userId;
  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final id = await SessionManager.getUserId();
    setState(() {
      userId = id;
    });
  }

  Future<void> triggerAlert() async {
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    setState(() {
      isAlertActive = true;
    });

    try {
      final result = await AlertService.triggerAlert(userId!);

      setState(() {
        locationShared = true;
        contactsNotified = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Alert sent to ${result["contacts_notified"]} contacts",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to trigger alert: $e")));
    }
  }

  Future<void> _callNumber(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    try {
      await launchUrl(uri);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Dialer error: $e")));
    }
  }

  void cancelAlert() {
    setState(() {
      isAlertActive = false;
      locationShared = false;
      contactsNotified = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Emergency alert cancelled")));
  }

  Widget _statusCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
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
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
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
    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101828),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Emergency Alert",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SOS mode",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "This screen is used when danger is detected or SOS is triggered.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isAlertActive
                      ? Colors.redAccent.withOpacity(0.15)
                      : const Color(0xFF1D2939),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAlertActive ? Colors.redAccent : Colors.white12,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isAlertActive
                          ? Icons.warning_rounded
                          : Icons.shield_rounded,
                      color: isAlertActive
                          ? Colors.redAccent
                          : Colors.greenAccent,
                      size: 70,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isAlertActive ? "Alert Active" : "Safe Mode",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAlertActive
                          ? "Emergency response is active. Contacts are being notified."
                          : "Tap the SOS button if you are in danger.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isAlertActive ? cancelAlert : triggerAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAlertActive
                              ? Colors.grey
                              : Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isAlertActive ? "Cancel Alert" : "Trigger SOS",
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

              const SizedBox(height: 24),

              Text(
                "Alert Status",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              _statusCard(
                icon: Icons.location_on_rounded,
                title: "Live Location",
                value: locationShared
                    ? "Shared with trusted contacts"
                    : "Not shared",
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 12),

              _statusCard(
                icon: Icons.contacts_rounded,
                title: "Emergency Contacts",
                value: contactsNotified
                    ? "Contacts notified"
                    : "Not notified yet",
                color: Colors.purpleAccent,
              ),
              const SizedBox(height: 12),

              _statusCard(
                icon: Icons.phone_in_talk_rounded,
                title: "Police / Help Line",
                value: "Quick call available",
                color: Colors.greenAccent,
              ),
              const SizedBox(height: 12),

              _statusCard(
                icon: Icons.local_hospital_rounded,
                title: "Nearest Hospital",
                value: "Quick access available",
                color: Colors.orangeAccent,
              ),

              const SizedBox(height: 24),

              Text(
                "Quick Actions",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      title: "Call Police",
                      icon: Icons.local_police_rounded,
                      color: Colors.blueAccent,
                      onTap: () {
                        _callNumber("112");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Calling police...")),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      title: "Call Hospital",
                      icon: Icons.local_hospital_rounded,
                      color: Colors.redAccent,
                      onTap: () {
                        _callNumber("108");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Calling hospital...")),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      title: "Share Location",
                      icon: Icons.share_location_rounded,
                      color: Colors.greenAccent,
                      onTap: () {
                        setState(() {
                          locationShared = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Location shared")),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      title: "Notify Contacts",
                      icon: Icons.notification_important_rounded,
                      color: Colors.purpleAccent,
                      onTap: () async {
                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("User not loaded")),
                          );
                          return;
                        }

                        try {
                          final result = await AlertService.triggerAlert(
                            userId!,
                          );

                          setState(() {
                            contactsNotified = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Notified ${result["contacts_notified"]} contacts",
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Notification failed: $e")),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1D2939),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
