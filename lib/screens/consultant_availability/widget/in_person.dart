import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:searchfield/searchfield.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/consultation_model/consultant_availability.dart';

class InPerson extends StatefulWidget {
  final ConsultantAvailability consultantAvailability;

  const InPerson({
    Key? key,
    required this.consultantAvailability,
  }) : super(key: key);

  @override
  State<InPerson> createState() => _InPersonState();
}

class _InPersonState extends State<InPerson> {
  @override
  final _ifFocusNode = FocusNode();
  final _centerFocusNode = FocusNode();

  String? selectedCenter;
  bool _isCenterFieldOpen = false;
  String? selectedValue;
  final _formKey = GlobalKey<FormState>();

  TextEditingController categoryController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  void _toggleSearchField() {
    setState(() {
      _isCenterFieldOpen = !_isCenterFieldOpen;
      if (!_isCenterFieldOpen) {
        _centerFocusNode.unfocus();
      } else {
        _centerFocusNode.requestFocus();
      }
    });
  }

  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 8),
        Form(
          key: _formKey,
          child: TextFormField(
            focusNode: _ifFocusNode,
            controller: idController,
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!
                  .translateNested("consultation", "national_code"),
              labelStyle: TextStyle(
                color: _ifFocusNode.hasFocus
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hintColor,
                fontWeight: FontWeight.w400,
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                fontFamily: Theme.of(context).textTheme.titleLarge!.fontFamily,
              ),
              errorStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w400,
                  ),
              enabledBorder: borderStyle,
              focusedBorder: selectedBorderStyle,
              border: borderStyle,
              errorBorder: errorBorderStyle,
              focusedErrorBorder: errorBorderStyle,
              contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            ),
            validator: (value) {
              if (value!.isNotEmpty &&
                  value.length == 10) {
                return null;
              }else
              return AppLocalizations.of(context)!
                  .translateNested('consultation', 'error_national_code');
            },
            onTap: () {
              _ifFocusNode.requestFocus();
              setState(() {});
            },
            onTapUpOutside: (_) {
              _ifFocusNode.unfocus();
              _formKey.currentState!.validate();

            },
            onFieldSubmitted: (value) {
              _centerFocusNode.requestFocus();
              _formKey.currentState!.validate();
              setState(() {});
            },

          ),
        ),
        SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              focusNode: _centerFocusNode,
              barrierColor: Colors.transparent,
              hint: Text(
                AppLocalizations.of(context)!
                    .translateNested("consultation", "chose_center"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: _centerFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              items: widget.consultantAvailability.availabilities!.inPerson!
                  .counselingCenters!
                  .map((item) => DropdownMenuItem<String>(
                        value: item.id.toString(),
                        child: Text(
                          item.name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onMenuStateChange: (isOpen) {
                setState(() {

                  _centerFocusNode.requestFocus();
                });
              },
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  _toggleSearchField();
                  _centerFocusNode.unfocus();

                });
              },
              buttonStyleData: ButtonStyleData(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _centerFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_up,
                  color: Colors.grey,
                ),
                openMenuIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        DatePicker(consultantAvailability: widget.consultantAvailability),
        SizedBox(height: 20),
        SimpleTimeSelector(),

      ],
    );
  }
}

class DatePicker extends StatefulWidget {
  final ConsultantAvailability consultantAvailability;

  const DatePicker({super.key, required this.consultantAvailability});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.tertiary;

    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...widget.consultantAvailability.availabilities!.inPerson!
              .availableDates!
              .asMap()
              .entries
              .map(
                (entry) {
              final index = entry.key;
              final date = entry.value;
              final isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    width: 55,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? primaryColor
                            : Theme.of(context).colorScheme.surface,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      date.formattedPersianDate!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isSelected
                            ? primaryColor
                            : Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SimpleTimeSelector extends StatefulWidget {
  const SimpleTimeSelector({super.key});

  @override
  State<SimpleTimeSelector> createState() => _SimpleTimeSelectorState();
}

class _SimpleTimeSelectorState extends State<SimpleTimeSelector> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.tertiary;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final whiteColor = Theme.of(context).colorScheme.surface;
    final double myWidth = 70;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: selectedIndex == 0 ? primaryColor : surfaceColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.lightSun,
                      size: 14,
                      color: selectedIndex == 0 ? primaryColor : whiteColor),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("consultation", "day"),
                    style: TextStyle(
                        color:
                        selectedIndex == 0 ? primaryColor : whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: selectedIndex == 1 ? primaryColor : surfaceColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  FaIcon(FontAwesomeIcons.lightCloudSun,
                      size: 14,
                      color: selectedIndex == 1 ? primaryColor : whiteColor),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("consultation", "evening"),
                    style: TextStyle(
                        color:
                        selectedIndex == 1 ? primaryColor : whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: selectedIndex == 2 ? primaryColor : surfaceColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  FaIcon(FontAwesomeIcons.lightMoon,
                      size: 14,
                      color: selectedIndex == 2 ? primaryColor : whiteColor),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("consultation", "night"),
                    style: TextStyle(
                        color:
                        selectedIndex == 2 ? primaryColor : whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
