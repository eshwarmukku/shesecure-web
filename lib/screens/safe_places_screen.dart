import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafePlacesScreen extends StatelessWidget {
  const SafePlacesScreen({super.key});

  final List<SafePlace> places = const [
    SafePlace(
      name: "Anna Nagar Police Station",
      type: "Police Station",
      distance: "1.2 km",
      icon: Icons.local_police_rounded,
      color: Colors.blueAccent,
    ),
    SafePlace(
      name: "Apollo Hospital",
      type: "Hospital",
      distance: "1.8 km",
      icon: Icons.local_hospital_rounded,
      color: Colors.redAccent,
    ),
    SafePlace(
      name: "Women Helpline Center",
      type: "Helpline",
      distance: "900 m",
      icon: Icons.support_agent_rounded,
      color: Colors.purpleAccent,
    ),
    SafePlace(
      name: "Phoenix Mall",
      type: "Public Safe Place",
      distance: "2.4 km",
      icon: Icons.location_city_rounded,
      color: Colors.greenAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101828),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101828),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Nearby Safe Places",
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
                "Trusted places near you",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Find the closest safe location in case of emergency.",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D2939),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.security_rounded,
                        color: Colors.purpleAccent,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Safety Mode Active",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Nearby locations are shown based on your current position.",
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return _safePlaceCard(context, place);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _safePlaceCard(BuildContext context, SafePlace place) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1D2939),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: place.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(place.icon, color: place.color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place.type,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      place.distance,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Opening ${place.name} on map"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F56D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Open Map",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Calling ${place.name}")),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Call",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SafePlace {
  final String name;
  final String type;
  final String distance;
  final IconData icon;
  final Color color;

  const SafePlace({
    required this.name,
    required this.type,
    required this.distance,
    required this.icon,
    required this.color,
  });
}
