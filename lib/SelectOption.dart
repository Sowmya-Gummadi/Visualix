import 'package:flutter/material.dart';
import 'package:mini_project/main.dart';
import 'package:mini_project/Sentiment.dart';
import 'package:mini_project/Camera.dart';
import 'package:mini_project/AboutUs.dart'; // Import the new page for 'About Us'

class SelectOption extends StatelessWidget {
  final bool showBackButton;

  const SelectOption({Key? key, this.showBackButton = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return showBackButton;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Select an Option',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey.shade700,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: showBackButton,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildOptionButton(
                context,
                'Edit / Circle to Search',
                Icons.edit,
                    () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const GalleryHome()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildOptionButton(
                context,
                'Sentimental Analysis of Pic',
                Icons.sentiment_satisfied,
                    () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SentimentPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildOptionButton(
                context,
                'Take a Pic',
                Icons.camera_alt,
                    () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 48.0),
          child: _buildAboutUsButton(context),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.blueGrey.shade600,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutUsButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.blueGrey.shade700,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AboutUsPage()),
        );
      },
      icon: Icon(Icons.info, color: Colors.white),
      label: Text("About Us", style: TextStyle(color: Colors.white)),
    );
  }
}