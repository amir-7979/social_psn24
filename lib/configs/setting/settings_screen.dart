import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/themes.dart';
import '../../services/settings_service.dart';
import '../../services/storage_service.dart';
import '../localization/app_localizations.dart';
import 'setting_bloc.dart';
import 'user_settings.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late ValueNotifier<bool>advanceSwitchController1;
  late ValueNotifier<bool>advanceSwitchController2;
  late ValueNotifier<bool>advanceSwitchController3;
  late ValueNotifier<bool>advanceSwitchController4;
  late ValueNotifier<bool>advanceSwitchController5;
  late ValueNotifier<bool>advanceSwitchController6;
  late ValueNotifier<bool> advanceSwitchController7;
  late ValueNotifier<bool> advanceSwitchController8;
  late SingleValueDropDownController _controller = SingleValueDropDownController();
  late FocusNode _focusNode = FocusNode();
  bool _isDropdownOpen = false;
  late UserSettings _userSettings;

  @override
  void initState() {
    super.initState();
    _userSettings = BlocProvider.of<SettingBloc>(context).state.getUserSettings;
    print(_userSettings.autoPlayVideos.toString());
    _focusNode.addListener(() => setState(() => _isDropdownOpen = _focusNode.hasFocus));
    _loadSettings();
  }

  void _loadSettings() {
     advanceSwitchController1 = ValueNotifier<bool>(_userSettings.showLikeCountPostScreen);
     advanceSwitchController2 = ValueNotifier<bool>(_userSettings.enableNotifications);
     advanceSwitchController3 = ValueNotifier<bool>(_userSettings.enableContentNotifications);
     advanceSwitchController4 = ValueNotifier<bool>(_userSettings.showCharityNotifications);
     advanceSwitchController5 = ValueNotifier<bool>(_userSettings.showConsultNotifications);
     advanceSwitchController6 = ValueNotifier<bool>(_userSettings.hideDownloadedMediaSize);
     advanceSwitchController7 = ValueNotifier<bool>(_userSettings.autoPlayVideos);
     advanceSwitchController8 = ValueNotifier<bool>(_userSettings.showLikeCountHomeScreen);
  }


  void _handleSwitchEvent(String key, ValueNotifier<bool> controller) => BlocProvider.of<SettingBloc>(context).add(UpdateUserSettingEvent(key, controller.value));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: ListView(
        children: [
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'language')),
              buildDropDown(context),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(context, AppLocalizations.of(context)!.translateNested('setting', 'likeCount')),
              buildSwitch(context, advanceSwitchController1, () => _handleSwitchEvent("showLikeCountPostScreen", advanceSwitchController1)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'notification')),
              buildSwitch(context, advanceSwitchController2, () => _handleSwitchEvent("enableNotifications", advanceSwitchController2)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'contentNotification')),
              buildSwitch(context, advanceSwitchController3, () => _handleSwitchEvent("enableContentNotifications", advanceSwitchController3)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'charityNotification')),
              buildSwitch(context, advanceSwitchController4, () => _handleSwitchEvent("showCharityNotifications", advanceSwitchController4)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'consultNotification')),
              buildSwitch(context, advanceSwitchController5, () => _handleSwitchEvent("showConsultNotifications", advanceSwitchController5)),
            ],
          ),
         /* Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'downloadSize')),
              buildSwitch(context, advanceSwitchController6, () => _handleSwitchEvent("hideDownloadedMediaSize", advanceSwitchController6)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'autoPlay')),
              buildSwitch(context, advanceSwitchController7, () => _handleSwitchEvent("autoPlayVideos", advanceSwitchController7)),
            ],
          ),*/
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'likeCountHome')),
              buildSwitch(context, advanceSwitchController8, () => _handleSwitchEvent("showLikeCountHomeScreen", advanceSwitchController8)),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox buildDropDown(BuildContext context) {
    return SizedBox(
      width: 200,
      child: DropDownTextField(
        controller: _controller,
        listSpace: 0,
        padding: EdgeInsets.zero,
        clearOption: false,
        textFieldDecoration: InputDecoration(
          labelText: AppLocalizations.of(context)!
              .translateNested('setting', 'language'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
        dropDownIconProperty: IconProperty(
          color: Theme.of(context).colorScheme.onBackground,
          icon: _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
        ),
        listTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: blackColor,
        ),
        dropDownItemCount: 2,
        dropdownRadius: 8,
        textFieldFocusNode: _focusNode,
        dropDownList: const [
          DropDownValueModel(name: 'Farsi', value: 'fa'),
          DropDownValueModel(name: 'English', value: 'en'),
        ],
        onChanged: (val) {
          if (val is DropDownValueModel) {
            BlocProvider.of<SettingBloc>(context).add(
              SettingLanguageEvent(val.name == "English" ? AppLanguage.english : AppLanguage.persian),
            );
          }
        },
      ),
    );
  }

  SizedBox buildText(BuildContext context, String text) {
    return SizedBox(
      width: 130,
      height: 60,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: FontWeight.w400,
          color: Theme.of(context).hoverColor,
        ),
      ),
    );
  }

  Widget buildSwitch(
      BuildContext context,
      ValueNotifier<bool>? advanceSwitchController,
      VoidCallback onChanged) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: Transform.scale(
        alignment: Alignment.topCenter,
        scaleX: -1,
        child: AdvancedSwitch(
          initialValue: advanceSwitchController!.value,
          controller: advanceSwitchController,
          thumb: Container(
            padding: EdgeInsets.zero,
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
          height: 25,
          width: 50,
          onChanged: (value) {
            onChanged();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    advanceSwitchController1.dispose();
    advanceSwitchController2.dispose();
    advanceSwitchController3.dispose();
    advanceSwitchController4.dispose();
    advanceSwitchController5.dispose();
    advanceSwitchController6.dispose();
    advanceSwitchController7.dispose();
    advanceSwitchController8.dispose();

    super.dispose();
  }
}
