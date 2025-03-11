import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import 'AlbumPage.dart';  // Import the AlbumPage screen
import 'dart:io';  // Import Platform from dart:io
import 'SelectOption.dart';  // Import SelectOption
import 'VisualixHome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VisualixHome(), // Set VisualixHome as the home
    );
  }
}

class GalleryHome extends StatefulWidget {
  const GalleryHome({super.key});

  @override
  State<GalleryHome> createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  requestPermissions() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        loadAllAlbums();
      }
    } else if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted &&
              await Permission.videos.request().isGranted) {
        loadAllAlbums();
      }
    }
  }

  List<Album> albums = [];
  loadAllAlbums() async {
    albums = await PhotoGallery.listAlbums();
    setState(() {
      albums;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = (MediaQuery.of(context).size.width - 15) / 3;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visualix',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade700,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SelectOption();  // Navigate to SelectOptionPage
            }));
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 3, right: 3, top: 3),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (BuildContext ctx, int index) {
            Album album = albums[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AlbumPage(album);
                }));
              },
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: AlbumThumbnailProvider(
                              album: album, highQuality: true),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      album.name.toString(),
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Align(
                    child: Text(
                      album.count.toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                    alignment: Alignment.centerLeft,
                  )
                ],
              ),
            );
          },
          itemCount: albums.length,
        ),
      ),
    );
  }
}