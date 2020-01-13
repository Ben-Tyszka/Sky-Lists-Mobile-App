import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final brightTheme = _buildLightTheme();

final primaryColor = Color(0xFF3F51B5);
final accentColor = Color(0xFFFF4081);
final backgroundColor = Color(0xFFFFFFFF);
final primaryTextColor = Color(0xFF212121);
final secondaryTextColor = Color(0xFF757575);

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: primaryColor,
    accentColor: accentColor,
    buttonColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: backgroundColor,
    textSelectionColor: primaryColor,
    errorColor: Colors.red[500],
    primaryIconTheme: base.primaryIconTheme.copyWith(
      color: primaryTextColor,
    ),
    textTheme: _buildAppTextTheme(base.textTheme),
    primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildAppTextTheme(base.accentTextTheme),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.elliptical(
            20,
            20,
          ),
        ),
        gapPadding: 10.0,
      ),
    ),
    appBarTheme: base.appBarTheme.copyWith(
      elevation: 0.0,
      color: backgroundColor,
    ),
    bottomAppBarTheme: base.bottomAppBarTheme.copyWith(
      elevation: 0.0,
      color: backgroundColor,
    ),
    splashColor: accentColor,
    buttonTheme: base.buttonTheme.copyWith(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    dialogTheme: base.dialogTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
  );
}

TextTheme _buildAppTextTheme(TextTheme base) {
  return GoogleFonts.latoTextTheme()
      .copyWith(
        display1: base.display1.copyWith(
          fontWeight: FontWeight.w200,
        ),
        display2: base.display2.copyWith(
          fontWeight: FontWeight.w200,
        ),
        headline: base.headline.copyWith(
          fontWeight: FontWeight.w500,
        ),
        title: base.title.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),
        caption: base.caption.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        subtitle: base.subtitle.copyWith(
          fontWeight: FontWeight.w400,
        ),
      )
      .apply(
        displayColor: primaryTextColor,
        bodyColor: primaryTextColor,
      );
}

// /// Bright theme for app
// final brightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: Color(0xFFE91E63),
//   accentColor: Color(0xFFFF5722),
//   accentColorBrightness: Brightness.light,
//   // primaryColor: Color(0xFF2862f4),
//   // accentColor: Color(0xFFf43e72),
// );

/// Dark theme for app
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.deepOrange,
  // primaryColor: Color(0xFF20304d),
  // accentColor: Color(0xFFb30033),
);
