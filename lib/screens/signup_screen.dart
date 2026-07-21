import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleSignup() async {
    setState(() => isLoading = true);

    try {
      final result = await AuthService.signup(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (!mounted) return;

      if (result.containsKey("token")) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Signup successful")));
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["detail"] ?? "Signup failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Join SheSecure for smarter safety.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 30),
              _input(fullNameController, "Full Name"),
              const SizedBox(height: 16),
              _input(emailController, "Email"),
              const SizedBox(height: 16),
              _input(phoneController, "Phone"),
              const SizedBox(height: 16),
              _input(passwordController, "Password", obscure: true),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7F56D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text("Already have an account? Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF1D2939),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
