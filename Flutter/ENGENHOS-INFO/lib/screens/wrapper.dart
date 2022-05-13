import 'package:engenhos_info/screens/authenticate/authenticate.dart';
import 'package:engenhos_info/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/myuser.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser?>(context);

    //return either Home or Authenticate widget
    if(user == null) {
      return const Authenticate();
    } else {
      return const Home();
    }
  }
}
