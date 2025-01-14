
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_psn/screens/home/home_bloc.dart';
import 'package:social_psn/screens/widgets/appbar/appbar_bloc.dart';
import 'package:social_psn/services/storage_service.dart';
import 'configs/localization/app_localizations_delegate.dart';
import 'configs/setting/setting_bloc.dart';
import 'configs/setting/themes.dart';
import 'configs/setting/user_settings.dart';
import 'firebase_options.dart';
import 'screens/main/main_screen.dart';
import 'screens/notification/notification_bloc.dart';
import 'services/firebase_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHiveForFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseNotificationService notificationService = FirebaseNotificationService();
  await notificationService.initialize();
  final NotificationBloc notificationBloc = NotificationBloc();
  notificationBloc.add(LoadNotifications());
  final settings = await loadUserSettings();
  runApp(MyApp(notificationBloc: notificationBloc, userSettings: settings['userSettings'], token: settings['token']??''));
}

Future<Map<String, dynamic>> loadUserSettings() async {
  final StorageService _storageService = StorageService();
  final userSettingsJson = await _storageService.readData('userSettings');
  UserSettings userSettings;
  if (userSettingsJson != null) {
    userSettings = UserSettings.fromJson(jsonDecode(userSettingsJson) as Map<String, dynamic>);
  } else {
    final Locale systemLocale = WidgetsBinding.instance.window.locale;
    final AppTheme osTheme = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark ? AppTheme.dark : AppTheme.light;
    final AppLanguage osLanguage = systemLocale.languageCode == 'en' ? AppLanguage.persian : AppLanguage.persian;
    userSettings = UserSettings(theme: osTheme, language: osLanguage);
  }
  final token = await _storageService.readData('token');
  return {'userSettings': userSettings, 'token': token};
}

class MyApp extends StatelessWidget {
  final NotificationBloc notificationBloc;
  final UserSettings userSettings;
  final String token;

  MyApp({
    Key? key,
    required this.notificationBloc,
    required this.userSettings,
    required this.token,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingBloc>(create: (context) => SettingBloc(userSettings, token)),
        BlocProvider<AppbarBloc>(create: (context) => AppbarBloc()),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
        BlocProvider<NotificationBloc>(create: (context) => notificationBloc),
      ],
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          return SafeArea(
            child: MaterialApp(
              color: Theme.of(context).scaffoldBackgroundColor,
              title: 'social psn',
              debugShowCheckedModeBanner: false,
              theme: state.userSettings.theme == AppTheme.light ? lightTheme : darkTheme,
              locale: state.userSettings.language == AppLanguage.english
                  ? Locale('en', 'US')
                  : Locale('fa', 'IR'),
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'), // English
                Locale('fa', 'IR'), // Persian
              ],
              home: MainScreen(),
            ),
          );
        },
      ),
    );
  }
}
