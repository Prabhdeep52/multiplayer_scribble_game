import 'package:flutter/material.dart';

class PlayerScore extends StatelessWidget {
  final List<Map> userData;
  const PlayerScore(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Modern Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.leaderboard_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Leaderboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Score List
          Expanded(
            child: userData.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 48,
                          color: Color(0xFFE0E0E0),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No scores yet",
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: userData.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      var data = userData[index].values.toList();
                      final username = data[0];
                      final points = data[1];

                      // Special styling for top 3
                      Color rankColor = const Color(0xFF6C7B8A);
                      IconData? medalIcon;

                      if (index == 0) {
                        rankColor = const Color(0xFFFFD700); // Gold
                        medalIcon = Icons.workspace_premium;
                      } else if (index == 1) {
                        rankColor = const Color(0xFFC0C0C0); // Silver
                        medalIcon = Icons.military_tech;
                      } else if (index == 2) {
                        rankColor = const Color(0xFFCD7F32); // Bronze
                        medalIcon = Icons.stars;
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: index < 3
                              ? Border.all(
                                  color: rankColor.withOpacity(0.3),
                                  width: 1.5,
                                )
                              : Border.all(
                                  color: const Color(0xFFF5F5F5),
                                  width: 1,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Rank/Medal
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: index < 3
                                    ? rankColor.withOpacity(0.1)
                                    : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: medalIcon != null
                                    ? Icon(
                                        medalIcon,
                                        color: rankColor,
                                        size: 20,
                                      )
                                    : Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                          color: const Color(0xFF495057),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Username
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF212529),
                                    ),
                                  ),
                                  if (index < 3)
                                    Text(
                                      index == 0
                                          ? "Champion"
                                          : index == 1
                                          ? "Runner-up"
                                          : "Third place",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: rankColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Points
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF667eea).withOpacity(0.1),
                                    const Color(0xFF764ba2).withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$points",
                                style: const TextStyle(
                                  color: Color(0xFF667eea),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Keep playing to climb the ranks!",
              style: TextStyle(
                color: const Color(0xFF9E9E9E),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
