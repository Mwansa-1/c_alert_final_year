// Package imports
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Nav extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const Nav({super.key, required this.child, required this.currentIndex});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background color of the app
      body: widget.child,
      bottomNavigationBar: BottomAppBar(
        elevation: 10.5,
        shadowColor: Colors.black,
        height: 70.0,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Home Button
            Column(
              children: <Widget>[
                IconButton(
                  onPressed: () => GoRouter.of(context).go('/'),
                  icon: widget.currentIndex == 0
                      ? Icon(Icons.home)
                      : Icon(Icons.home_outlined),
                  iconSize: 30.0,
                ),
                Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Feed Button
            Column(
              children: [
                IconButton(
                  onPressed: () => GoRouter.of(context).go('/feed'),
                  // onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context)=> const feed()),
                  //     (route) => route.isFirst),

                  icon: widget.currentIndex == 1
                      ? Icon(Icons.feed)
                      : Icon(Icons.feed_outlined),
                  iconSize: 30.0,
                ),
                Text(
                  "Feed",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Profile Button
            Column(
              children: [
                IconButton(
                  onPressed: () => GoRouter.of(context).go('/profile'),
                  // onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context)=> const profile()),
                  //     (route) => route.isFirst),

                  icon: widget.currentIndex == 2
                      ? Icon(Icons.person)
                      : Icon(Icons.person_outline),
                  iconSize: 30.0,
                ),
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
