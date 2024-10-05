import 'package:flutter/material.dart';
import 'blogapi.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'nav.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class BlogDetailsPage extends StatefulWidget {
  final BlogPost blogPost;

  const BlogDetailsPage({Key? key, required this.blogPost}) : super(key: key);

  @override
  _BlogDetailsPageState createState() => _BlogDetailsPageState();
}

class _BlogDetailsPageState extends State<BlogDetailsPage> {
  bool _isDownloaded = false; // Track if the file is downloaded
  String? _filePath; // Store the file path

  @override
  Widget build(BuildContext context) {
    return Nav(
      currentIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          shadowColor: Colors.black,
          title: Text(
            widget.blogPost.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 5.5,
          actions: [
            IconButton(
                onPressed: () => GoRouter.of(context).go('/previous_tests'),
                icon: Icon(Icons.science_outlined)),
            PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'New Test':
                    context.go("/new_test");
                    break;
                  case 'Language':
                    // Handle Language change here
                    break;
                  case 'Settings':
                    // Navigate to Settings page
                    break;
                  case 'Sign In':
                    context.go('/login');
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'New Test', 'Language', 'Settings', 'Sign In'}
                    .map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),

        // Floating action button
        floatingActionButton: SpeedDial(
          elevation: 5.0,
          backgroundColor: Colors.grey[800],
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          children: [
            SpeedDialChild(
              onTap: () {
                context.go("/new_test");
              },
              child: Icon(Icons.paste_rounded, color: Colors.white),
              label: "New Test With Device",
              backgroundColor: Colors.grey[800],
              labelBackgroundColor: Colors.grey[800],
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(widget.blogPost.picture),
              SizedBox(height: 16.0),
              Text(
                widget.blogPost.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(widget.blogPost.briefDescription),
              SizedBox(height: 16.0),
              Text('Date: ${widget.blogPost.date}'),
              SizedBox(height: 16.0),

              // Show Download or View button based on the download status
              _isDownloaded
                  ? ElevatedButton(
                      onPressed: () {
                        // Open the downloaded file
                        if (_filePath != null) {
                          OpenFile.open(_filePath);
                        }
                      },
                      child: Text('View Document'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        // Handle file download
                        _downloadFile(context, widget.blogPost.file);
                      },
                      child: Text('Download Document'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadFile(BuildContext context, String url) async {
    try {
      // Step 1: Get the Downloads directory
      final appDir = await getDownloadsDirectory();
      final fileName = url.split('/').last;
      final filePath = '${appDir?.path}/$fileName';

      // Step 2: Download the file
      Dio dio = Dio();
      await dio.download(url, filePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Downloading " +
                    (received / total * 100).toStringAsFixed(0) +
                    "%")),
          );
          print("Downloading " +
              (received / total * 100).toStringAsFixed(0) +
              "%");
        }
      });

      // Step 3: Show success message and update state
      setState(() {
        _isDownloaded = true;
        _filePath = filePath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File downloaded to $filePath')),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file')),
      );
    }
  }
}
