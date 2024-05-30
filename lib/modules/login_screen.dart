import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_gallery/modules/gallery_screen.dart';
import 'package:my_gallery/shared/services.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var widht = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Container(
                width: widht * 0.5,
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.15,
                child: const Text(
                  'My Gellary',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      height: 1,
                      color: Color(0xff4A4A4A)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    height: height * 0.45,
                    padding: const EdgeInsets.all(20.0),
                    margin: EdgeInsets.symmetric(horizontal: widht * 0.1),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0,
                              3), // Change the offset to adjust the position of the inner shadow
                        ),
                      ],
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                            child: Text(
                              'LOG IN',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff4A4A4A)),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          SizedBox(
                            // width: 300,
                            height: 44,
                            child: TextFormField(
                              controller: userNameController,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                labelText: 'User Name',
                                labelStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black38),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          SizedBox(
                            // width: 300,
                            height: 44,
                            child: TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                    fontSize: 15, color: Colors.black38),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 46,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await submit(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff7BB3FF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: const Text('Submit'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  submit(context) {
    final username = userNameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Show an error message if the username or password is empty
      return;
    }

    NetworkServices().login(username, password).then((user) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => GalleryScreen(
                  user: user,
                )),
      );
    }).catchError((error) {
      // Handle the login error
    });
  }
}
