import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/navigationBar.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
			scaffoldMessengerKey: Utils.messengerKey,
			navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter'),
    );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
				return snapshot.connectionState == ConnectionState.waiting
					? const Center(child: CircularProgressIndicator())
					: snapshot.hasError
					? const Center(child: Text('Something went wrong!'))
					: snapshot.hasData
					? const navigationBar()
					: const auth();
      },
    ),
  );
}
