import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:searchfield/searchfield.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/tag.dart';
import '../create_post_bloc.dart';

class PostForm extends StatefulWidget {
  TextEditingController titleController;
  TextEditingController categoryController;
  TextEditingController longTextController;
  PostForm(
      this.titleController, this.categoryController, this.longTextController);

  @override
  WidgetPostFormState createState() => WidgetPostFormState();
}

class WidgetPostFormState extends State<PostForm> {
  final _titleFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _longTextFocusNode = FocusNode();
  String? _selectedCategory;
  List<Tag> _categories = [];
  final int _maxLength = 200;
  bool _categoryState = true;
  bool _isSearchFieldOpen = false; // Track whether suggestions are open or closed
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.longTextController.addListener(_updateCounter);
    widget.categoryController.addListener(_validateCategoryInput);
    _categoryFocusNode.addListener(() {
      if (!_categoryFocusNode.hasFocus) {
        setState(() {
          _isSearchFieldOpen = false; // Close search field if focus is lost
        });
      }
    });
    _categories = BlocProvider.of<SettingBloc>(context).state.tagsList; // Initialize categories here
  }

  @override
  void didChangeDependencies() {
    _categories = BlocProvider.of<SettingBloc>(context).state.tagsList;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.longTextController.removeListener(_updateCounter);
    widget.categoryController.removeListener(_validateCategoryInput);
    _categoryFocusNode.dispose();
    super.dispose();
  }

  void _updateCounter() {
    setState(() {});
  }

  List<Tag> _filterCategories(String query) {
    if (query.isEmpty) {
      return _categories; // Return all categories if query is empty
    }
    return _categories
        .where((category) => category.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _validateCategoryInput() {
    setState(() {
      _categoryState = _categories
          .any((category) => category.title == widget.categoryController.text);
    });
  }

  void _toggleSearchField() {
    setState(() {
      _isSearchFieldOpen = !_isSearchFieldOpen;
      if (!_isSearchFieldOpen) {
        // Close the search field by unfocusing it
        _categoryFocusNode.unfocus();
      } else {
        // Reopen the search field by focusing it
        _categoryFocusNode.requestFocus();
      }
    });
  }

  @override
  build(BuildContext context) {
    List<Tag> filteredCategories = _filterCategories(widget.categoryController.text);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget.titleController,
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
                  widget.categoryController.clear();
                  _categoryState = true;
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
              controller: widget.categoryController,
              focusNode: _categoryFocusNode,
              suggestionState: Suggestion.expand,
              searchStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              suggestionStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              searchInputDecoration: InputDecoration(
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
                    if (widget.categoryController.text.isNotEmpty)
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          alignment: AlignmentDirectional.centerEnd,
                          onPressed: () {
                            setState(() {
                              widget.categoryController.clear();
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
                          color: _categoryState || widget.categoryController.text.isEmpty
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
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  _categoryState = false; // No category entered
                  return 'Category must not be empty';
                } else if (!_categories.any((category) => category.title == value)) {
                  setState(() {
                    print('Invalid category');
                    _categoryState = false; // Invalid category
                  });
                  return 'Invalid Category';
                }
                setState(() {
                  _categoryState = true; // Valid category
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
                  _selectedCategory = suggestion.item;
                  _categoryState = true;
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
              controller: widget.longTextController,
              maxLines: 50,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              maxLength: 200,
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
                  '200/$currentLength',
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
