import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:photo_gallery_app/firebase_options.dart';
import 'package:photo_gallery_app/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
