import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome to Visualix!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Visualix is designed to provide a seamless experience for managing your photo gallery, sentiment analysis, and much more.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.photo_library, size: 20, color: Colors.blueGrey.shade700),
                    SizedBox(width: 8),
                    Text(
                      'Key Features:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '- Photo Gallery Management: Effortlessly browse, view, and organize your images into albums.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '- Sentiment Analysis: Analyze your photos to understand emotions captured in them.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '- Capture and Edit: Take new photos and apply creative edits with real-time feedback.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '- About Us Section: Get detailed insights about the app and the team behind it.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.help, size: 20, color: Colors.blueGrey.shade700),
                    SizedBox(width: 8),
                    Text(
                      'How to Use:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '- Photo Gallery Management: Navigate to the "Gallery" option from the main menu to view and organize your photos. Use the grid layout to browse and select albums.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '- Sentiment Analysis: Select the "Sentimental Analysis" option to upload or capture a photo, and the app will analyze the emotions associated with that image.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '- Capture and Edit: Use the "Take a Pic" option to capture new photos. Apply filters and edits using real-time preview to enhance your images.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '- About Us Section: Access this section from the main menu to learn more about the app features, the team behind it, and how you can get support.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.person, size: 20, color: Colors.blueGrey.shade700),
                    SizedBox(width: 8),
                    Text(
                      'Developed by:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Satwika Pulluri',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Varshitha Papishetty',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Sowmya Gummadi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Back to Select Options'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}