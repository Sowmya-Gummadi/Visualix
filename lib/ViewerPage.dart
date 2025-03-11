import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'LensView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class ViewerPage extends StatefulWidget {
  final Medium medium;
  ViewerPage(this.medium);

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  GlobalKey<SignatureState> sState = GlobalKey();
  File? imageFile;
  img.Image? croppedImage;

  @override
  void initState() {
    super.initState();
    loadImageFile();
  }

  img.Image? originalImage;
  Future<void> loadImageFile() async {
    imageFile = await widget.medium.getFile();

    final bytes = imageFile!.readAsBytesSync();
    originalImage = img.decodeImage(bytes);
    setState(() {
      imageFile;
    });
  }

  Offset topLeft = Offset.zero;
  Offset rightBottom = Offset.zero;

  Offset topLeft0 = Offset.zero;
  Offset rightBottom0 = Offset.zero;

  void cropImage() {
    if (imageFile == null) {
      print("Image file is null");
      return;
    }

    final bytes = imageFile!.readAsBytesSync();
    img.Image? cImage = img.decodeImage(bytes);
    final size = sState.currentContext!.size;
    final scaleX = cImage!.width / size!.width;
    final scaleY = cImage!.height / size!.height;
    if (cImage == null) {
      print("Could not decode image");
      return;
    }

    if (size == null) {
      print("Signature widget size is null");
      return;
    }

    var points = sState.currentState?.points
        .where((e) => e != null)
        .map((e) => Offset(e!.dx * scaleX, e.dy * scaleY))
        .toList();

    if (points == null || points.isEmpty) {
      print("No signature points found");
      return;
    }

    topLeft = points[0];
    rightBottom = points[0];

    for (var point in points) {
      if (point.dx < topLeft.dx) topLeft = Offset(point.dx, topLeft.dy);
      if (point.dy < topLeft.dy) topLeft = Offset(topLeft.dx, point.dy);
      if (point.dx > rightBottom.dx)
        rightBottom = Offset(point.dx, rightBottom.dy);
      if (point.dy > rightBottom.dy)
        rightBottom = Offset(rightBottom.dx, point.dy);
    }

    final cropX = topLeft.dx.toInt();
    final cropY = topLeft.dy.toInt();
    final cropWidth = (rightBottom.dx - topLeft.dx).toInt();
    final cropHeight = (rightBottom.dy - topLeft.dy).toInt();

    if (cropWidth <= 0 || cropHeight <= 0) {
      print("Invalid crop dimensions");
      return;
    }

    topLeft0 = Offset(topLeft.dx / scaleX, topLeft.dy / scaleY);
    rightBottom0 = Offset(rightBottom.dx / scaleX, rightBottom.dy / scaleY);

    croppedImage = img.copyCrop(cImage,
        x: cropX, y: cropY, width: cropWidth, height: cropHeight);
    sState = GlobalKey();
    points.clear();

    setState(() {
      croppedImage;
    });
    uploadCroppedImage();
  }

  uploadCroppedImage() async {
    final bytes = img.encodePng(croppedImage!);
    final tempDire = await Directory.systemTemp.createTemp();
    final tempFile = await File(tempDire.path + "temp.png").writeAsBytes(bytes);

    final apiKey = "9e3b2288b177548adc64649af14b4744";
    final url =
        Uri.parse("https://api.imgbb.com/1/upload?expiration=100&key=$apiKey");
    final request = http.MultipartRequest('POST', url);
    request.files
        .add(await http.MultipartFile.fromPath("image", tempFile.path));
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseString);
    final imageUrl = jsonResponse['data']['display_url'];
    print(imageUrl);
    final searchUrl = 'https://lens.google.com/uploadbyurl?url=$imageUrl';
    print(searchUrl);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LensView(searchUrl);
    }));
  }

  bool isEnabled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.medium.filename.toString(), // Dynamically show file name
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade700,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: Uint8List.fromList(img
                        .encodePng(originalImage!)), // <-- Uint8List of image
                  ),
                ),
              ).then((value) async {
                if(value != null){
                  setState(() {
                    originalImage = img.decodeImage(value);
                  });
                  final result =
                      await ImageGallerySaver.saveImage(value);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.edit),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                if (isEnabled) {
                  isEnabled = false;
                } else {
                  isEnabled = true;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(isEnabled
                  ? Icons.remove_red_eye_sharp
                  : Icons.remove_red_eye_outlined),
            ),
          ),
        ],
      ),
      body: InkWell(
        onLongPress: () {
          setState(() {
            if (isEnabled) {
              isEnabled = false;
            } else {
              isEnabled = true;
            }
          });
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 100,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child:
                  // croppedImage != null
                  //     ? Image.memory(Uint8List.fromList(img.encodePng(croppedImage !)))
                  //     :
                  imageFile != null
                      ? Stack(
                          children: [
                            originalImage != null
                                ? Image.memory(Uint8List.fromList(
                                        img.encodePng(originalImage!)),
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                                  )
                                : Image.file(
                                    imageFile!,
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                  ),
                            (isEnabled && croppedImage != null)
                                ? Positioned(
                                    left: topLeft0.dx,
                                    top: topLeft0.dy,
                                    width: (rightBottom0.dx - topLeft0.dx),
                                    height: (rightBottom0.dy - topLeft0.dy),
                                    child: Image.asset(
                                      "images/frame.png",
                                      fit: BoxFit.fill,
                                    )
                                        .animate()
                                        .scale()
                                        .tint(color: Colors.blueGrey.shade700))
                                : Container()
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
            ),
            isEnabled
                ? Positioned(
                    left: 0,
                    top: 100,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: Listener(
                      child: Container(
                        color: Colors.transparent,
                        child: Signature(
                          key: sState,
                        ),
                      ),
                      onPointerDown: (v) {
                        print("Pointer down");
                      },
                      onPointerUp: (v) {
                        print("Pointer up");
                        cropImage();
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
