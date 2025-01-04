import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/configs/setting/themes.dart';

import '../localization/app_localizations.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final advanceSwitchController1 = ValueNotifier<bool>(false);
  final advanceSwitchController2 = ValueNotifier<bool>(false);
  final advanceSwitchController3 = ValueNotifier<bool>(false);
  final advanceSwitchController4 = ValueNotifier<bool>(false);
  final advanceSwitchController5 = ValueNotifier<bool>(false);
  final advanceSwitchController6 = ValueNotifier<bool>(false);
  final advanceSwitchController7 = ValueNotifier<bool>(false);
  final advanceSwitchController8 = ValueNotifier<bool>(false);
  final SingleValueDropDownController _controller =
  SingleValueDropDownController();
  final FocusNode _focusNode = FocusNode();
  bool _isDropdownOpen = false;


  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isDropdownOpen = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: ListView(
        children: [
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'language')),
              SizedBox(
                width: 200,
                child: DropDownTextField(

                  controller: _controller,
                  listSpace: 0,
                  padding: EdgeInsets.zero,
                  clearOption: false,
                  textFieldDecoration: InputDecoration(
                    labelText: "Language",

                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent), // Removes shadow effect
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  dropDownIconProperty: IconProperty(
                    color: Theme.of(context).colorScheme.onBackground,
                    icon: _isDropdownOpen  ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  ),
                  listTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    backgroundColor: Theme.of(context).colorScheme.background,
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
                      print('Selected language: ${val.name} (${val.value})');
                      BlocProvider.of<SettingBloc>(context).add(
                        SettingLanguageEvent(val.name == "English" ? AppLanguage.english : AppLanguage.persian),
                      );
                    }
                  },
                ),
              ),


            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'likeCount')),
              buildSwitch(context, advanceSwitchController1, myFunc()),
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
              buildSwitch(context, advanceSwitchController2, myFunc()),
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
              buildSwitch(context, advanceSwitchController3, myFunc()),
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
              buildSwitch(context, advanceSwitchController4, myFunc()),
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
              buildSwitch(context, advanceSwitchController5, myFunc()),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'downloadSize')),
              buildSwitch(context, advanceSwitchController6, myFunc()),
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
              buildSwitch(context, advanceSwitchController7, myFunc()),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(
                  context,
                  AppLocalizations.of(context)!
                      .translateNested('setting', 'likeCountHome')),
              buildSwitch(context, advanceSwitchController8, myFunc()),
            ],
          ),
        ],
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
      ValueChanged<dynamic>? function) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 8),
      child: Transform.scale(
        alignment: Alignment.topCenter,
        scaleX: -1,
        child: AdvancedSwitch(
          initialValue: false,
          controller: advanceSwitchController,
          thumb: Container(
            padding: EdgeInsets.zero,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: whiteColor,
            ),
          ),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: Theme.of(context).hintColor,
          height: 25,
          width: 50,
          onChanged: function,
        ),
      ),
    );
  }

  ValueChanged<dynamic>? myFunc() {
    return null;
  }
}
