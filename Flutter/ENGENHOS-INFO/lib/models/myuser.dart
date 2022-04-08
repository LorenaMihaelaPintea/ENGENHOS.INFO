// *TODO: import location when it's time

class MyUser {
  final String uid;
  // final LocationData location;
  String email;
  String? name;
  String? phoneNumber;

  MyUser({required this.uid, required this.email, this.name, this.phoneNumber,  /*this.location*/});
}