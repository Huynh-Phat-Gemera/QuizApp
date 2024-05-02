import 'package:flutter/material.dart';

// ignore: camel_case_types
class solutions extends StatefulWidget {
  const solutions({Key? key}) : super(key: key);

  @override
  State<solutions> createState() => _solutionsState();
}

// ignore: camel_case_types
class _solutionsState extends State<solutions> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Text('solutions page')
					],
        ))
    );
  }
}
