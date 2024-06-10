import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/home/widgets/post_screen.dart';
import 'home_bloc.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
          ),
          child: PostScreen(),
        ),
      ),
    );
  }
}
