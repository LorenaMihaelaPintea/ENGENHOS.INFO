import 'package:engenhos_info/models/myuser.dart';
import 'package:engenhos_info/screens/home/home.dart';
import 'package:engenhos_info/screens/home/formdata.dart';
import 'package:engenhos_info/screens/home/profile.dart';
import 'package:engenhos_info/screens/home/results.dart';
import 'package:engenhos_info/screens/location.dart';
import 'package:engenhos_info/screens/wrapper.dart';
import 'package:engenhos_info/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
          initialRoute: '/location',
          routes: {
            // '/': (context) => Loading(); -> if I happen to have a loading page
            '/location': (context) => const Location(),
            '/wrapper': (context) => const Wrapper(),
            '/home': (context) => const Home(),
            '/formdata': (context) => const FormData(),
            '/results': (context) => const Results(),
            '/profile': (context) => const Profile(),
          },
      ),
    );
  }
}
