// Package imports
import 'package:c_alert/blog_details.dart';
import 'package:c_alert/blogapi.dart';
import 'package:c_alert/result.dart';
import 'package:c_alert/resultsapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// Page imports
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Resultsapi> futureLatestTest;
  late Future<BlogPost> futureLatestBlog;

  @override
  void initState() {
    super.initState();
    futureLatestTest = ResultsApi().fetchLatestTest();
    futureLatestBlog = BlogApi().fetchLatestBlog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color of the app
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        shadowColor: Colors.black,
        title: Text(
          "Home",
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

      // The main content of the home page
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 50.0),
                      child: Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 0.0,
                                blurRadius: 1.0,
                                offset: Offset(0, 1),
                              )
                            ],
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Number of cases
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "100",
                                      style: TextStyle(
                                        fontSize: 60.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      Icons.add,
                                      size: 30.0,
                                      color: Colors.red,
                                      weight: 15.0,
                                    ),
                                  ],
                                ),
                                Text(
                                  "  New Cases",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                // Date
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range_outlined,
                                          size: 30.0,
                                        ),
                                        Text(
                                          "  14/05/24",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        // Icon(
                                        //   Icons.link,
                                        //   size: 30.0,
                                        // ),
                                        // TextButton(
                                        //   onPressed: () => GoRouter.of(context)
                                        //       .go('/more_info'),
                                        //   child: Text(
                                        //     "More Info",
                                        //     style: TextStyle(
                                        //       color: Colors.black,
                                        //       decoration:
                                        //           TextDecoration.underline,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Previous Test",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            GoRouter.of(context).go('/previous_tests'),
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // get one test from the backend

                  Column(
                    children: <Widget>[
                      FutureBuilder<Resultsapi>(
                        future: futureLatestTest,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData) {
                            return Center(child: Text('No test available'));
                          } else {
                            Resultsapi latestTest = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    // Navigate to the detailed results page and pass the test data
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultPage(
                                          result:
                                              latestTest, // Pass the test result
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Container(
                                          height: 57.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 0.0,
                                                blurRadius: 1.0,
                                                offset: const Offset(0, 1),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                    Icons.science_outlined,
                                                    size: 16.0),
                                              ),
                                              Text(
                                                'Test no. ${latestTest.id}   ',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Online",
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.6)),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    color: Colors.green,
                                                    size: 16.0,
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                  Icons.more_vert_outlined),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Blog Post",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => GoRouter.of(context).go('/feed'),
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.0),

                  // Placeholder for Blog posts
                  FutureBuilder<BlogPost>(
                    future: futureLatestBlog,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('No blog available'));
                      } else {
                        BlogPost latestBlog = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                // Navigate to the detailed results page and pass the test data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BlogDetailsPage(blogPost: latestBlog),
                                  ),
                                );
                              },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: <Widget>[
                                    Image.network(latestBlog.picture),
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlogDetailsPage(
                                                    blogPost: latestBlog),
                                          ),
                                        );
                                      },
                                      tileColor: Colors.white,
                                      title: Text(latestBlog.title),
                                      subtitle:
                                          Text(latestBlog.briefDescription),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
