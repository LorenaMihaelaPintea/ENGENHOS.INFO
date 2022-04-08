import 'package:engenhos_info/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //color: Color(0xffFBD732)
        backgroundColor: Colors.black,
        // *TODO: resize somewhere the logo so it can look better
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
                textColor: Colors.white,
                onPressed: () {
                  //redirect to newsfeed
                  Navigator.pushReplacementNamed(context, '/newsfeed');
                },
                child: const Text(
                  "News Feed",
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
                textColor: Colors.white,
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
                textColor: Colors.white,
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
      body: const Text('Welcome to ENGENHOS.INFO!'),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        elevation: 10.0,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: () => {/*TODO: ask camera permission + open native camera app, after send picture to Firebase*/},
              color: Colors.black,
              focusColor: Colors.grey[400],
              padding: const EdgeInsets.all(17.0),
              child: Row(
                children: <Widget> [
                  const Icon(
                    Icons.camera,
                    color: Color(0xffFBD732),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Camera",
                    style: TextStyle(
                      color: Colors.grey[400],
                      wordSpacing: 2,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              onPressed: () async {
                _showLogoutDialog();
              },
              color: Colors.black,
              focusColor: Colors.grey[400],
              padding: const EdgeInsets.all(17.0),
              child: Row(
                children: <Widget> [
                  const Icon(
                    Icons.logout,
                    color: Color(0xffFBD732),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.grey[400],
                      wordSpacing: 2,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('LogOut'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () async {
                await _auth.signOut().then((_) => Navigator.pushReplacementNamed(context, '/wrapper'));
              },
            ),
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
