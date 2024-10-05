import 'package:flutter/material.dart';
import 'resultsapi.dart';
import 'nav.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

class ResultPage extends StatefulWidget {
  final Resultsapi result; // Accept the result data

  const ResultPage(
      {super.key, required this.result}); // Constructor to accept data

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _showDetailedResults = false;

  @override
  Widget build(BuildContext context) {
    return Nav(
      currentIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          shadowColor: Colors.black,
          title: Text(
            "Test no. ${widget.result.id}", // Show test ID
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildCard(
                title: 'Results',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.result.result, // Display result status
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                    // const Text(
                    //   'Quantitative Analysis: High level of contamination detected.',
                    //   style: TextStyle(fontSize: 16),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showDetailedResults = !_showDetailedResults;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: Text(_showDetailedResults ? 'Show Less' : 'Show More'),
                ),
              ),
              if (_showDetailedResults) ...[
                const SizedBox(height: 16),
                _buildCard(
                  title: 'Methodology',
                  child: _buildMethodSection(),
                ),
                const SizedBox(height: 20.0),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Test Used',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text('Rapid Cholera Detection Test'),
        SizedBox(height: 8),
        Text(
          'Purpose of the Test',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text('To quickly identify the presence of cholera bacteria.'),
        SizedBox(height: 8),
        Text(
          'Principle of the Method',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
            'The test detects cholera bacteria through antigen-antibody reactions.'),
      ],
    );
  }
}
