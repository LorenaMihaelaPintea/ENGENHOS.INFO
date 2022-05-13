import 'package:engenhos_info/screens/home/slider.dart';
import 'package:engenhos_info/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../models/myuser.dart';

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
      body: const SliderScreen(),
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
              onPressed: _takepicture,
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

  Future<void> _takepicture() async {
    final PickedFile? img = await ImagePicker.platform.pickImage(source: ImageSource.camera);
    MyUser user = Provider.of<MyUser>(context, listen: false);
    LocationData loc = await Location().getLocation();
    var url = Uri.http('10.0.2.2:5000', '/image');

    http.MultipartRequest request = http.MultipartRequest('POST', url);

    request.fields['userID'] = user.uid;
    request.fields['latitude'] = '${loc.latitude}';
    request.fields['longitude'] = '${loc.longitude}';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        img!.path,
        contentType: MediaType('file', 'jpg'),
      ),
    );

    request.send().then((response) {
      if (response.statusCode == 200) print("Uploaded!");
    });
  }
}
