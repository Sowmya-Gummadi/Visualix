import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'dart:math';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraReady = false;
  File? _capturedImage;
  List<CameraDescription> cameras = [];
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _selectedCameraIndex = 0; // Start with the rear camera
    await _setupCamera();
  }

  Future<void> _setupCamera() async {
    _controller = CameraController(
      cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('Camera access denied');
            break;
          default:
            print('Camera error: ${e.description}');
            break;
        }
      }
    });
  }

  void _switchCamera() async {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    await _controller.dispose();
    setState(() {
      _isCameraReady = false;
    });
    await _setupCamera();
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        _capturedImage = File(image.path);
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _saveImage() async {
    if (_capturedImage == null) return;

    try {
      final result = await ImageGallerySaver.saveFile(_capturedImage!.path);
      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to gallery')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image')),
        );
      }
    } catch (e) {
      print('Error saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image')),
      );
    }

    setState(() {
      _capturedImage = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_capturedImage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Preview')),
        body: Column(
          children: [
            Expanded(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(
                  _controller.description.lensDirection == CameraLensDirection.front ? pi : 0,
                ),
                child: Image.file(_capturedImage!),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _capturedImage = null;
                    });
                  },
                  child: Text('Retake'),
                ),
                ElevatedButton(
                  onPressed: _saveImage,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    if (!_isCameraReady) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: _switchCamera,
                    child: Icon(Icons.flip_camera_ios),
                    mini: true,
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
