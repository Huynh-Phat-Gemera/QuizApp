import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Quizlet',
          style: TextStyle(color: Colors.white),
        ),
      ),
			body: Padding(
				padding: const EdgeInsets.all(20),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						const Text(
							'Signed In as',
							style: TextStyle(fontSize: 16),
						),
						const SizedBox(height: 16),
						Text(
							user.email!,
							style: const TextStyle(
								fontSize: 20,
								fontWeight: FontWeight.bold
							),
						),
						const SizedBox(height: 40),
						ElevatedButton.icon(
							style: ElevatedButton.styleFrom(
								minimumSize: const Size.fromHeight(50),
							),
							icon: const Icon(Icons.arrow_back, size: 32),
							label: const Text(
								'Sign Out',
								style: TextStyle(fontSize: 24),
							),
							onPressed: () => FirebaseAuth.instance.signOut(),
						)
					],
				),
			),
    );
  }
}
