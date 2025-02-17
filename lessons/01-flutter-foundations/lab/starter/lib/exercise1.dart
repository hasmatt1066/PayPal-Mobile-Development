import 'package:flutter/material.dart';

// Exercise 1: Widget Tree Analysis
// Implement a nested widget structure with proper lifecycle management

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Create a nested widget tree with Card, Column, and Text widgets
    // Hint: Use Card as the outer container
    // Hint: Include UserAvatar, UserInfo, and UserStatus in a Column
    return Container();
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement a circular avatar widget
    // Hint: Use CircleAvatar widget
    return Container();
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Create a widget to display user information
    // Hint: Use Column with Text widgets for name and email
    return Container();
  }
}

class UserStatus extends StatefulWidget {
  const UserStatus({Key? key}) : super(key: key);

  @override
  _UserStatusState createState() => _UserStatusState();
}

class _UserStatusState extends State<UserStatus> {
  // TODO: Add status state variable
  // TODO: Add timer for status updates
  
  @override
  void initState() {
    super.initState();
    // TODO: Initialize status and start timer
  }

  @override
  void dispose() {
    // TODO: Clean up timer and resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create a widget to display user status with an indicator
    // Hint: Use Row with an icon and text
    return Container();
  }
}

// Main app widget for testing
class Exercise1App extends StatelessWidget {
  const Exercise1App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Foundations Lab - Exercise 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Card'),
        ),
        body: const Center(
          child: ProfileCard(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
