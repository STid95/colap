import 'package:firebase_messaging/firebase_messaging.dart';

void registerNotification() async {
  // 2. Instantiate Firebase Messaging
  final messaging = FirebaseMessaging.instance;

  // 3. On iOS, this helps to take the user permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
    // For handling the received notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification?.body);
    });
  } else {
    print('User declined or has not accepted permission');
  }
}
