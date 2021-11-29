import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './check_connectivity.dart';
import './constants/theme_data.dart';
import './state_management/auth/authProvider.dart';
import './state_management/campSite/privateProvider.dart';
import './state_management/campSite/publicProvider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PublicProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PrivateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: const Color(0xFF1D3557),
            backgroundColor: const Color(0xFFFFFFFF),
            cardColor: const Color(0xFF9DB6CB),
            hoverColor: const Color(0xFFEFF3F6),
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
            ),
            textTheme: mTextTheme,
            elevatedButtonTheme: mElevatedButtonTheme,
            iconTheme: IconThemeData(color: Color(0xFF606580), size: 20)),
        home: CheckConnectivity(),
      ),
    );
  }
}
