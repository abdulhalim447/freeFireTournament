import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_app/screens/splash_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Sports BD',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xFF54A9EB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF54A9EB),
          primary: Color(0xFF54A9EB),
          secondary: Color(0xFFFFAA00),
          background: Colors.white,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Color(0xFF54A9EB),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF54A9EB),
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF54A9EB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
