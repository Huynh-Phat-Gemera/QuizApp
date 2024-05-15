import 'package:flutter/material.dart';

// ignore: camel_case_types
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

// ignore: camel_case_types
class _homeState extends State<home> {

  @override
  Widget build(BuildContext context) => SafeArea(
		child: Scaffold(
			body: Padding(
				padding: EdgeInsets.all(20),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: const [
						Text(
							'Home page',
							style: TextStyle(fontSize: 16),
						),
					],
				),
			),
		),
	);
}
