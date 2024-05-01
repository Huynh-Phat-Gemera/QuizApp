import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'utils.dart';

// ignore: camel_case_types
class register extends StatefulWidget {
  final Function() onCLickedSignIn;
  const register({Key? key, required this.onCLickedSignIn}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

// ignore: camel_case_types
class _registerState extends State<register> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
	final confirmPasswordController = TextEditingController();

  bool _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
		confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) =>
                email != null && !EmailValidator.validate(email)
                  ? 'Enter a valid email'
                  : null,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
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
									)
								)
							),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureText,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                ? 'Enter min 6 characters'
                : null,
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: confirmPasswordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Confirm password',
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
									)
								)
							),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscureText,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                ? 'Your password is incorrect'
                : null,
            ),
						const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.arrow_forward, size: 32),
              label: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: signUp,
            ),
            const SizedBox(height: 24),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.amber, fontSize: 20),
                text: 'Already have an account?  ',
                children: [
                	TextSpan(
                  	recognizer: TapGestureRecognizer()
                  	  ..onTap = widget.onCLickedSignIn,
                  	text: 'Sign In',
                  	style: TextStyle(
                  	  decoration: TextDecoration.underline,
                  	  color: Theme.of(context).colorScheme.secondary
										)
									)
              	]
							)
						)
          ],
        ),
      ),
    ),
  );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator())
		);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
