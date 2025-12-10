import 'package:flutter/material.dart';

/// Progress Path Screen
/// Uses two images:
/// 1. Background image (progressPath.png) - starry background
/// 2. Path image (path.png) - the path overlay with nodes
///
/// Usage:
/// ```dart
/// ProgressPathScreen(
///   backgroundImage: 'assets/images/splash/progressPath.png',
///   pathImage: 'assets/images/splash/path.png',
/// )
/// ```
class ProgressPathScreen extends StatelessWidget {
  /// Background image asset path
  final String backgroundImage;

  /// Path overlay image asset path
  final String pathImage;

  /// Optional callback when screen is tapped
  final VoidCallback? onTap;

  const ProgressPathScreen({
    super.key,
    this.backgroundImage = 'assets/images/splash/progressPath.png',
    this.pathImage = 'assets/images/splash/path.png',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: onTap,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Your Progress Path',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Path image - full width, maintains aspect ratio
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      pathImage,
                      width: screenWidth,
                      fit: BoxFit.fitWidth,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Alternative version with background scrolling together
class ProgressPathScreenV2 extends StatelessWidget {
  final String backgroundImage;
  final String pathImage;
  final VoidCallback? onTap;

  const ProgressPathScreenV2({
    super.key,
    this.backgroundImage = 'assets/images/splash/progressPath.png',
    this.pathImage = 'assets/images/splash/path.png',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF050515),
      body: GestureDetector(
        onTap: onTap,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                // Background image - scrolls with content
                Positioned.fill(
                  child: Image.asset(
                    backgroundImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),

                // Content
                Column(
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Your Progress Path',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Path image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset(
                        pathImage,
                        width: screenWidth,
                        fit: BoxFit.fitWidth,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Version 3: Fixed background, scrollable path with intrinsic height
class ProgressPathScreenV3 extends StatelessWidget {
  final String backgroundImage;
  final String pathImage;
  final VoidCallback? onTap;

  const ProgressPathScreenV3({
    super.key,
    this.backgroundImage = 'assets/images/splash/progressPath.png',
    this.pathImage = 'assets/images/splash/path.png',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: Fixed background image
            Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            // Layer 2: Scrollable content
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        'Your Progress Path',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Path image - takes full width, height based on aspect ratio
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Image.asset(
                          pathImage,
                          fit: BoxFit.fitWidth,
                          width: double.infinity,
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}