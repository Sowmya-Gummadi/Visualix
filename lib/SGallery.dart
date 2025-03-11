import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:mini_project/Analysis.dart';  // Import the AnalysisPage

class SGalleryPage extends StatefulWidget {
  Album album;
  SGalleryPage(this.album);  // Constructor that accepts an album

  @override
  State<SGalleryPage> createState() => _SGalleryPageState();
}

class _SGalleryPageState extends State<SGalleryPage> {
  List<Medium> mediumList = [];

  @override
  void initState() {
    super.initState();
    loadMedia();  // Load the media as soon as the state is initialized
  }

  // Load media from the album
  loadMedia() async {
    MediaPage mediaPage = await this.widget.album.listMedia();
    mediumList = mediaPage.items;  // Assign media items to the mediumList
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double imageWidth = (MediaQuery.of(context).size.width - 15) / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.widget.album.name.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade700,  // AppBar background color
        centerTitle: true,  // Center the title
        iconTheme: IconThemeData(color: Colors.white),  // Set icon color (back button)
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
          itemCount: mediumList.length,
          itemBuilder: (BuildContext ctx, int index) {
            Medium medium = mediumList[index];

            return InkWell(
              onTap: () {
                // Navigate to AnalysisPage on tap, passing the selected medium
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SentimentAnalysisPage(medium),  // Navigate to AnalysisPage
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
                          placeholder: MemoryImage(kTransparentImage),  // Placeholder while loading
                          image: ThumbnailProvider(
                            mediumId: medium.id,  // Pass medium ID
                            mediumType: medium.mediumType,  // Pass medium type
                            highQuality: true,  // Load high-quality image
                          ),
                          fit: BoxFit.cover,  // Make sure the image is properly covered
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}