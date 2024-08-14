import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/screens/home/home_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/utilities.dart';
import '../../post_search/post_search_screen.dart';

class MySearchBar extends StatefulWidget {
  String? query;
  MySearchBar(this.query);

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.query??'';
  }


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildSearchField(context), // New method to build users list
        ],
      ),
    );
  }

  Container buildSearchField(BuildContext context) {
    return Container(
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
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: EdgeInsets.zero,
                          elevation: 0,
                          surfaceTintColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          insetAnimationDuration: Duration.zero,
                          child: PostSearchScreen(),
                        );
                      },
                    );
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
            IconButton(
                padding: EdgeInsets.zero,
                iconSize: 40,
                onPressed: (){
                  //Navigator.of(context).pop();
                  BlocProvider.of<HomeBloc>(context).resetState();
                },
                icon: SvgPicture.asset('assets/images/search/close.svg')),
          ],
        ),
      ),
    );
  }
}
