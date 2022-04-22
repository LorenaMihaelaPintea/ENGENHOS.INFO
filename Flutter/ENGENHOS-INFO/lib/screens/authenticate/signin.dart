import 'package:engenhos_info/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  //text field states
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/Logo-BG.png',
                width: 300,
                height: 300,
                alignment: Alignment.center,
              ),
              Form(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 60,),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val!.isEmpty ? 'Enter your email' : null,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    const SizedBox(height: 11,),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      validator: (val) => val!.length < 8 ? 'Enter a password 8+ characters long' : null,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    //add buttons and text after login form
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.toggleView();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffFBD732),
                            onPrimary: Colors.black,
                          ),
                          icon: const Icon(Icons.how_to_reg_outlined),
                          label: const Text('Register', style: TextStyle(color: Colors.black),),
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? true) {
                              dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                              if(result == null) {
                                setState(() {
                                  error = 'Could not sign in with those credentials';
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffFBD732),
                            onPrimary: Colors.black,
                          ),
                          icon: const Icon(Icons.assignment_return_outlined),
                          label: const Text('Log In', style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _auth.signInWithGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffFBD732),
                        onPrimary: Colors.black,
                        minimumSize: const Size(220, 37),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.google),
                      label: const Text('Sign up with Google', style: TextStyle(color: Colors.black),),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _auth.signInWithFacebook();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffFBD732),
                        onPrimary: Colors.black,
                        minimumSize: const Size(220, 37),
                      ),
                      icon: const FaIcon(FontAwesomeIcons.facebook),
                      label: const Text('Sign Up with Facebook', style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
