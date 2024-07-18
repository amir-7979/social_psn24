import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'configs/localization/app_localizations_delegate.dart';
import 'configs/setting/setting_bloc.dart';
import 'configs/setting/themes.dart';
import 'screens/main/main_screen.dart';
import 'services/core_graphql_service.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingBloc>(
          create: (context) =>
              SettingBloc()..add(FetchUserProfileWithPermissionsEvent()),
        ),
      ],
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          return SafeArea(
            child: MaterialApp(
              color: Theme.of(context).scaffoldBackgroundColor,
              title: 'social psn',
              debugShowCheckedModeBanner: false,
              theme: state.theme == AppTheme.light ? lightTheme : darkTheme,
              // Use your custom light theme
              locale: state.language == AppLanguage.english
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
