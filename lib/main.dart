import 'package:flutter/material.dart';
import 'package:my_gallery/modules/gallery_screen.dart';
import 'package:my_gallery/modules/login_screen.dart';
import 'package:my_gallery/shared/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetworkServices.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
          future: Future.delayed(
              Duration.zero), // Replace this with actual login status check
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (isLoggedIn) {
              return const GalleryScreen();
            } else {
              return LoginScreen();
            }
          },
        ));
  }
}
