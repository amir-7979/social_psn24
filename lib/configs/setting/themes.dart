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
  labelSmall: TextStyle(
    fontSize: 11,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  bodyMedium: TextStyle(
    fontSize: 10,
    fontFamily: 'Iranyekan', // specify the font family here
  ),
);

TextTheme iranSansTheme = const TextTheme(
  displayLarge: TextStyle(
    fontSize: 24,
    letterSpacing: -0.1,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  displayMedium: TextStyle(
    letterSpacing: -0.1,
    fontSize: 20,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  displaySmall: TextStyle(
    letterSpacing: -0.1,
    fontSize: 18,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  headlineMedium: TextStyle(
    letterSpacing: -0.1,
    fontSize: 16,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  headlineSmall: TextStyle(
    letterSpacing: -0.1,
    fontSize: 15,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  titleLarge: TextStyle(
    letterSpacing: -0.1,
    fontSize: 14,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  bodyLarge: TextStyle(
    letterSpacing: -0.1,
    fontSize: 12,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  labelSmall: TextStyle(
    letterSpacing: 0,
    fontSize: 11,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
  bodyMedium: TextStyle(
    locale: Locale('fa', 'IR'),
    letterSpacing: -0.1,
    fontSize: 10,
    fontFamily: 'IRANSansX', // specify the font family here
  ),
);

final ThemeData lightTheme = ThemeData(
  fontFamily: 'IRANSansX',
  dialogTheme:  DialogThemeData(
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
    titleTextStyle: iranSansTheme.bodyLarge!
        .copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF00BFB3)),
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
  primaryColor: const Color(0xFF00BFB3),
  scaffoldBackgroundColor: Colors.white,
  hintColor: const Color(0xFFB4C0D3),
  dividerColor: const Color(0xFFCACACA),
  hoverColor: const Color(0xFF374355),
  shadowColor: const Color(0x26000000),
  textTheme: iranSansTheme,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
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
    onPrimaryContainer: Color(0xFFF5F9FF),
    onSurface: Color(0xFFe6f0ff),
  ),
);

final ThemeData darkTheme = ThemeData(
    fontFamily: 'IRANSansX',
    dialogTheme:  DialogThemeData(
      backgroundColor: Colors.transparent,
      //surfaceTintColor: Colors.white,
      elevation: 0,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF212121),
      foregroundColor: const Color(0xFF212121),
      surfaceTintColor: const Color(0xFF212121),
      elevation: 0,
      iconTheme: const IconThemeData(color: Color(0xFFffffff)),
      toolbarHeight: 50,
      actionsIconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: iranSansTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w600, color: const Color(0xFF00BFB3)),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Color(0xFF212121),
      surfaceTintColor: Colors.white,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF212121),
    ),
    primaryColor: const Color(0xFF00BFB3),
    scaffoldBackgroundColor: const Color(0xFF212121),
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
      shadow: Colors.white,
      onPrimaryContainer: Color(0xFF121212),
      onSurface: Color(0xFF353535),
      surface: Color(0xFFA0AFC7),
      onError: Colors.white,
    ));

const cameraBackgroundColor = Color(0xFFCCEDFB);
const imageBackgroundColor = Color(0xFFF5F9FF);
const shadowPopUpColor = Color(0x26ffffff);
const searchBorderColor = Color(0xffECEFF4);
const elevatedButtonBackColor = Color(0x3300A6ED);
const redBackGroundColor = Color(0xffffdbe2);

const whiteColor = Colors.white;
const blackColor = Colors.black;

final Color lightBaseColor = Colors.grey[300]!;
final Color lightHighlightColor = Colors.grey[100]!;
final Color darkBaseColor = Colors.grey[700]!;
final Color darkHighlightColor = Colors.grey[600]!;
final Color amberColor = Colors.amber[600]!;
const Color chatSent =  Color(0xFFCCF2F0);
const Color chatReceive = Color(0xFFF5F9FF);


final OutlineInputBorder borderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    color: Color(0xFFA0AFC7),
  ),
);

final OutlineInputBorder selectedBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(
    color: const Color(
        0xFF00BFB3), // Change this to your desired color for selected state
  ),
);

final OutlineInputBorder errorBorderStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: const BorderSide(
    color: Color(0xFFFF4D6D),
  ),
);
