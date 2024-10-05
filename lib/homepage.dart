// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'resultsapi.dart';
// import 'blog_api.dart';
// import 'alert_post.dart';
// import 'blog_post.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late Future<Resultsapi> futureLatestTest;
//   late Future<BlogPost> futureLatestBlog;

//   @override
//   void initState() {
//     super.initState();
//     futureLatestTest = ResultsApi().fetchLatestTest();
//     futureLatestBlog = BlogApi().fetchLatestBlog();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             // Display the latest test item
//             FutureBuilder<Resultsapi>(
//               future: futureLatestTest,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData) {
//                   return Center(child: Text('No test available'));
//                 } else {
//                   Resultsapi latestTest = snapshot.data!;
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       MaterialButton(
//                         onPressed: () => GoRouter.of(context).go('/result', extra: latestTest),
//                         child: Container(
//                           height: 57.0,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 spreadRadius: 0.0,
//                                 blurRadius: 1.0,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(Icons.science_outlined, size: 16.0),
//                               ),
//                               Text(
//                                 'Latest Test: ${latestTest.title}',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 latestTest.date,
//                                 style: TextStyle(
//                                   color: Colors.black.withOpacity(0.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//             // Display the latest blog item
//             FutureBuilder<BlogPost>(
//               future: futureLatestBlog,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData) {
//                   return Center(child: Text('No blog available'));
//                 } else {
//                   BlogPost latestBlog = snapshot.data!;
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       MaterialButton(
//                         onPressed: () => GoRouter.of(context).go('/blog_details', extra: latestBlog),
//                         child: Container(
//                           height: 57.0,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.2),
//                                 spreadRadius: 0.0,
//                                 blurRadius: 1.0,
//                                 offset: Offset(0, 1),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Icon(Icons.article_outlined, size: 16.0),
//                               ),
//                               Text(
//                                 'Latest Blog: ${latestBlog.title}',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 latestBlog.date,
//                                 style: TextStyle(
//                                   color: Colors.black.withOpacity(0.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }