import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'utils.dart';

// ignore: camel_case_types
class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

// ignore: camel_case_types
class _profileState extends State<profile> {
  final user = FirebaseAuth.instance.currentUser!;
  final storage = FirebaseStorage.instance.ref();
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  File? _image;
  UploadTask? _uploadTask;
  bool obscureText = true;

  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
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

  Future<void> _pickImage() async {
    String username = user.email!.split('@')[0];
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final img = File(pickedImage.path);
      final pathStorage = '$username/avatar/${pickedImage.name}';
      final ref = storage.child(pathStorage);
      ref.putFile(File(pickedImage.path));
      _uploadTask = storage.child(pathStorage).putFile(img);
      final snapshot = await _uploadTask!.whenComplete(() {});
      final urlImg = await snapshot.ref.getDownloadURL();
      print('URL IMAGE: ' + urlImg);

      setState(() {
        _image = img;
      });
    } else {
      return;
    }
  }

  Future<void> _showChangePasswordDialog() async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change password'),
          content: StatefulBuilder(
            builder: (context, setState) => SingleChildScrollView(
                child: ListBody(children: <Widget>[
              TextFormField(
                controller: oldPasswordController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'Old password',
                    suffixIcon: GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            obscureText = false;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            obscureText = true;
                          });
                        },
                        child: Icon(obscureText
                            ? Icons.visibility_off
                            : Icons.visibility))),
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'The password must have at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'New password',
                    suffixIcon: GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            obscureText = false;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            obscureText = true;
                          });
                        },
                        child: Icon(obscureText
                            ? Icons.visibility_off
                            : Icons.visibility))),
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null &&
                        value.length < 6 &&
                        value == oldPasswordController.text
                    ? 'The password must have at least 6 characters and must be different from the old password'
                    : null,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    labelText: 'Confirm password',
                    suffixIcon: GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            obscureText = false;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            obscureText = true;
                          });
                        },
                        child: Icon(obscureText
                            ? Icons.visibility_off
                            : Icons.visibility))),
                keyboardType: TextInputType.visiblePassword,
                obscureText: obscureText,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value == passwordController.text
                    ? null
                    : 'Your password is incorrect',
              ),
            ])),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  oldPasswordController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                });
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: user.email!,
                    password: oldPasswordController.text.trim(),
                  );
                  await user.updatePassword(passwordController.text);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } on FirebaseAuthException {
                  Utils.showSnackBar("Error changing password");
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
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
                backgroundImage: (_image != null) ? FileImage(_image!) : null,
                radius: 50,
                child: IconButton(
                  iconSize: 70,
                  icon: const Icon(null),
                  onPressed: _pickImage,
                ),
              ),
              Text(
                user.email!.split('@')[0],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _showChangePasswordDialog,
                  child: const Text(
                    'Change password',
                    style: TextStyle(fontSize: 20),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: const Text(
                    'Sign out',
                    style: TextStyle(fontSize: 20),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _showDeleteConfirmationDialog,
                  child: const Text(
                    'Delete account',
                    style: TextStyle(fontSize: 20, color: Colors.redAccent),
                  )),
            ],
          ),
        )),
      );
}
