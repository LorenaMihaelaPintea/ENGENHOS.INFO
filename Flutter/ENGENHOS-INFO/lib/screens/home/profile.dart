import 'package:engenhos_info/models/myuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:engenhos_info/services/auth.dart';
import 'package:engenhos_info/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailto/mailto.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/constants.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final AuthService _auth = AuthService();
  late String _newName;
  late String _newPhoneNumber;

  @override
  Widget build(BuildContext context) {

    MyUser user = Provider.of<MyUser>(context, listen: false);

    Future<void> _showNewNameDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update your name'),
            content: SingleChildScrollView(
              child: Column(
                children:  <Widget>[
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                    onChanged: (value) {
                      setState(() {
                        _newName = value;
                        // print(_newName);
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  await DatabaseService(uid: user.uid).updateUserName(_newName).then((_) => Navigator.of(context).pop());
                },
              ),
              TextButton(
                child: const Text('Exit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showNewPhoneNumberDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update your phone number'),
            content: SingleChildScrollView(
              child: Column(
                children:  <Widget>[
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Phone number'),
                    validator: (val) => val!.isEmpty ? 'Enter your phone number' : null,
                    onChanged: (value) {
                      setState(() {
                        _newPhoneNumber = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  await DatabaseService(uid: user.uid).updateUserPhoneNumber(_newPhoneNumber).then((_) => Navigator.of(context).pop());
                },
              ),
              TextButton(
                child: const Text('Exit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showNewPasswordDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update your password'),
            content: SingleChildScrollView(
              child: Column(
                children:  const <Widget>[
                  Text('If you confirm you are going to receive an email with the instructions!',
                  style: TextStyle(
                    letterSpacing: 0.5,
                  ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!).then((_) => Navigator.of(context).pop());
                },
              ),
              TextButton(
                child: const Text('Exit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder<MyUser?>(
      stream: DatabaseService(uid: user.uid).user,
      builder: (context, snapshot) {
        MyUser? userData = snapshot.data;
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            //color: Color(0xffFBD732)
            backgroundColor: Colors.black,
            leading: MaterialButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Image.asset(
                'assets/Logo-BG-70.png',
                scale: 1,
              ),
            ),
            leadingWidth: 100,
            actions: <Widget> [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    textColor: Colors.grey[400],
                    onPressed: () {
                      //redirect to form
                      Navigator.pushReplacementNamed(context, '/formdata');
                    },
                    child: const Text(
                      "Form",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    shape: const CircleBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                        )
                    ),
                  ),
                  MaterialButton(
                    textColor: Colors.grey[400],
                    onPressed: () {
                      //redirect to results
                      Navigator.pushReplacementNamed(context, '/results');
                    },
                    child: const Text(
                      "Results",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
                  ),
                  MaterialButton(
                    textColor: const Color(0xffFBD732),
                    onPressed: () {
                      //redirect to profile
                      Navigator.pushReplacementNamed(context, '/profile');
                    },
                    child: const Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    shape: const CircleBorder(side: BorderSide(color: Colors.transparent)),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding:  const EdgeInsets.only(left: 50, top: 100, right: 20, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('EMAIL',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text('${user.email}',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('PASSWORD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(width: 125,),
                                IconButton(
                                  onPressed: _showNewPasswordDialog,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.pencil,
                                    color: Color(0xffFBD732),
                                    size: 20,
                                  ),
                                ),
                              ]),
                          Text('**********',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('NAME',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(width: 175,),
                                IconButton(
                                  onPressed: _showNewNameDialog,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.pencil,
                                    color: Color(0xffFBD732),
                                    size: 20,
                                  ),
                                ),
                              ]),
                          // const SizedBox(height: 5,),
                          Text('${(userData?.name != null) ? userData?.name : ''}',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 0, right: 0, bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('PHONE NUMBER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(width: 75,),
                                IconButton(
                                  onPressed: _showNewPhoneNumberDialog,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.pencil,
                                    color: Color(0xffFBD732),
                                    size: 20,
                                  ),
                                ),
                              ]),
                          Text('${(userData?.phoneNumber != null) ? userData?.phoneNumber : ''}',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 70,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () async {
                        final mailtoLink = Mailto(
                          to: ['engenhosinfo@gmail.com'],
                        );

                        await launchUrl(Uri.parse(mailtoLink.toString()));
                      },
                      color: const Color(0xffFBD732),
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: const <Widget> [
                          Icon(
                            Icons.contact_page_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Contact us",
                            style: TextStyle(
                              color: Colors.black,
                              wordSpacing: 2,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 40,),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () async {
                        await _auth.signOut().then((_) => Navigator.pushReplacementNamed(context, '/wrapper'));
                      },
                      color: const Color(0xffFBD732),
                      focusColor: Colors.black,
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: const <Widget> [
                          Icon(
                            Icons.logout,
                            color: Colors.black,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.black,
                              wordSpacing: 2,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 40, right: 30, bottom: 0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () async => {
                      await FirebaseAuth.instance.currentUser?.delete().then((_) => Navigator.pushReplacementNamed(context, '/wrapper'))
                    },
                    color: const Color(0xffFBD732),
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: const <Widget> [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Delete account permanently",
                          style: TextStyle(
                            color: Colors.black,
                            wordSpacing: 2,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

    );
  }

}
