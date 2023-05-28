import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir/login/login_controller.dart';
import 'package:tugas_akhir/model/my_response.dart';
import 'package:tugas_akhir/pages/dashbord.dart';
import '../common/theme_helper.dart';
import 'package:http/http.dart' as http;

import 'forgot_password.dart';
import 'profile_page.dart';
import 'register_page.dart';
import '../widgets/header_widget.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  LoginController _controller = LoginController();

  @override
  // void initState() async {
  //   super.initState();
  //
  //   final prefs = await SharedPreferences.getInstance();
  //   String? token = prefs.getString('token');
  //   if (token != null) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => Dashbord()));
  //   }
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Signin into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          child: Column(
                        children: [
                          Container(
                            child: TextField(
                              controller: _controller.emailController,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Email', 'Enter your Email'),
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 30.0),
                          Container(
                            child: TextField(
                              controller: _controller.passwordController,
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  'Password', 'Enter your password'),
                            ),
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          (_controller.isLoading)
                              ? Container(
                                  height: 32,
                                  width: 32,
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                    strokeWidth: 3,
                                  ))
                              : Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text(
                                        'Log in'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () {
                                      _login();

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ProfilePage()));
                                    },
                                  ),
                                ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            //child: Text('Don\'t have an account? Create'),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(text: "Don\'t have an account? "),
                              TextSpan(
                                text: 'Create',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationPage()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ])),
                          ),
                        ],
                      )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _controller.isLoading = true;
    });

    MyResponse response = await _controller.login();

    setState(() {
      _controller.isLoading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.message)));
    if (response.code == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {}
  }
}
