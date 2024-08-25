import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/localization/app_localizations.dart';
import 'post_search_bloc.dart';
import 'widget/search_widget.dart';

class PostSearchScreen extends StatelessWidget {
  final String title;

  PostSearchScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostSearchBloc(),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashColor: Colors.transparent,
        child: PostSearchWidget([
          AppLocalizations.of(context)!.translateNested('search', 'all'),
          AppLocalizations.of(context)!.translateNested('search', 'public'),
          AppLocalizations.of(context)!.translateNested('search', 'expert')
        ], [
          'all',
          'public',
          'private'
        ], title),
      ),
    );
  }
}
