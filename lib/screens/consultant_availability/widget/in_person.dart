import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:searchfield/searchfield.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/consultation_model/consultant_availability.dart';
import '../../../repos/models/consultation_model/counseling_center_short.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import '../consultant_availability_bloc.dart';

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
  TextEditingController categoryController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final _idFocusNode = FocusNode();
  final _centerFocusNode = FocusNode();
  String? selectedCenter;
  int? selectedCenterId;
  bool _isCenterFieldOpen = false;
  String? selectedValue;
  final _formKey = GlobalKey<FormState>();
  CenterAvailability? selectedCenterShort;
  AvailableDate? selectedDate;
  DaySectionAvailability? daySectionAvailability;
  AvailableTime? availableTime;

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

  void setAvailableDate(AvailableDate? date) {
    setState(() {
      selectedDate = date;
    });
  }

  void setDaySectionAvailability(DaySectionAvailability? date) {
    setState(() {
      daySectionAvailability = date;
    });
  }

  void setAvailableTime(AvailableTime? data) {
    setState(() {
      availableTime = data;
    });
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
          SizedBox(height: 8),
          Form(
            key: _formKey,
            child: TextFormField(
              focusNode: _idFocusNode,
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
                  color: _idFocusNode.hasFocus
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
                contentPadding:
                const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              ),
              validator: (value) {
                if (value!.isNotEmpty && value.length == 10) {
                  return null;
                } else
                  return AppLocalizations.of(context)!
                      .translateNested('consultation', 'error_national_code');
              },
              onTap: () {
                _idFocusNode.requestFocus();
                setState(() {});
              },
              onTapUpOutside: (_) {
                _idFocusNode.unfocus();
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
              child: DropdownButton2<CenterAvailability>(
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
                items: widget.consultantAvailability.availabilities.inPerson
                    .map((item) => DropdownMenuItem<CenterAvailability>(
                  value: item,
                  child: Text(
                    item.center.name ?? '',
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
                value: selectedCenterShort,
                onMenuStateChange: (isOpen) {
                  setState(() {
                    _centerFocusNode.requestFocus();
                  });
                },
                onChanged: (value) {
                  setState(() {
                    selectedCenterShort = value;
                    _toggleSearchField();
                    _centerFocusNode.unfocus();
                    selectedDate = null;
                    daySectionAvailability = null;
                    availableTime = null;
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
          if (selectedCenterShort != null)
            DatePicker(
                availableDates: selectedCenterShort!.availableDates,
                setAvailableDate: setAvailableDate,
                setDaySectionAvailability: setDaySectionAvailability),
          SizedBox(height: 20),
          if (selectedDate != null)
            DaySelector(
                selectedDate: selectedDate!,
                setDaySectionAvailability: setDaySectionAvailability),
          SizedBox(height: 20),
          (daySectionAvailability != null)
              ? TimePicker(
              times: daySectionAvailability!.times,
              setAvailableTime: setAvailableTime)
              : Text(
            AppLocalizations.of(context)!
                .translateNested("consultation", "select_day"),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          SizedBox(height: 20),
        ],),


        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 12),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 0),
                minimumSize: const Size(double.infinity, 40),
                shadowColor: Colors.transparent,
                backgroundColor: (availableTime != null) ? Color(0x3300A6ED) :
                Theme.of(context).dividerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () async {
                if(availableTime != null && _formKey.currentState!.validate()) {
                  print("availableTime: ${availableTime!.id}");
                  print("consultantId: ${widget.consultantAvailability.consultant.id}");
                  print("nationalId: ${idController.text}");
                  print("type: in_person");

                  _submitForm(
                    context,
                    availableTime!.id,
                    widget.consultantAvailability.consultant.id.toString(),
                    idController.text,
                    "in_person",
                  );
                }
              },
              child: BlocConsumer<ConsultantAvailabilityBloc, ConsultantAvailabilityState>(
                listenWhen: (context, state) =>
                    state is ConsultantAvailabilitySubmitted ||
                    state is ConsultantAvailabilitySubmitError,
                listener: (context, state) {
                  if (state is ConsultantAvailabilitySubmitted) {
                    Navigator.of(context).pop(true);
                  } else if (state is ConsultantAvailabilitySubmitError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        CustomSnackBar(content: state.message).build(context));
                  }
                },
                buildWhen: (context, state) =>
                    state is ConsultantAvailabilitySubmitting ||
                    state is ConsultantAvailabilitySubmitError||
                    state is ConsultantAvailabilitySubmitted,
                    builder: (context, state) {
              if (state is ConsultantAvailabilitySubmitting) {
                return WhiteCircularProgressIndicator();
              }else{
                  return Text(
                AppLocalizations.of(context)!
                    .translateNested("consultation", "pay"),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: (availableTime != null) ? Theme.of(context).colorScheme.tertiary:
                  Theme.of(context).shadowColor,
                    ),
              );
                  }
                    },
                  ),
            ),
          ),
        ),

      ],
    );
  }
}

