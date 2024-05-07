import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class profile extends StatefulWidget {
	const profile({Key? key}) : super(key: key);

	@override
	State<profile> createState() => _profileState();
}

// ignore: camel_case_types
class _profileState extends State<profile> {
	final user = FirebaseAuth.instance.currentUser!;

	Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete your account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await user.delete();
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } catch (e) {
                  if (kDebugMode) {
                    print("Error deleting user: $e");
                  }
                  // Handle error if necessary
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

	@override
	Widget build(BuildContext context) => SafeArea(
    maintainBottomViewPadding: true,
    minimum: const EdgeInsets.all(20),
		child: Scaffold(
			body: Center(
				child: Column(
					children: [
						const SizedBox(height: 100),
						CircleAvatar(
							backgroundColor: Colors.grey.shade800,
							backgroundImage: const NetworkImage(
								'https://catscanman.net/wp-content/uploads/2023/02/meme-buon-ngu-2.png'),
							radius: 50,
						),
						Text(
							user.email!.split('@')[0],
							style: const TextStyle(
								fontSize: 20,
								fontWeight: FontWeight.bold
							),
						),
						const SizedBox(height: 20),
						ElevatedButton(
							style: ElevatedButton.styleFrom(
              	minimumSize: const Size.fromHeight(50),
            	),
							onPressed: () => FirebaseAuth.instance.signOut(),
							child: const Text(
								'Sign out',
								style: TextStyle(fontSize: 20),
							)
						),
						const SizedBox(height: 20),
						ElevatedButton(
							style: ElevatedButton.styleFrom(
              	minimumSize: const Size.fromHeight(50),
            	),
							onPressed: _showDeleteConfirmationDialog,
							child: const Text(
								'Delete account',
								style: TextStyle(
									fontSize: 20,
									color: Colors.redAccent
								),
							)
						),
					],
				),
			)
		),
	);
}
