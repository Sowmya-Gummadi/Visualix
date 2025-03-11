import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:mini_project/SGallery.dart';  // Import the new SGallery.dart
import 'package:transparent_image/transparent_image.dart';

class SentimentPage extends StatefulWidget {
  @override
  _SentimentPageState createState() => _SentimentPageState();
}

class _SentimentPageState extends State<SentimentPage> {
  List<Album> sentimentAlbums = [];

  @override
  void initState() {
    super.initState();
    loadSentimentAlbums();  // Load albums when the page initializes
  }

  // Fetch albums (simulating 'Sentiment' feature)
  loadSentimentAlbums() async {
    List<Album> albums = await PhotoGallery.listAlbums(); // Replace with your own logic if needed
    setState(() {
      sentimentAlbums = albums;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentiment Gallery',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueGrey.shade700,
        centerTitle: true,
      ),
      body: sentimentAlbums.isEmpty
          ? Center(child: CircularProgressIndicator())  // Loading indicator
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 0.75,
        ),
        itemCount: sentimentAlbums.length,
        itemBuilder: (BuildContext context, int index) {
          Album album = sentimentAlbums[index];

          // Fetch the first image in the album as the thumbnail
          return FutureBuilder<List<Medium>>(
            future: album.listMedia().then((mediaPage) => mediaPage.items),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container();  // No media in the album
              }

              // Get the first medium (image) in the album
              Medium sentimentCover = snapshot.data!.first;

              return InkWell(
                onTap: () {
                  // Navigate to SGalleryPage instead of AnalysisPage
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SGalleryPage(album),  // Pass the album to SGalleryPage
                  ));
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          child: FadeInImage(
                            placeholder: MemoryImage(kTransparentImage),  // Placeholder
                            image: ThumbnailProvider(
                              mediumId: sentimentCover.id,  // Image ID
                              mediumType: sentimentCover.mediumType,  // Correct medium type
                              highQuality: true,
                            ),
                            fit: BoxFit.cover,  // Fit the image properly
                          ),
                        ),
                      ),
                    ),
                    Text(
                      album.name ?? 'Unnamed Sentiment',  // Display album name
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}