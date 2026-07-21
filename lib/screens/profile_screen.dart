import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = "";
  String email = "";
  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final storedName = await SessionManager.getFullName();
    final storedEmail = await SessionManager.getEmail();
    final storedUserId = await SessionManager.getUserId();

    if (!mounted) return;

    setState(() {
      fullName = storedName ?? "User";
      email = storedEmail ?? "No email";
      userId = storedUserId;
      isLoading = false;
    });
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _settingTile({
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
          backgroundColor: Colors.purpleAccent.withOpacity(0.15),
          child: Icon(icon, color: Colors.purpleAccent),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101828),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Profile & Settings",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D2939),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 38,
                            backgroundColor: Colors.purpleAccent.withOpacity(
                              0.2,
                            ),
                            child: Text(
                              fullName.isNotEmpty
                                  ? fullName[0].toUpperCase()
                                  : "U",
                              style: GoogleFonts.poppins(
                                color: Colors.purpleAccent,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            fullName,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            userId != null ? "User ID: $userId" : "",
                            style: GoogleFonts.poppins(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Settings",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _settingTile(
                      icon: Icons.edit_rounded,
                      title: "Edit Profile",
                      subtitle: "Update your personal details",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Edit Profile screen coming soon"),
                          ),
                        );
                      },
                    ),
                    _settingTile(
                      icon: Icons.notifications_active_rounded,
                      title: "Notifications",
                      subtitle: "Manage emergency alert preferences",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Notification settings coming soon"),
                          ),
                        );
                      },
                    ),
                    _settingTile(
                      icon: Icons.lock_rounded,
                      title: "Privacy & Security",
                      subtitle: "Manage login and safety options",
                      onTap: () {
                        Navigator.pushNamed(context, '/privacy-security');
                      },
                    ),
                    _settingTile(
                      icon: Icons.help_outline_rounded,
                      title: "Help & Support",
                      subtitle: "Get help using SheSecure",
                      onTap: () {
                        Navigator.pushNamed(context, '/help-support');
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Logout",
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
      ),
    );
  }
}
