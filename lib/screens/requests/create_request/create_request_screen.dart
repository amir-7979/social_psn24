import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:searchfield/searchfield.dart';
import 'package:social_psn/screens/main/widgets/screen_builder.dart';
import 'package:social_psn/screens/requests/create_request/create_request_bloc.dart';
import 'package:social_psn/screens/widgets/red_circular_progress_indicator.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/cooperation_type.dart';
import '../../../repos/models/request_data.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/white_circular_progress_indicator.dart';

class CreateRequestScreen extends StatefulWidget {
  CreateRequestScreen({Key? key}) : super(key: key);

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController longTextController = TextEditingController();
  final _categoryFocusNode = FocusNode();
  final _longTextFocusNode = FocusNode();
  String? _selectedCategory;
  List<CooperationType> _categories = [];
  int _maxLength = 250;
  bool _categoryState = true;
  bool _isSearchFieldOpen = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RequestData? newRequestData;
  bool _isChecked = false;
  CooperationType? selected;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        newRequestData =
            ModalRoute.of(context)?.settings.arguments as RequestData?;
        setState(() {
          selected = newRequestData?.type != null
              ? CooperationType(
                  name: newRequestData?.type,
                  description: newRequestData?.description,
                )
              : null;
        });
      }

      if (newRequestData != null) {
        categoryController.text = newRequestData?.type ?? '';
        longTextController.text = newRequestData?.description ?? '';
      }
    });
    longTextController.addListener(_updateCounter);
    categoryController.addListener(_validateCategoryInput);
    _categoryFocusNode.addListener(() {
      if (!_categoryFocusNode.hasFocus) {
        setState(() {
          _isSearchFieldOpen = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    longTextController.removeListener(_updateCounter);
    categoryController.removeListener(_validateCategoryInput);
    categoryController.dispose();
    longTextController.dispose();
    _scrollController.dispose();
    _categoryFocusNode.dispose();
    _longTextFocusNode.dispose();
    super.dispose();
  }

  void _updateCounter() => setState(() {});

  void _validateCategoryInput() {
    setState(() {
      _categoryState = _categories
          .any((category) => (category.name ?? '') == categoryController.text);
    });
  }

  void _toggleSearchField() {
    setState(() {
      _isSearchFieldOpen = !_isSearchFieldOpen;
      if (!_isSearchFieldOpen) {
        _categoryFocusNode.unfocus();
      } else {
        _categoryFocusNode.requestFocus();
      }
    });
  }

  List<CooperationType> _filterCategories(String query) => query.isEmpty
      ? _categories
      : _categories
          .where((category) =>
              (category.name ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();

  void _submitCooperation(CreateRequestBloc bloc) {
    if (_formKey.currentState!.validate()) {
      bloc.add(
        AddCooperation(
          "_",
          longTextController.text,
          _categories
                  .firstWhere(
                      (category) => category.name == categoryController.text)
                  .id ??
              0,
          [],
        ),
      );
    }
  }

  void returnToPreviousScreen() {
    Navigator.of(context).pop();
  }

  void cancelCooperation(CreateRequestBloc bloc) {
    if (newRequestData != null) {
      bloc.add(
        CancelCooperation(
          newRequestData!.id!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateRequestBloc()..add(FetchCooperationType()),
      child: Builder(builder: (context) {
        return BlocConsumer<CreateRequestBloc, CreateRequestState>(
          listenWhen: (_, state) {
            return state is TypeLoaded ||
                state is TypeError ||
                state is SubmittingRequestError ||
                state is SubmittingRequestSuccess||
            state is CancelRequestSuccess;
          },
          listener: (context, state) {
            if (state is TypeLoaded) {
              setState(() {
                _categories = state.types;
              });
            } else if (state is TypeError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar(content: state.message).build(context));
            } else if (state is SubmittingRequestError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  CustomSnackBar(content: state.message).build(context));
            } else if (state is SubmittingRequestSuccess) {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.requestsList);
            }else if (state is CancelRequestSuccess) {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.requestsList);
            }
          },
          builder: (context, state) {
            if (state is TypeLoading) {
              return const Center(
                child: WhiteCircularProgressIndicator(),
              );
            } else {
              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    AppLocalizations.of(context)!.translateNested(
                        "consultation",
                        newRequestData != null ? "showRequest" : "addRequest"),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
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
                  SizedBox(height: 16),
                  PostForm(context),
                  const SizedBox(height: 16),
                  if (newRequestData == null)
                    Row(
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
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
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
                                        fontWeight: FontWeight.w600,
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
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).hoverColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (newRequestData == null) const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (newRequestData != null &&
                          newRequestData!.status == "pending")
                        Expanded(
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              child: BlocBuilder<CreateRequestBloc,
                                  CreateRequestState>(
                                builder: (context, state) {
                                  return (state is CancelRequestLoading) ? RedCircularProgressIndicator() : Text(
                                    AppLocalizations.of(context)!
                                        .translateNested(
                                            'consultation', 'cancelRequest'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                  );
                                },
                              ),
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                //foregroundColor: Theme.of(context).colorScheme.tertiary,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final bloc = context.read<CreateRequestBloc>();
                                cancelCooperation(bloc);
                              },
                            ),
                          ),
                        )
                      else
                        Expanded(
                            child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: returnToPreviousScreen,
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor: Color(0x3300A6ED),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translateNested('profileScreen', 'return'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                            ),
                          ),
                        )),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              if (newRequestData == null) {
                                if (_isChecked) {
                                  final bloc =
                                      context.read<CreateRequestBloc>();
                                  _submitCooperation(bloc);
                                }
                              } else {
                                returnToPreviousScreen();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              surfaceTintColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              backgroundColor:
                                  newRequestData == null && !_isChecked
                                      ? Colors.grey
                                      : Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: BlocBuilder<CreateRequestBloc,
                                CreateRequestState>(
                              builder: (context, state) {
                                return state is SubmittingRequestLoading
                                    ? WhiteCircularProgressIndicator()
                                    : Text(
                                        newRequestData != null
                                            ? AppLocalizations.of(context)!
                                                .translateNested(
                                                    'profileScreen', 'return')
                                            : AppLocalizations.of(context)!
                                                .translateNested(
                                                    'profileScreen',
                                                    'sendRequest'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: whiteColor,
                                            ),
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
          },
        );
      }),
    );
  }

  Widget PostForm(BuildContext context) {
    List<CooperationType> filteredCategories =
        _filterCategories(categoryController.text);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SearchField<String>(
            readOnly: newRequestData?.id != null,
            suggestions: filteredCategories
                .map((category) => SearchFieldListItem<String>(
                      category.name ?? '',
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: Text(
                            category.name ?? '',
                            textDirection: TextDirection.rtl,
                            // Align text to the right
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
            controller: categoryController,
            focusNode: _categoryFocusNode,
            suggestionState: Suggestion.expand,
            suggestionStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            searchInputDecoration: SearchInputDecoration(
              label: Text(
                AppLocalizations.of(context)!
                    .translateNested("createMedia", "category"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: _categoryFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor,
                    ),
              ),
              searchStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              enabledBorder: borderStyle,
              errorBorder: errorBorderStyle,
              border: borderStyle,
              focusedErrorBorder: errorBorderStyle,
              contentPadding:
                  const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (newRequestData?.id == null &&
                      categoryController.text.isNotEmpty)
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        alignment: AlignmentDirectional.centerEnd,
                        onPressed: () {
                          setState(() {
                            categoryController.clear();
                          });
                        },
                        icon: FaIcon(
                          size: 22,
                          FontAwesomeIcons.solidCircleXmark,
                          color: _categoryState
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  SizedBox(width: 12),
                  if (newRequestData?.id == null)
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: _toggleSearchField,
                        icon: FaIcon(
                          size: 18,
                          _isSearchFieldOpen
                              ? FontAwesomeIcons.solidCaretUp
                              : FontAwesomeIcons.solidCaretDown,
                          color:
                              _categoryState || categoryController.text.isEmpty
                                  ? Theme.of(context).colorScheme.surface
                                  : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                ],
              ),
            ),
            itemHeight: 50,
            maxSuggestionsInViewPort: 4,
            suggestionsDecoration: SuggestionDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(8),
              selectionColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                _categoryState = false;
                return AppLocalizations.of(context)!
                    .translateNested('error', 'notEmpty');
              } else if (!_categories
                  .any((category) => category.name == value)) {
                setState(() {
                  _categoryState = false; // Invalid category
                });
                return '';
              }
              setState(() {
                _categoryState = true; // Valid category
              });
              return null;
            },
            onTap: () {
              if (newRequestData?.id != null) {
                _categoryFocusNode.unfocus();
                return;
              }
              setState(() {
                _isSearchFieldOpen = true;
              });
            },
            onSuggestionTap: (suggestion) {
              print(suggestion.searchKey);
              selected = _categories.firstWhere(
                (element) => element.name == suggestion.searchKey,
                orElse: () =>
                    CooperationType(name: '', description: ''), // avoid null
              );
              setState(() {
                selected = _categories.firstWhere(
                  (element) => element.name == suggestion.searchKey,
                  orElse: () =>
                      CooperationType(name: '', description: ''), // avoid null
                );
                _selectedCategory = suggestion.searchKey;
                categoryController.text = suggestion.searchKey;
                _categoryState = true;
                _isSearchFieldOpen = false;
                _categoryFocusNode.unfocus();
                _longTextFocusNode.requestFocus();
              });
            },
            onSubmit: (value) {
              setState(() {
                _isSearchFieldOpen = false;
                _categoryFocusNode.unfocus();
                _longTextFocusNode.requestFocus();
              });
            },
          ),
          SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              selected != null ? selected?.description ?? '' : "",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 130.0,
            child: TextFormField(
              readOnly: newRequestData?.id != null,
              focusNode: _longTextFocusNode,
              controller: longTextController,
              maxLines: 50,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
              maxLength: _maxLength,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!
                    .translateNested("params", "description"),
                labelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: _longTextFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor,
                    ),
                alignLabelWithHint: true,
                constraints: BoxConstraints(
                  minHeight: 130.0,
                ),
                enabledBorder: borderStyle,
                errorBorder: errorBorderStyle,
                border: borderStyle,
                focusedErrorBorder: errorBorderStyle,
              ),
              buildCounter: (context,
                  {required currentLength,
                  required maxLength,
                  required bool isFocused}) {
                return Text(
                  '$maxLength/$currentLength',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: _longTextFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hintColor,
                      ),
                );
              },
              onTap: () {
                if (newRequestData?.id != null) {
                  _longTextFocusNode.unfocus();
                  return;
                }
                setState(() {});
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!
                      .translateNested('error', 'notEmpty');
                } else if (value.length > _maxLength) {
                  return AppLocalizations.of(context)!
                      .translateNested('error', 'length_exceed');
                }
                return null;
              },
              onFieldSubmitted: (value) {
                setState(() {
                  FocusScope.of(context).unfocus();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
