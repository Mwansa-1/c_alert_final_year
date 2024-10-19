import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_api.dart'; // Import the AuthApi class

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load both token and username
  }

  // Load token and username from SharedPreferences
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token =
          prefs.getString('auth_token'); // Get the token from SharedPreferences
      username = prefs.getString('username') ?? 'User';

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> handleLogout() async {
    try {
      final authApi = AuthApi();
      await authApi
          .logout(); // Call logout from AuthApi to handle API and token removal

      if (mounted) {
        context.go('/login'); // Navigate back to login page
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.5,
        actions: [
          IconButton(
            onPressed: () =>
                GoRouter.of(context).go('/view_all_previous_tests'),
            icon: const Icon(Icons.science_outlined),
          ),
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
                case 'Logout':
                  handleLogout();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'New Test', 'Language', 'Settings', 'Logout'}
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
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        children: [
          SpeedDialChild(
            onTap: () {
              context.go("/new_test");
            },
            child: const Icon(Icons.paste_rounded, color: Colors.white),
            label: "New Test With Device",
            backgroundColor: Colors.grey[800],
            labelBackgroundColor: Colors.grey[800],
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 250.0,
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
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage('images/c.jpg'),
                                radius: 50.0,
                              ),
                              Column(
                                children: [
                                  const SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.person_outline),
                                              Text(
                                                " $username",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Additional content (e.g., previous tests) remains the same...
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
