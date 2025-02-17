import 'package:flutter/material.dart';
import 'dart:async';

// Exercise 1: Widget Tree Analysis
// Implementation of a nested widget structure with proper lifecycle management

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            UserAvatar(),
            SizedBox(height: 16.0),
            UserInfo(),
            SizedBox(height: 8.0),
            UserStatus(),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 50,
      backgroundColor: Colors.blue,
      child: Icon(
        Icons.person,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          'john.doe@example.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class UserStatus extends StatefulWidget {
  const UserStatus({Key? key}) : super(key: key);

  @override
  _UserStatusState createState() => _UserStatusState();
}

class _UserStatusState extends State<UserStatus> {
  bool _isOnline = true;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    // Simulate status changes every 3 seconds
    _statusTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _toggleStatus(),
    );
  }

  @override
  void dispose() {
    // Clean up timer when widget is disposed
    _statusTimer?.cancel();
    super.dispose();
  }

  void _toggleStatus() {
    setState(() {
      _isOnline = !_isOnline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 12,
          color: _isOnline ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8.0),
        Text(
          _isOnline ? 'Online' : 'Offline',
          style: TextStyle(
            color: _isOnline ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
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
