import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_example/firebase_options.dart';
import 'package:firebase_messaging_example/main.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
    nativeAutomation: true,
    ($) async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      await setupFlutterNotifications();

      await $.pumpWidgetAndSettle(MessagingExampleApp());

      await $('Request Permissions').tap(settlePolicy: SettlePolicy.noSettle);

      if (Platform.isAndroid) {
        await $.native.grantPermissionOnlyThisTime();
      } else if (Platform.isIOS) {
        await $.native.tap(
          Selector(text: 'Pozwalaj'),
          appId: 'com.apple.springboard',
        );
      }

      await $.pumpAndSettle();
    },
  );
}
