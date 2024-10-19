
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchfield/searchfield.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/repos/models/admin_setting.dart';
import 'package:social_psn/repos/models/post.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/tag.dart';
import '../../widgets/white_circular_progress_indicator.dart';
import '../create_post_bloc.dart';
import 'post_content.dart';

class MainForm extends StatefulWidget {
  final Post? newPost;

  MainForm({this.newPost, Key? key}) : super(key: key);

  @override
  State<MainForm> createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController longTextController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _longTextFocusNode = FocusNode();
  List<Tag> _categories = [];
  int _maxLength = 200;
  int _publicMaxLength = 1000;
  int _privateMaxLength = 500;
  bool _isSearchFieldOpen = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AdminSettings? adminSettings;
  Timer? _submitTimer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.newPost != null) {
        titleController.text = widget.newPost!.name ?? '';
        Tag? tag = BlocProvider.of<SettingBloc>(context).state.tagsList?.firstWhere(
              (element) => element.id == widget.newPost?.tagId,
          orElse: () => Tag(id: null, title: ''), // Default value instead of null
        );
        categoryController.text = tag?.title ?? '';
        longTextController.text = widget.newPost!.description ?? '';
      }
    });
    adminSettings = BlocProvider.of<CreatePostBloc>(context).adminSettings;
    _submitTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _submitPost();
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
    _categories = BlocProvider.of<SettingBloc>(context).state.tagsList;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _categories = BlocProvider.of<SettingBloc>(context).state.tagsList;
    _publicMaxLength = BlocProvider.of<CreatePostBloc>(context).adminSettings?.maxCharactersForPicPost??900;
    _maxLength = _publicMaxLength;
    _privateMaxLength = BlocProvider.of<CreatePostBloc>(context).adminSettings?.maxCharactersForPicPrivatePost??400;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    longTextController.removeListener(_updateCounter);
    categoryController.removeListener(_validateCategoryInput);
    _submitTimer?.cancel();
    titleController.dispose();
    categoryController.dispose();
    longTextController.dispose();
    _scrollController.dispose();
    _titleFocusNode.dispose();
    _categoryFocusNode.dispose();
    _longTextFocusNode.dispose();
    super.dispose();
  }

  void _updateCounter() => setState(() {});

  List<Tag> _filterCategories(String query) => query.isEmpty ? _categories : _categories
        .where((category) => category.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();

  void _validateCategoryInput() {
    setState(() {
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
  void validatePost(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<CreatePostBloc>(context).add(
        SubmitNewPostEvent(
          title: titleController.text,
          category: context.read<SettingBloc>().state.tags!.firstWhere(
                (element) => element.title == categoryController.text,
            orElse: () => context.read<SettingBloc>().state.tagsList.first,
          ).id??'',
          longText: longTextController.text,
          status: 1,
          publish: 1,
          postType: context.read<CreatePostBloc>().postType? 1:0,
        ),
      );
    }
  }

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<CreatePostBloc>(context).add(DraftPostEvent(
        title: titleController.text,
        category: context.read<SettingBloc>().state.tags!.firstWhere(
              (element) => element.title == categoryController.text,
          orElse: () => context.read<SettingBloc>().state.tagsList.first,
        ).id ?? '',
        longText: longTextController.text,
        status: 0,
        publish: 0,
        postType: context.read<CreatePostBloc>().postType ? 1 : 0,
      ),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          AppLocalizations.of(context)!
              .translateNested("createMedia", 'createMedia'),
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
        if(adminSettings != null && widget.newPost!= null)
          PostContent(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.tertiary,
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
                    validatePost(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: BlocBuilder<CreatePostBloc, CreatePostState>(
                    builder: (context, state) {
                      return state is SubmittingPostLoading
                          ? WhiteCircularProgressIndicator()
                          : Text(
                              AppLocalizations.of(context)!
                                  .translateNested('profileScreen', 'save'),
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


  Widget PostForm(BuildContext context){
      List<Tag> filteredCategories = _filterCategories(categoryController.text);
      return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              keyboardType: TextInputType.name,
              focusNode: _titleFocusNode,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!
                      .translateNested("createMedia", "subject"),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: _titleFocusNode.hasFocus
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                  ),
                ),
                enabledBorder: borderStyle,
                errorBorder: errorBorderStyle,
                border: borderStyle,
                focusedErrorBorder: errorBorderStyle,
                contentPadding:
                const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!
                      .translateNested('error', 'notEmpty');
                } else if (value.length > 100) {
                  return AppLocalizations.of(context)!
                      .translateNested('error', 'length_exceed');
                }
                return null;
              },
              onFieldSubmitted: (value) {
                setState(() {
                  _titleFocusNode.unfocus();
                  _categoryFocusNode.requestFocus();
                });
              },
              onTap: () {
                setState(() {});
              },
            ),
            SizedBox(height: 16),
            BlocListener<CreatePostBloc, CreatePostState>(
              listener: (context, state) {
                if (state is ResetCategoryState) {
                  setState(() {
                    categoryController.clear();
                    _maxLength = state.type ? _privateMaxLength : _publicMaxLength;
                    _isSearchFieldOpen = false;

                  });
                }
              },
              child: SearchField<String>(
                suggestions: filteredCategories
                    .map((category) => SearchFieldListItem<String>(
                  category.title ?? '',
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Text(
                        category.title ?? '',
                        textDirection: TextDirection.rtl, // Align text to the right
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
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



                /*searchStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),*/
                suggestionStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                /*searchInputDecoration: InputDecoration(
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
                      if (categoryController.text.isNotEmpty)
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
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _toggleSearchField,

                          icon: FaIcon(
                            size: 18,
                            _isSearchFieldOpen ? FontAwesomeIcons.solidCaretUp : FontAwesomeIcons.solidCaretDown,
                            color: _categoryState || categoryController.text.isEmpty
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),*/
                itemHeight: 50,
                maxSuggestionsInViewPort: 4,
                suggestionsDecoration: SuggestionDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
// No category entered
                    return AppLocalizations.of(context)!
                        .translateNested('error', 'notEmpty');
                  } else if (!_categories.any((category) => category.title == value)) {
                    setState(() {
// Invalid category
                    });
                    return 'Invalid Category';
                  }
                  setState(() {
// Valid category
                  });
                  return null;
                },
                onTap: () {
                  setState(() {
                    _isSearchFieldOpen = true; // Open suggestions
                  });
                },
                onSuggestionTap: (suggestion) {
                  setState(() {
                    _isSearchFieldOpen = false; // Close suggestions
                    _categoryFocusNode.unfocus();
                    _longTextFocusNode.requestFocus();
                  });
                },
                onSubmit: (value) {
                  setState(() {
                    _isSearchFieldOpen = false; // Close suggestions
                    _categoryFocusNode.unfocus();
                    _longTextFocusNode.requestFocus();
                  });
                },
              ),

            ),
            SizedBox(height: 16),
            Container(
              height: 130.0,
              child: TextFormField(
                focusNode: _longTextFocusNode,
                controller: longTextController,
                maxLines: 50,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                maxLength: _maxLength,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translateNested("createMedia", "text"),
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
                    '$_publicMaxLength/$currentLength',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: _longTextFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).hintColor,
                    ),
                  );
                },
                onTap: () {
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

