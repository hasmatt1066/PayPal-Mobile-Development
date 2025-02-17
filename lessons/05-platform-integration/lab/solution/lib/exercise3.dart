import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/loggers.dart';

// Exercise 3: Push Notifications
// Implementation of secure push notifications

// Notification service implementation
class NotificationService {
  final FirebaseMessaging _messaging;
  final NotificationLogger _logger;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _notificationSubject = ValueNotifier<List<RemoteMessage>>([]);
  
  NotificationService({
    required FirebaseMessaging messaging,
    required NotificationLogger logger,
  }) : _messaging = messaging,
       _logger = logger;
  
  ValueNotifier<List<RemoteMessage>> get notifications => _notificationSubject;
  
  Future<void> initialize() async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get token
        final token = await _messaging.getToken();
        await _logger.logToken(token);
        
        // Initialize local notifications
        await _initializeLocalNotifications();
        
        // Configure handlers
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
        FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
      }
      
    } catch (e) {
      await _logger.logError('Initialization failed', e);
    }
  }
  
  Future<void> _initializeLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );
  }
  
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      // Validate payload
      if (!isValidPayload(message.data)) {
        await _logger.logError(
          'Invalid payload',
          message.data.toString(),
        );
        return;
      }
      
      // Show notification
      await _showLocalNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data,
      );
      
      // Update notifications list
      _notificationSubject.value = [
        message,
        ..._notificationSubject.value,
      ];
      
      // Log receipt
      await _logger.logNotification(
        'foreground',
        message.messageId ?? '',
      );
      
    } catch (e) {
      await _logger.logError('Foreground handler failed', e);
    }
  }
  
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    try {
      // Validate payload
      if (!isValidPayload(message.data)) {
        await _logger.logError(
          'Invalid payload',
          message.data.toString(),
        );
        return;
      }
      
      // Update notifications list
      _notificationSubject.value = [
        message,
        ..._notificationSubject.value,
      ];
      
      // Log receipt
      await _logger.logNotification(
        'background',
        message.messageId ?? '',
      );
      
    } catch (e) {
      await _logger.logError('Background handler failed', e);
    }
  }
  
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      0,
      title,
      body,
      details,
      payload: jsonEncode(payload),
    );
  }
  
  bool isValidPayload(Map<String, dynamic> data) {
    // Validate required fields
    if (!data.containsKey('type')) return false;
    if (!data.containsKey('timestamp')) return false;
    
    // Validate type
    final type = data['type'];
    if (!['transaction', 'alert', 'message'].contains(type)) {
      return false;
    }
    
    // Validate timestamp
    final timestamp = DateTime.tryParse(data['timestamp']);
    if (timestamp == null) return false;
    
    // Validate type-specific fields
    switch (type) {
      case 'transaction':
        if (!data.containsKey('amount')) return false;
        if (!data.containsKey('currency')) return false;
        break;
      case 'alert':
        if (!data.containsKey('level')) return false;
        if (!data.containsKey('message')) return false;
        break;
      case 'message':
        if (!data.containsKey('sender')) return false;
        if (!data.containsKey('content')) return false;
        break;
    }
    
    return true;
  }
}

// Notification screen implementation
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _service = NotificationService(
    messaging: FirebaseMessaging.instance,
    logger: NotificationLogger(),
  );

  @override
  void initState() {
    super.initState();
    _service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ValueListenableBuilder<List<RemoteMessage>>(
        valueListenable: _service.notifications,
        builder: (context, notifications, child) {
          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(notification);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(RemoteMessage message) {
    final type = message.data['type'] as String?;
    final timestamp = DateTime.tryParse(
      message.data['timestamp'] as String? ?? '',
    );

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: _buildTypeIcon(type),
        title: Text(message.notification?.title ?? 'No title'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.notification?.body ?? 'No body'),
            if (timestamp != null)
              Text(
                'Received: ${timestamp.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailsScreen(message: message),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(String? type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'transaction':
        icon = Icons.payment;
        color = Colors.green;
        break;
      case 'alert':
        icon = Icons.warning;
        color = Colors.red;
        break;
      case 'message':
        icon = Icons.message;
        color = Colors.blue;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color),
    );
  }
}

// Notification details screen implementation
class NotificationDetailsScreen extends StatelessWidget {
  final RemoteMessage message;

  const NotificationDetailsScreen({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Title',
              message.notification?.title ?? 'No title',
            ),
            const Divider(),
            _buildSection(
              'Body',
              message.notification?.body ?? 'No body',
            ),
            const Divider(),
            _buildSection(
              'Type',
              message.data['type'] ?? 'Unknown',
            ),
            const Divider(),
            _buildSection(
              'Timestamp',
              DateTime.tryParse(
                message.data['timestamp'] as String? ?? '',
              )?.toLocal().toString() ?? 'Unknown',
            ),
            const Divider(),
            _buildSection(
              'Data',
              const JsonEncoder.withIndent('  ')
                  .convert(message.data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(content),
      ],
    );
  }
}

// Main app widget for testing
class Exercise3App extends StatelessWidget {
  const Exercise3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Integration Lab - Exercise 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

void main() {
  runApp(const Exercise3App());
}
