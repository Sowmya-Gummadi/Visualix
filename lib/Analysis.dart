import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class SentimentAnalysisPage extends StatefulWidget {
  final Medium medium;

  SentimentAnalysisPage(this.medium);

  @override
  _SentimentAnalysisPageState createState() => _SentimentAnalysisPageState();
}

class _SentimentAnalysisPageState extends State<SentimentAnalysisPage> {
  String sentiment = 'Analyzing...';
  bool _faceDetected = false;
  double? _smilingProbability;
  String _analysisDetails = '';

  @override
  void initState() {
    super.initState();
    _performSentimentAnalysis();
  }

  Future<void> _performSentimentAnalysis() async {
    final file = await widget.medium.getFile();

    if (!file.existsSync()) {
      setState(() {
        sentiment = 'Error loading image';
        _analysisDetails = 'The image file could not be loaded.';
      });
      return;
    }

    final inputImage = InputImage.fromFile(file);
    final faceDetector = GoogleMlKit.vision.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      minFaceSize: 0.1,
    ));

    try {
      final faces = await faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          sentiment = 'neutral';
          _faceDetected = false;
          _analysisDetails = 'No face detected in the image. Defaulting to neutral sentiment.';
        });
        return;
      }

      // Analyze the first detected face
      final face = faces.first;
      _smilingProbability = face.smilingProbability;
      String detectedSentiment = 'neutral';

      if (_smilingProbability != null) {
        if (_smilingProbability! > 0.7) {
          detectedSentiment = 'happy';
        } else if (_smilingProbability! < 0.3) {
          detectedSentiment = 'sad';
        }
      }

      setState(() {
        sentiment = detectedSentiment;
        _faceDetected = true;
        _analysisDetails = _generateAnalysisDetails();
      });
    } catch (e) {
      print('Error processing image: $e');
      setState(() {
        sentiment = 'Error analyzing image';
        _analysisDetails = 'An error occurred while analyzing the image: $e';
      });
    } finally {
      faceDetector.close();
    }
  }

  String _generateAnalysisDetails() {
    if (!_faceDetected) {
      return 'No face detected in the image. The sentiment is set to neutral by default.';
    }

    String details = 'Face detected in the image.\n';
    details += 'Smiling probability: ${(_smilingProbability! * 100).toStringAsFixed(2)}%\n';

    if (_smilingProbability! > 0.7) {
      details += 'The high smiling probability indicates a happy sentiment.';
    } else if (_smilingProbability! < 0.3) {
      details += 'The low smiling probability indicates a sad sentiment.';
    } else {
      details += 'The moderate smiling probability indicates a neutral sentiment.';
    }

    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentiment Analysis'),
        backgroundColor: Colors.blueGrey.shade700,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/loading.gif'),
                      image: ThumbnailProvider(
                        mediumId: widget.medium.id,
                        mediumType: widget.medium.mediumType,
                        highQuality: true,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Detected Sentiment: $sentiment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                _buildSentimentEmoji(),
                SizedBox(height: 20),
                Text(
                  'Analysis Details:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  _analysisDetails,
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSentimentEmoji() {
    IconData iconData;
    Color iconColor;

    switch (sentiment.toLowerCase()) {
      case 'happy':
        iconData = Icons.sentiment_very_satisfied;
        iconColor = Colors.green;
        break;
      case 'sad':
        iconData = Icons.sentiment_very_dissatisfied;
        iconColor = Colors.red;
        break;
      case 'neutral':
        iconData = Icons.sentiment_neutral;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.error_outline;
        iconColor = Colors.grey;
    }

    return Icon(
      iconData,
      size: 64,
      color: iconColor,
    );
  }
}