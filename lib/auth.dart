import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class auth extends StatefulWidget {
  const auth({Key? key}) : super(key: key);

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
	bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
		? login(onCLickedSignUp: toggle)
		: register(onCLickedSignIn: toggle);
	
	void toggle() => setState(() => isLogin = !isLogin);
}