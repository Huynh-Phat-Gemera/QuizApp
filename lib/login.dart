import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/utils.dart';
import 'main.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
	final VoidCallback onCLickedSignUp;
  const login({Key? key, required this.onCLickedSignUp}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Password',
              // helperText:"Password must contain special character",
              suffixIcon: GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(_obscureText
                  ? Icons.visibility_off
                  : Icons.visibility
								),
              )
						),
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureText,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            icon: const Icon(Icons.lock_open, size: 32),
            label: const Text(
              'Sign In',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signIn,
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.amber, fontSize: 20),
              text: 'No account?  ',
              children: [TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onCLickedSignUp,
                text: 'Sign Up',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary
								)
							)]
						)
					)
        ],
      ),
    ),
  );

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }

			Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
