import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

// ignore: camel_case_types
class _profileState extends State<profile> {
  final double profileHeight = 144;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 150,
          child: buildProfileImage(),
        ),
        Positioned(
            top: 250,
            child: Text(
              user.email!.split('@')[0],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
      ],
    ));
  }

  Widget buildProfileImage() => Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            backgroundImage: const NetworkImage(
                'https://catscanman.net/wp-content/uploads/2023/02/meme-buon-ngu-2.png'),
            minRadius: 50,
          ),
          const SizedBox(height: 10),
        ],
      );
}
