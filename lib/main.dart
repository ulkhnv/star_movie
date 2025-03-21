import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:star_movie/src/core/di/di.dart';
import 'package:star_movie/src/core/firebase/firebase_options.dart';
import 'package:star_movie/src/presentation/screen/app/app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await dotenv.load(fileName: '.env');
  await initDependencies();
  runApp(const App());
}
