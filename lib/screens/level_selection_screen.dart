import 'package:flutter/material.dart';
import 'beginner_sessions_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFAFA),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Header
                const Text(
                  'Choose Your',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'Practice Level',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF40E0D0),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Select the level that matches your experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 36),

                // Beginner Card
                _buildLevelCard(
                  context,
                  title: 'Beginner',
                  subtitle: 'New to yoga or returning after a break',
                  description: 'Perfect for those just starting their yoga journey with gentle, guided sessions.',
                  imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=600',
                  color: const Color(0xFF40E0D0),
                  features: ['Chair support', 'Gentle pace', 'Safety first'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BeginnerSessionsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Intermediate Card
                _buildLevelCard(
                  context,
                  title: 'Intermediate',
                  subtitle: 'Comfortable with basic poses',
                  description: 'Build on your foundation with more challenging sequences and longer holds.',
                  imageUrl: 'https://images.unsplash.com/photo-1599901860904-17e6ed7083a0?w=600',
                  color: const Color(0xFF35C9BA), // Slightly different turquoise shade
                  features: ['Build strength', 'Flexibility', 'Balance'],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: Color(0xFF40E0D0),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Advanced Card
                _buildLevelCard(
                  context,
                  title: 'Advanced',
                  subtitle: 'Experienced and flexible',
                  description: 'Challenge yourself with complex poses and advanced breathing techniques.',
                  imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600',
                  color: const Color(0xFF2AB5A5), // Darker turquoise shade
                  features: ['Deep practice', 'Advanced poses', 'Mastery'],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Coming soon!'),
                        backgroundColor: Color(0xFF40E0D0),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required String description,
        required String imageUrl,
        required Color color,
        required List<String> features,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Features
                  Row(
                    children: features.map((feature) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}