import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../configs/utilities.dart';
import '../../../repos/models/profile.dart';
import '../../../repos/models/tag.dart';
import '../../home/home_bloc.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/appbar/appbar_bloc.dart';
import '../../widgets/new_page_progress_indicator.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../post_search_bloc.dart';

class PostSearchWidget extends StatefulWidget {
  List<String> mainTags;
  List<String> type;
  String title;

  PostSearchWidget(this.mainTags, this.type, this.title);

  @override
  State<PostSearchWidget> createState() => _PostSearchWidgetState();
}

class _PostSearchWidgetState extends State<PostSearchWidget> {
  final TextEditingController _controller = TextEditingController();
  List<Profile> _users = [];
  final FocusNode _focusNode = FocusNode();
  final PagingController<int, Tag> _pagingController = PagingController(firstPageKey: 0);
  final int _pageSize = 20;
  int index = 0;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.title;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _pagingController.addPageRequestListener((pageKey) {
      context
          .read<PostSearchBloc>()
          .add(NewPostSearch(pageKey, _pageSize, _searchQuery));
    });
    context.read<PostSearchBloc>().stream.listen((state) {
      if (state is TagsLoadedState) {
        final isLastPage = state.tags.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(state.tags);
        } else {
          final nextPageKey = state.pageKey + state.tags.length;
          _pagingController.appendPage(state.tags, nextPageKey);
        }
      } else if (state is TagsErrorState) {
        _pagingController.error = state.error;
      } else if (state is UserLoadedState) {
        _users = state.users;
      } else if (state is UserErrorState) {}
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _pagingController.dispose();
    _focusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
  }

  void _onTextChanged() {
    _searchQuery = _controller.text;
    context.read<PostSearchBloc>().add(NewUserSearch(_searchQuery!));
    if (_controller.text.isEmpty || _controller.text == '') {
      _searchQuery = null;
    }
    _pagingController.refresh();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildSearchField(context),
            buildMainTag(context),
            (_searchQuery != null && _searchQuery!.length > 2 &&
                _pagingController.itemList != null &&
                _pagingController.itemList!.isEmpty) ? Container() : buildSubTagsList(),
            buildUsersList(), // New method to build users list
          ],
        ),
      ),
    );
  }

  Container buildSearchField(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  textDirection: detectDirection(_controller.text),
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: (_) {
                    Navigator.of(context).pop();
                    BlocProvider.of<AppbarBloc>(context)
                        .add(AppbarSearch(_controller.text));
                    BlocProvider.of<HomeBloc>(context).add(SearchPostsEvent(
                        _controller.text,
                        null,
                        index == 0 || index == 1 ? 0 : 1));
                  },
                  onChanged: (value) {
                    _onTextChanged();
                  },
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.shadow,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsetsDirectional.symmetric(vertical: 8),
                    // Adjust vertical padding
                    hintText: AppLocalizations.of(context)!
                        .translateNested('search', 'search'),
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
                                'assets/images/search/cross.svg',
                                height: 22,
                                width: 22),
                          )
                        : null,
                    isDense: true,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 40,
                  onPressed: () {
                    Navigator.of(context).pop();
                    BlocProvider.of<AppbarBloc>(context)
                        .add(AppbarSearch(_controller.text));
                    BlocProvider.of<HomeBloc>(context).add(SearchPostsEvent(
                        _controller.text,
                        null,
                        index == 0 || index == 1 ? 0 : 1));
                  },
                  icon: SvgPicture.asset('assets/images/search/search.svg')),
            ),
          ],
        ),
      ),
    );
  }

  Container buildMainTag(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: (_controller.text.length > 2)
                ? Theme.of(context).colorScheme.background
                : Colors.transparent,
            border: Border.all(
                color: (_controller.text.length > 2)
                    ? Theme.of(context).colorScheme.background
                    : Colors.transparent)),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 0, 8),
          child: Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.mainTags.length,
              padding: const EdgeInsetsDirectional.only(end: 8),
              itemBuilder: (context, i) {
                final tag = widget.mainTags[i];
                return Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          index = i;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: index == i
                                    ? Theme.of(context).colorScheme.tertiary
                                    : _controller.text.length > 2
                                        ? searchBorderColor
                                        : Theme.of(context)
                                            .colorScheme
                                            .background,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                tag,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: index == i
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                          : Theme.of(context)
                                              .colorScheme
                                              .shadow,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                          if (index == i)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ));
              },
            ),
          ),
        ));
  }

  Padding buildSubTag(BuildContext context, Tag tag) {
    return Padding(
        padding: const EdgeInsetsDirectional.only(start: 4.0),
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
            BlocProvider.of<AppbarBloc>(context)
                .add(AppbarSearch(tag.title.toString()));
            BlocProvider.of<HomeBloc>(context).add(SearchPostsEvent(
                null, tag.id, index == 0 || index == 1 ? 0 : 1));
          },
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _controller.text.length > 2
                    ? searchBorderColor
                    : Theme.of(context).colorScheme.background,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tag.title.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.shadow,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(width: 8),
                  FaIcon(
                    size: 13,
                    FontAwesomeIcons.thinChevronLeft,
                    color: Theme.of(context).colorScheme.shadow,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildSubTagsList() {
    return Container(
      color: (_controller.text.length > 2 &&
              _pagingController.itemList != null &&
              _pagingController.itemList!.isNotEmpty)
          ? Theme.of(context).colorScheme.background
          : Colors.transparent,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          if (_controller.text.length > 2 &&
              _pagingController.itemList != null &&
              _pagingController.itemList!.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 8),
              child: Text(
                AppLocalizations.of(context)!
                    .translateNested('search', 'category'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          SizedBox(
            height: 35,
            child: PagedListView<int, Tag>(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Tag>(
                itemBuilder: (context, tag, i) {
                  if (index == 0)
                    return buildSubTag(context, tag);
                  else
                    return (tag.type == widget.type[index])
                        ? buildSubTag(context, tag)
                        : Container();
                },
                firstPageProgressIndicatorBuilder: (context) => Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 16, end: 16, top: 8, bottom: 8),
                  child: SizedBox(
                      height: 10, width: 10, child: NewPageProgressIndicator()),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget buildUsersList() {
    if (_controller.text.length > 2 && _users.isNotEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.background,
        height: 101, // Adjust the height as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 10),
              child: Text(
                AppLocalizations.of(context)!
                    .translateNested('search', 'users'),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(
              height: 55, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _users.length,
                itemBuilder: (context, i) {
                  final user = _users[i];
                  return buildUserItem(context, user);
                },
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      );
    } else {
      return Container(); // Return an empty container if there are no users to display
    }
  }

  Widget buildUserItem(BuildContext context, Profile user) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pop();
        navigatorKey.currentState!
            .pushNamed(AppRoutes.profile, arguments: user.id?.toInt());
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: Container(
          height: 55,
          padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: searchBorderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: user.photo != null
                      ? ProfileCacheImage(user.photo)
                      : SvgPicture.asset(
                          'assets/images/search/rectangular_profile_placeholder.svg'),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName ?? '',
                    // Display user's name or other properties
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.shadow,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  SizedBox(height: 2),
                  if (user.username != null &&
                      user.username!.isNotEmpty &&
                      user.username != '@')
                    Flexible(
                      child: Text(
                        '(@${user.username})',
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
