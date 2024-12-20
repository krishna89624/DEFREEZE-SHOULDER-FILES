import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool showContent = false;

  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Set up scaling animation for logo
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Set up fade animation for texts
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Delay to show content after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showContent = true;
      });

      // Navigate to 'LoginOptions' after another 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushNamed('/LoginOptions');
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    double baseFontSize = screenSize.width * 0.045; // Base font size for scaling

    return Scaffold(
      body: Container(
        color: showContent ? Color(0xFF2DC2D7) : Colors.white,
        child: Center(
          child: !showContent
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF2DC2D7), width: 5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset(
                    'assets/logo2.png',
                    width: screenSize.width * 0.5,
                    height: screenSize.width * 0.5,
                  ),
                ),
              ),
            ],
          )
              : Stack(
            children: [
              // Top-left static background circle
              Positioned(
                top: -screenSize.height * 0.15,
                left: -screenSize.width * 0.3,
                child: Container(
                  width: screenSize.width * 0.99,
                  height: screenSize.width * 1.09,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(225),
                  ),
                ),
              ),
              // Bottom-right static background circle
              Positioned(
                bottom: -screenSize.height * 0.18,
                right: -screenSize.width * 0.35,
                child: Container(
                  width: screenSize.width * 0.99,
                  height: screenSize.width * 1.09,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(225),
                  ),
                ),
              ),
              // Centered greeting text
              Positioned(
                top: screenSize.height * 0.2,
                left: screenSize.width * 0.2,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(fontSize: baseFontSize, color: Colors.black),
                      ),
                      Text(
                        'Ortho Care',
                        style: TextStyle(
                          fontSize: baseFontSize * 1.5,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.5,
                left: screenSize.width * 0.4,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'We care for',
                    style: TextStyle(
                      fontSize: baseFontSize * 1.2,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenSize.height * 0.53,
                left: screenSize.width * 0.42,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'you',
                    style: TextStyle(
                      fontSize: baseFontSize * 1.2,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
