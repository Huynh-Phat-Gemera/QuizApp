import 'package:flutter/material.dart';

// ignore: camel_case_types
class library_screen extends StatefulWidget {
  const library_screen({Key? key}) : super(key: key);

  @override
  State<library_screen> createState() => _library_screenState();
}

// ignore: camel_case_types
class _library_screenState extends State<library_screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
					children: const [
						Text('Library page')
					],
        ))
    );
  }
}
