import 'package:flutter/material.dart';
import 'package:test1/main.dart';
import 'package:test1/login.dart';


import 'dart:ui';
import 'dart:math' as math;


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String nameLabel = 'Name';
  String emailLabel = 'Email';
  String passwordLabel = 'Password';
  String confirmPasswordLabel = 'Confirm Password';
  String phoneNumberLabel = 'Phone Number';

  bool validateInput() {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String phoneNumber = phoneNumberController.text;

    RegExp emailRegex = RegExp(
        r'^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})$');
    RegExp phoneNumberRegex = RegExp(r'^\d{8}$');

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name cannot be empty')),
      );
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email')),
      );
      return false;
    } else if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return false;
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return false;
    } else if (!phoneNumberRegex.hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid 8-digit phone number')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 16, 107, 211),
              Color.fromARGB(255, 95, 136, 168),
            ],
          ),
        ),
       child: SafeArea(
  child: SingleChildScrollView(
    child: Container(
      height: math.max(MediaQuery.of(context).size.height, MediaQueryData.fromWindow(window).size.height - window.viewInsets.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [


              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              buildTextField(nameController, nameLabel, Icons.person),
              SizedBox(height: 16),
              buildTextField(emailController, emailLabel, Icons.email),
              SizedBox(height: 16),
              buildTextField(passwordController, passwordLabel, Icons.lock, isPassword: true),
              SizedBox(height: 16),
              buildTextField(confirmPasswordController, confirmPasswordLabel, Icons.lock, isPassword: true),
              SizedBox(height: 16),
              buildTextField(phoneNumberController, phoneNumberLabel, Icons.phone),
                            SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (validateInput()) {
                      // You can perform your registration logic here
                     Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                      builder: (context) => MyApp(
                      name: nameController.text,
                      email: emailController.text,
                      location: 'Beirut', // You can replace this with the user's location
                      contactNumber: phoneNumberController.text,
                   ),
                  ),
                (Route<dynamic> route) => false,
                );

                    }
                  },
                  child: Text('REGISTER'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to the registration page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    "Already have an account? Login Now.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      ),
      ),
    );
  }

  Padding buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        obscureText: isPassword,
        onTap: () {
          setState(() {
            label = '';
          });
        },
        style: TextStyle(color: Colors.white),
        focusNode: FocusNode()
          ..addListener(() {
            if (!controller.text.isNotEmpty) {
              setState(() {
                label = label;
              });
            }
          }),
      ),
    );
  }
}

