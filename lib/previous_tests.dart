import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result.dart'; // Update to import ResultPage
import 'resultsapi.dart';

class PreviousTestsPage extends StatefulWidget {
  const PreviousTestsPage({Key? key}) : super(key: key);

  @override
  State<PreviousTestsPage> createState() => _PreviousTestsPageState();
}

class _PreviousTestsPageState extends State<PreviousTestsPage> {
  late Future<List<Resultsapi>> futureResults;

  @override
  void initState() {
    super.initState();
    futureResults = ResultsApi().fetchResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Text(
          "Previous Tests",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.5,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.science_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'New Test':
                  Navigator.pushNamed(context, "/new_test");
                  break;
                case 'Language':
                  // Handle Language change here
                  break;
                case 'Settings':
                  // Navigate to Settings page
                  break;
                case 'Sign In':
                  Navigator.pushNamed(context, '/login');
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
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: FutureBuilder<List<Resultsapi>>(
        future: futureResults,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Resultsapi> results = snapshot.data!;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the detailed results page and pass the test data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          result: results[index], // Pass the test result
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                    child: Container(
                      height: 57.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 0.0,
                            blurRadius: 1.0,
                            offset: const Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.science_outlined, size: 16.0),
                          ),
                          Text(
                            'Test no. ${results[index].id}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            results[index].date,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Online",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                              Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.green,
                                size: 16.0,
                              ),
                            ],
                          ),
                          const Icon(Icons.more_vert_outlined),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
