import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'auth_api.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool success = await AuthApi().signUp(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text(
                  'Account successfully registered. You will be directed to the login page to login.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    context.go('/login'); // Navigate to the login page
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        title: Text(
          "Sign Up",
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: Text('Sign Up'),
                    ),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