//function to add event for submit the form
void _submitForm(BuildContext context, int availableTimeId, String consultantId, String nationalId, String type) {
  BlocProvider.of<ConsultantAvailabilityBloc>(context).add(
    SubmitConsultantAvailabilityEvent(
      availableTimeId: availableTimeId,
      consultantId: consultantId,
      nationalId: nationalId,
      type: type,
    ),
  );

}

class DatePicker extends StatefulWidget {
  final List<AvailableDate> availableDates;
  Function(AvailableDate) setAvailableDate;
  Function(DaySectionAvailability?) setDaySectionAvailability;

  DatePicker({
    Key? key,
    required this.availableDates,
    required this.setAvailableDate,
    required this.setDaySectionAvailability,
  }) : super(key: key);

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
          ...widget.availableDates.map(
            (entry) {
              final index = entry.id;

              final isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      widget.setAvailableDate(entry);
                      widget.setDaySectionAvailability(null);
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
                      entry.jalaliDate,
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

class DaySelector extends StatefulWidget {
  AvailableDate selectedDate;
  Function(DaySectionAvailability?) setDaySectionAvailability;

  DaySelector({
    Key? key,
    required this.selectedDate,
    required this.setDaySectionAvailability,
  }) : super(key: key);

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  int? index;

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
              if (widget.selectedDate.sections
                  .any((data) => data.section == DaySection.day))
                setState(() {
                  index = 0;
                  widget.setDaySectionAvailability(widget.selectedDate.sections
                      .firstWhere((data) => data.section == DaySection.day));
                });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border:
                    Border.all(color: index == 0 ? primaryColor : surfaceColor),
                borderRadius: BorderRadius.circular(8),
                color: (widget.selectedDate.sections
                        .any((data) => data.section == DaySection.day))
                    ? Colors.transparent
                    : Theme.of(context).dividerColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.lightSun,
                      size: 14, color: index == 0 ? primaryColor : whiteColor),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("consultation", "day"),
                    style: TextStyle(
                        color: index == 0 ? primaryColor : whiteColor),
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
              if (widget.selectedDate.sections
                  .any((data) => data.section == DaySection.evening))
                setState(() {
                  index = 1;
                  widget.setDaySectionAvailability(widget.selectedDate.sections
                      .firstWhere(
                          (data) => data.section == DaySection.evening));
                });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border:
                    Border.all(color: index == 1 ? primaryColor : surfaceColor),
                borderRadius: BorderRadius.circular(10),
                color: (widget.selectedDate.sections
                        .any((data) => data.section == DaySection.evening))
                    ? Colors.transparent
                    : Theme.of(context).dividerColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.lightCloudSun,
                      size: 14, color: index == 1 ? primaryColor : whiteColor),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("consultation", "evening"),
                    style: TextStyle(
                        color: index == 1 ? primaryColor : whiteColor),
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
              if (widget.selectedDate.sections
                  .any((data) => data.section == DaySection.night))
                setState(() {
                  index = 2;
                  widget.setDaySectionAvailability(widget.selectedDate.sections
                      .firstWhere((data) => data.section == DaySection.night));
                });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border:
                    Border.all(color: index == 2 ? primaryColor : surfaceColor),
                borderRadius: BorderRadius.circular(10),
                color: (widget.selectedDate.sections
                        .any((data) => data.section == DaySection.night))
                    ? Colors.transparent
                    : Theme.of(context).dividerColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.lightMoon,
                      size: 14, color: index == 2 ? primaryColor : whiteColor),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!
                        .translateNested("consultation", "night"),
                    style: TextStyle(
                        color: index == 2 ? primaryColor : whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }
}

class TimePicker extends StatefulWidget {
  final List<AvailableTime> times;
  Function(AvailableTime?) setAvailableTime;

  TimePicker({
    Key? key,
    required this.times,
    required this.setAvailableTime,
  }) : super(key: key);

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.tertiary;

    return SizedBox(
      height: 35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...widget.times.asMap().entries.map(
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
                      widget.setAvailableTime(date);
                    });
                  },
                  child: Container(
                    width: 70,
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
                      "${date.time} - ${date.endTime}",
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
