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
import 'firebase_options.dart';
import 'screens/main/main_screen.dart';
import 'screens/notification/notification_bloc.dart';
import 'services/firebase_notification_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppTheme appTheme = await loadTheme();
  await initHiveForFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseNotificationService notificationService = FirebaseNotificationService();
  await notificationService.initialize();

  final NotificationBloc notificationBloc = NotificationBloc();
  notificationBloc.add(LoadNotifications());

  runApp(MyApp(notificationBloc: notificationBloc, appTheme: appTheme));
}

Future<AppTheme>loadTheme() async{
  final StorageService _storageService = StorageService();
  String? savedTheme = await _storageService.readData('theme');
  AppTheme theme;

  if (savedTheme == null) {
    theme = WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark ? AppTheme.dark : AppTheme.light;
  }else{
    theme = AppTheme.values.firstWhere((element) => element.toString() == savedTheme);
  }
  return theme;
}

class MyApp extends StatelessWidget {
  final NotificationBloc notificationBloc;
  AppTheme appTheme;

  MyApp({Key? key, required this.notificationBloc, required this.appTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingBloc>(create: (context) => SettingBloc(appTheme)),
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
              theme: state.theme == AppTheme.light ? lightTheme : darkTheme,
              locale: state.language == AppLanguage.english
                  ? Locale('en', 'US')
                  : Locale('fa', 'IR'),
              //locale: Locale('en', 'US'),
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

