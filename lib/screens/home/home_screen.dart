import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/home/widgets/post_screen.dart';
import 'home_bloc.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;

  void changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('HomeScreen build');
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Stack(
          children: [
            Visibility(
              visible: _currentIndex == 0,
              child: PostScreen(changeIndex),
              maintainState: false,
            ),
/*
              Visibility(
                visible: _currentIndex == 1,
                child: PostDetailScreen(changeIndex), // Pass _changeIndex to PostDetailScreen
                maintainState: false,
              ),
*/
          ],
        ),
      ),
    );
  }
}