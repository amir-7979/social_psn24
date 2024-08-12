import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/localization/app_localizations.dart';

class PostSearchWidget extends StatefulWidget {
  @override
  _PostSearchWidgetState createState() => _PostSearchWidgetState();
}

class _PostSearchWidgetState extends State<PostSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> _searchTags = ["Tag1", "Tag2", "Tag3"]; // Example tags

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _performSearch() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashColor: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.topCenter,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              controller: _controller,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).colorScheme.shadow,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsetsDirectional.symmetric(vertical: 8), // Adjust vertical padding
                                hintText: AppLocalizations.of(context)!.translateNested('search', 'search'),
                                hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                suffixIconConstraints: BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                suffixIcon: _controller.text.isNotEmpty
                                    ? IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 22,
                                  onPressed: () {
                                    _controller.clear();
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/images/search/cross.svg'),
                                )
                                    : null,
                                isDense: true,
                              ),
                              textAlignVertical: TextAlignVertical.center, // Ensures text is centered vertically
                            ),

                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                            iconSize: 40,
                            onPressed: _performSearch,
                            icon: SvgPicture.asset(
                                'assets/images/search/search.svg')),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _searchTags.map((tag) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Chip(
                          label: Text(tag),
                          backgroundColor: Colors.grey[200],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (_controller.text.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _searchTags.map((tag) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(tag),
                            backgroundColor: Colors.grey[200],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              // The third part is always transparent and can be used for future content.
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
