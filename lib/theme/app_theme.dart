import 'package:flutter/material.dart';


class AppTheme {
    static const Color postRed = Color(0xFFDA291C);
    static const Color postYellow = Color(0xFFFFCC00);
    static const Color paper = Color(0xFFFFF8E1);


        static final ThemeData lightTheme = ThemeData(
          primaryColor: postRed,
            colorScheme: ColorScheme.fromSeed(
            seedColor: postRed,
            primary: postRed,
            secondary: postYellow,
        ),
          scaffoldBackgroundColor: paper,
          appBarTheme: const AppBarTheme(
          backgroundColor: postRed,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
          textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
          headlineSmall: TextStyle(color: postRed, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
        backgroundColor: postRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
