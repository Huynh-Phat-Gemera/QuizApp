import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/library_screen.dart';
import 'package:quiz_app/profile.dart';
import 'package:quiz_app/solutions.dart';
import 'home.dart';

// ignore: camel_case_types
class navigationBar extends StatefulWidget {
  const navigationBar({Key? key}) : super(key: key);

  @override
  State<navigationBar> createState() => _navigationBarState();
}

// ignore: camel_case_types
class _navigationBarState extends State<navigationBar> {
  // ignore: non_constant_identifier_names
  final navigator_key = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screens = [
    const home(),
    const solutions(),
    const library_screen(),
    const profile()
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget> [
      const Icon(Icons.home_outlined),
      const Icon(Icons.book_outlined),
      const Icon(Icons.folder_open_outlined),
      const Icon(Icons.person_outline),
    ];

    return Container(
      color: Colors.lightBlueAccent,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            body: screens[index],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: CurvedNavigationBar(
                key: navigator_key,
                backgroundColor: Colors.transparent,
                color: Colors.lightBlueAccent,
                height: 70,
                index: index,
                items: items,
                onTap: (index) => setState(() => this.index = index),
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
