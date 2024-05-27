import 'package:flutter/material.dart';

TextTheme iranYekanTheme = const TextTheme(
  displayLarge: TextStyle(
    fontSize: 24,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
  displayMedium: TextStyle(
    fontSize: 20,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
  displaySmall: TextStyle(
    fontSize: 18,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
  headlineMedium: TextStyle(
    fontSize: 16,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
  headlineSmall: TextStyle(
    fontSize: 15,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
  titleLarge: TextStyle(
    fontSize: 14,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
  bodyLarge: TextStyle(
    fontSize: 12,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
  bodyMedium: TextStyle(
    fontSize: 10,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
);

TextTheme iranSansTheme = const TextTheme(
  displayLarge: TextStyle(
    fontSize: 24,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
  displayMedium: TextStyle(
    fontSize: 20,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
  displaySmall: TextStyle(
    fontSize: 18,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
  headlineMedium: TextStyle(
    fontSize: 16,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
  headlineSmall: TextStyle(
    fontSize: 15,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
  titleLarge: TextStyle(
    fontSize: 14,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
  bodyLarge: TextStyle(
    fontSize: 12,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
  bodyMedium: TextStyle(
    locale: Locale('fa', 'IR'),
    fontSize: 10,
    fontFamily: 'IRANSansXV', // specify the font family here
  ),
);

final ThemeData lightTheme = ThemeData(
  fontFamily: 'IRANSansXV',
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.transparent,
    //surfaceTintColor: Colors.white,
    elevation: 0,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: Color(0xFF374355)),
    toolbarHeight: 50,
    actionsIconTheme: const IconThemeData(color: Color(0xFF374355)),
    titleTextStyle: iranSansTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF00BFB3)),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),

  primaryColor: const Color(0xFF00BFB3),

  scaffoldBackgroundColor: const Color(0xFFB4C0D3),
  hintColor: const Color(0xFFB4C0D3),
  dividerColor: const Color(0xFFCACACA),
  hoverColor: const Color(0xFF374355),
  shadowColor: const Color(0x26000000),
  textTheme: iranSansTheme,
  brightness: Brightness.light, colorScheme: const ColorScheme.light(
  primary: Color(0xFF00BFB3),
  secondary: Color(0xFF214D60),
  brightness: Brightness.light,
  background: Colors.white,
  tertiary: Color(0xFF00A6ED),
  error: Color(0xFFFF4D6D),
  errorContainer: Color(0xFFFF9770),
  shadow: Colors.black,
  surface: Color(0xFFA0AFC7),
  onError: Colors.white,

),
);

final ThemeData darkTheme = ThemeData(
    fontFamily: 'IRANSansXV',
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.transparent,
      //surfaceTintColor: Colors.white,
      elevation: 0,
    ),

    appBarTheme: AppBarTheme(
    backgroundColor: const Color(0xFF212121),
    elevation: 0,
    iconTheme: const IconThemeData(color: Color(0xFFffffff)),
    toolbarHeight: 50,
    actionsIconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: iranSansTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF00BFB3)),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFF212121),
    surfaceTintColor: Colors.white,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF212121),
  ),
  primaryColor: const Color(0xFF00BFB3),
  scaffoldBackgroundColor: const Color(0xFF0F0F0F),
  hintColor: const Color(0xFFB4C0D3),
  dividerColor: const Color(0xFFCACACA),
  hoverColor: Colors.white,
  shadowColor: const Color(0x26ffffff),
  textTheme: iranSansTheme,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
  primary: Color(0xFF00BFB3),
  secondary: Color(0xFF214D60),
  brightness: Brightness.dark,
  background: Color(0xFF212121),
  tertiary: Color(0xFF00A6ED),
  error: Color(0xFFFF4D6D),
  errorContainer: Color(0xFFFF9770),
  shadow: Colors.white ,
  surface: Color(0xFFA0AFC7),
    onError: Colors.white,

)
);


const cameraBackgroundColor = Color(0xFFDADBDC);
const whiteColor = Colors.white;
const blackColor = Colors.black;

final Color lightBaseColor = Colors.grey[300]!;
final Color lightHighlightColor = Colors.grey[100]!;
final Color darkBaseColor = Colors.grey[700]!;
final Color darkHighlightColor = Colors.grey[600]!;

var borderStyle = OutlineInputBorder(

  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    color: Color(0xFFB4C0D3),

  ),
);
var errorBorderStyle = OutlineInputBorder(

  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    color: Color(0xFFFF4D6D),
  ),
);