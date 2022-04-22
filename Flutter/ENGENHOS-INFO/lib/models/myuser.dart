// import 'package:location/location.dart';

class MyUser {
  final String uid;
  //final LocationData location;
  late String? email;
  late String? name;
  late String? phoneNumber;

  MyUser({ required this.uid, this.email, this.name, this.phoneNumber, /* required this.location */});
}