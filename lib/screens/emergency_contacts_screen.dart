import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/contact_model.dart';
import '../services/contact_service.dart';
import '../services/session_manager.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController relationController = TextEditingController();

  List<ContactModel> contacts = [];

  bool isLoading = true;

  int? userId;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    final storedUserId = await SessionManager.getUserId();

    setState(() {
      userId = storedUserId;
    });

    if (userId != null) {
      loadContacts();
    }
  }

  Future<void> loadContacts() async {
    try {
      final data = await ContactService.fetchContacts(userId!);

      setState(() {
        contacts = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> addContact() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        relationController.text.isEmpty) {
      return;
    }

    final success = await ContactService.addContact(
      userId: userId!,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      relation: relationController.text.trim(),
    );

    if (success) {
      Navigator.pop(context);

      nameController.clear();
      phoneController.clear();
      relationController.clear();

      loadContacts();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Contact added")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add contact")));
    }
  }

  void showAddContactDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D2939),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputField(nameController, "Name"),
                const SizedBox(height: 14),

                _inputField(phoneController, "Phone Number"),
                const SizedBox(height: 14),

                _inputField(relationController, "Relation"),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: addContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7F56D9),
                    ),
                    child: Text(
                      "Save Contact",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inputField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF101828),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget contactCard(ContactModel contact) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF1D2939),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.purpleAccent.withOpacity(0.2),

            child: Text(
              contact.name[0],
              style: const TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  contact.phone,
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),

                const SizedBox(height: 4),

                Text(
                  contact.relation,
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded, color: Colors.greenAccent),
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

        title: Text(
          "Emergency Contacts",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7F56D9),
        onPressed: showAddContactDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trusted contacts",
              style: GoogleFonts.poppins(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : contacts.isEmpty
                  ? Center(
                      child: Text(
                        "No contacts added",
                        style: GoogleFonts.poppins(color: Colors.white54),
                      ),
                    )
                  : ListView.separated(
                      itemCount: contacts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),

                      itemBuilder: (context, index) {
                        return contactCard(contacts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
