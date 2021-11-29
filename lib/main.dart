import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:me_and_my_tent_client/composition.dart';

import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Composition.initialise();
  runApp(MyApp());
}
