import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/screens/splash_screen.dart';
import 'package:tournament_app/services/auth_service.dart';
import 'package:tournament_app/providers/home_provider.dart';
import 'package:tournament_app/providers/image_slider_provider.dart';
import 'package:tournament_app/providers/marquee_text_provider.dart';
import 'package:tournament_app/providers/category_provider.dart';
import 'package:tournament_app/providers/profile_provider.dart';
import 'package:tournament_app/providers/balance_provider.dart';
import 'package:tournament_app/providers/help_videos_provider.dart';
import 'package:tournament_app/providers/bank_info_provider.dart';
import 'package:tournament_app/providers/top_players_provider.dart';
import 'package:tournament_app/providers/today_matches_provider.dart';
import 'package:tournament_app/providers/subcategory_matches_provider.dart';
import 'providers/result_provider.dart';
import 'providers/result_matches_provider.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ImageSliderProvider()),
        ChangeNotifierProvider(create: (_) => MarqueeTextProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => BalanceProvider()),
        ChangeNotifierProvider(create: (_) => HelpVideosProvider()),
        ChangeNotifierProvider(create: (_) => BankInfoProvider()),
        ChangeNotifierProvider(create: (_) => TopPlayersProvider()),
        ChangeNotifierProvider(create: (_) => TodayMatchesProvider()),
        ChangeNotifierProvider(create: (_) => SubcategoryMatchesProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => ResultMatchesProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Sports BD',
        theme: _buildTheme(context),
        home: SplashScreen(),
      ),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    try {
      // Try to use Google Fonts
      return ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xFF54A9EB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF54A9EB),
          primary: Color(0xFF54A9EB),
          secondary: Color(0xFFFFAA00),
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
        tabBarTheme: TabBarThemeData(
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
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      // Fallback theme without Google Fonts
      print('Google Fonts failed to load, using fallback theme: $e');
      return ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xFF54A9EB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF54A9EB),
          primary: Color(0xFF54A9EB),
          secondary: Color(0xFFFFAA00),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto', // Default system font
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        tabBarTheme: TabBarThemeData(
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
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
