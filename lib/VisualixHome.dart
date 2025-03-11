import 'package:flutter/material.dart';
import 'SelectOption.dart'; // Import the SelectOption page

class VisualixHome extends StatefulWidget {
  const VisualixHome({Key? key}) : super(key: key);

  @override
  _VisualixHomeState createState() => _VisualixHomeState();
}

class _VisualixHomeState extends State<VisualixHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration for the zoom-in animation
    );

    // Define the animation (scale from 0.5 to 1.0)
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // Navigate to the next page after 5 seconds
    _startTimer();
  }

  @override
  void dispose() {
    // Dispose the animation controller
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SelectOption(), // Navigate to SelectOption
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'images/img.png', // Replace with the correct path to your image asset
            width: 800, // Adjust the width as needed
            height: 900, // Adjust the height as needed
          ),
        ),
      ),
    );
  }
}