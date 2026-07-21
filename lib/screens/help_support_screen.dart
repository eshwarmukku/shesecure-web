import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _openPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'SheSecure Support Request'},
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _supportCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2939),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.greenAccent.withOpacity(0.15),
          child: Icon(icon, color: Colors.greenAccent),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white54,
          size: 16,
        ),
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2939),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.5,
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
          "Help & Support",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
                "How can we help?",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Find answers, contact support, or report an issue.",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),

              _supportCard(
                icon: Icons.call_rounded,
                title: "Call Support",
                subtitle: "Speak to the SheSecure help team",
                onTap: () => _openPhone("+919876543210"),
              ),
              _supportCard(
                icon: Icons.email_rounded,
                title: "Email Support",
                subtitle: "Send us a message about your issue",
                onTap: () => _openEmail("support@shesecure.com"),
              ),
              _supportCard(
                icon: Icons.report_problem_rounded,
                title: "Report a Problem",
                subtitle: "Tell us about app bugs or emergency issues",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Report issue form coming soon"),
                    ),
                  );
                },
              ),
              _supportCard(
                icon: Icons.info_rounded,
                title: "About SheSecure",
                subtitle: "Learn how the app protects users",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: const Color(0xFF1D2939),
                      title: Text(
                        "About SheSecure",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      content: Text(
                        "SheSecure is an AI-based women safety app designed to predict risk, detect distress, and respond automatically.",
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),
              Text(
                "Frequently Asked Questions",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),

              _faqItem(
                "How does SheSecure detect danger?",
                "It analyzes location, time, surroundings, and voice signals to estimate risk and trigger safety actions.",
              ),
              _faqItem(
                "How do I add emergency contacts?",
                "Open Emergency Contacts from the home screen, tap the + button, and save trusted people to your account.",
              ),
              _faqItem(
                "Why is SOS not notifying contacts?",
                "Make sure contacts are added for the same logged-in user ID and that the backend is running correctly.",
              ),
              _faqItem(
                "Can I turn off auto alerts?",
                "Yes, open Privacy & Security and switch off the auto emergency alert option.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
