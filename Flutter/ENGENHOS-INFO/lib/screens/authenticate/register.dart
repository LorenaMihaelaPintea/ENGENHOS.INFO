import 'package:engenhos_info/models/myuser.dart';
import 'package:engenhos_info/shared/constants.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../services/database.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _error = '';
  //text field states
  String _email = '';
  String _password = '';
  String? _name;
  String? _phoneNumber;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus(); //closes the keyboard

    if(isValid != null) {
      _formKey.currentState?.save();
      dynamic result = await _auth.registrationWithEmailAndPassword(_email, _password);

      if(result == null) {
        setState(() {
          _error = 'Please supply a valid email';
        });
      } else {
        await DatabaseService(uid: result.uid).updateUserData(_name!, _phoneNumber!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //color: Color(0xffFBD732)
              Image.asset(
                'assets/Logo-BG.png',
                width: 300,
                height: 300,
                alignment: Alignment.center,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 60,),
                    TextFormField(
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (email) {
                        return (email!.isEmpty || email.length < 12) ? 'Email must be at least 12 characters long' : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 11,),
                    TextFormField(
                      key: const ValueKey('password'),
                      decoration: textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) {
                        return val!.length < 8 ? 'Password must be at least 8 characters long' : null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _password = value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 11,),
                    TextFormField(
                      key: const ValueKey('name'),
                      decoration: textInputDecoration.copyWith(hintText: 'Full Name'),
                      validator: (val) {
                        return val!.isEmpty ? 'Enter your name' : null;
                      },
                      // onChanged: (value) {
                      //   setState(() {
                      //     name = value.trim();
                      //   });
                      // },
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                    const SizedBox(height: 11,),
                    TextFormField(
                      key: const ValueKey('phoneNumber'),
                      decoration: textInputDecoration.copyWith(hintText: 'Phone Number'),
                      validator: (val) {
                        if (val!.length < 9 || val.length > 9) {
                          return 'Enter your phone number';
                        } else {
                          return null;
                        }
                      },
                      // onChanged: (value) {
                      //   setState(() {
                      //     phoneNumber = value.trim();
                      //   });
                      // },
                      onSaved: (value) {
                        _phoneNumber = value;
                      },
                    ),
                    const SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          onPressed: _trySubmit,
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffFBD732),
                            onPrimary: Colors.black,
                          ),
                          icon: const Icon(Icons.how_to_reg_outlined),
                          label: const Text('Register', style: TextStyle(color: Colors.black),),
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.toggleView();
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
                    // SizedBox(height: 15,),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Color(0xffFBD732),
                    //     onPrimary: Colors.black,
                    //     minimumSize: Size(220, 37),
                    //   ),
                    //   icon: FaIcon(FontAwesomeIcons.google),
                    //   label: Text('Sign up with Google', style: TextStyle(color: Colors.black),),
                    // ),
                    // SizedBox(height: 5,),
                    // ElevatedButton.icon(
                    //   onPressed: () {
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Color(0xffFBD732),
                    //     onPrimary: Colors.black,
                    //     minimumSize: Size(220, 37),
                    //   ),
                    //   icon: FaIcon(FontAwesomeIcons.facebook),
                    //   label: Text('Sign Up with Facebook', style: TextStyle(color: Colors.black),),
                    // ),
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
