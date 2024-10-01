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
   PostForm(this.titleController, this.categoryController, this.longTextController);

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.longTextController.addListener(_updateCounter);
  }

  @override
  void didChangeDependencies() {
    _categories = BlocProvider.of<SettingBloc>(context).state.tagsList;
    super.didChangeDependencies();
  }

  @override
  void dispose() {

    widget.longTextController.removeListener(_updateCounter);
    super.dispose();
  }

  void _updateCounter() {
    setState(() {});
  }

  @override
  build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Title
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
          // Category
          BlocListener<CreatePostBloc, CreatePostState>(
            listener: (context, state) {
              if (state is ResetCategoryState) {
                setState(() {
                  widget.categoryController.clear();
                });
              }
            },
            child: SearchField<String>(
              suggestions: _categories
                  .map((category) => SearchFieldListItem<String>(category.title??''))
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
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                suffixIcon: (widget.categoryController.text.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.categoryController.clear();
                          });
                        },
                        icon: FaIcon(
                            size: 25,
                            FontAwesomeIcons.solidCircleXmark,
                            color: Theme.of(context).colorScheme.surface))
                    : null,
              ),
              itemHeight: 50,
              maxSuggestionsInViewPort: 4,
              suggestionsDecoration: SuggestionDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Category must not be empty';
                } else if (!_categories.contains(value)) {
                  return 'Invalid Category';
                }
                return null;
              },
              onTap: () {
                setState(() {});
              },
              onSuggestionTap: (suggestion) {
                setState(() {
                  _selectedCategory = suggestion.item;
                  _categoryFocusNode.unfocus();
                  _longTextFocusNode.requestFocus();
                });

              },
              onSubmit: (value) {
                setState(() {
                  _categoryFocusNode.unfocus();
                  _longTextFocusNode.requestFocus();
                });
              },
            ),
          ),
          SizedBox(height: 16),
          // Text Body
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
