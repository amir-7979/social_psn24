import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import '../cooperation_bloc.dart';

class ExpertUserCooperation extends StatefulWidget {
  ExpertUserCooperation();

  @override
  State<ExpertUserCooperation> createState() => _ExpertUserCooperationState();
}

class _ExpertUserCooperationState extends State<ExpertUserCooperation> {
  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Container(
        height: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .translateNested("drawer", 'drawerHand'),
              style: iranYekanTheme.displayMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0),
                    Theme.of(context).primaryColor.withOpacity(1),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'کاربر گرامی در صورت تمایل به همکاری در هر یک از زمینه‌های زیر درخواست خود را برای ما ارسال کنید.',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).hoverColor,
                        ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '۱- تولید پست عمومی (محتوا برای عموم)',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).hoverColor,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '۲- ممیزی محتوا',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).hoverColor,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '۳-‌ تولید پست تخصصی (محتوا برای خبرگان)',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).hoverColor,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              end: 10, start: 0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                  color: _isChecked
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _isChecked
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).hintColor,
                                    width: 1,
                                  ),
                                  //i want square
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  )),
                              child: _isChecked
                                  ? const Icon(
                                      Icons.check,
                                      size: 18.0,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text.rich(
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  color: Theme.of(context).hoverColor,
                                ),
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .translateNested('cooperate', 'terms1'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => print('Link clicked'),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .translateNested('cooperate', 'terms2'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 16),
                    child: BlocBuilder<CooperationBloc, CooperationState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            //surfaceTintColor: Colors.transparent,
                            //foregroundColor: Theme.of(context).colorScheme.tertiary,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            //todo: send request
                          },
                          child: state is CooperationLoading
                              ? WhiteCircularProgressIndicator()
                              : Text(
                                  AppLocalizations.of(context)!.translateNested(
                                      'profileScreen', 'sendRequest'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: whiteColor,
                                      ),
                                ),
                        );
                      },
                    ),
                  ),

                  /*
                  Expanded(
                    child: BlocBuilder<CooperationBloc, CooperationState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            // Handle button press
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state is CooperationLoading
                              ? WhiteCircularProgressIndicator()
                              : Text(
                            AppLocalizations.of(context)!.translateNested(
                                'profileScreen', 'sendRequest'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
              */
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
