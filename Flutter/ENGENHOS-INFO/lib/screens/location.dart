import 'package:engenhos_info/screens/wrapper.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as location;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late bool? _locationPermission = false;
  late bool? _isEnabled = false;

  @override
  void initState() {
    super.initState();
    //add the future function here
    _checkLoc();
  }

  Future<void> _checkLoc() async {
    Geolocator.checkPermission().then((value) {
      if(value == LocationPermission.denied) {
        Geolocator.requestPermission().then((val) {
          if (val == LocationPermission.denied || val == LocationPermission.deniedForever || val == LocationPermission.unableToDetermine) {
            setState(() {
              _locationPermission = false;
              _isEnabled = false;
            });
          } else {
            Geolocator.isLocationServiceEnabled().then((v) {
              if(v) {
                setState(() {
                  _locationPermission = true;
                  _isEnabled = true;
                });
              } else {
                setState(() {
                  _locationPermission = true;
                  _isEnabled = false;
                });
              }
            });
          }
        });
      } else if (value == LocationPermission.deniedForever || value == LocationPermission.unableToDetermine) {
        setState(() {
          _locationPermission = false;
          _isEnabled = false;
        });
      } else {
        Geolocator.isLocationServiceEnabled().then((value) {
          if(value) {
            setState(() {
              _locationPermission = true;
              _isEnabled = true;
            });
          } else {
            setState(() {
              _locationPermission = true;
              _isEnabled = false;
            });
          }
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    /*
    print(_locationPermission);
    print(_isEnabled);
    */
    if(_locationPermission == null || _isEnabled == null) {
      _checkLoc().then((_) => {});
    }

    if(_locationPermission != false) {
      if(_isEnabled != false) {
        return const Wrapper();
      } else {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: AlertDialog(
                backgroundColor: Colors.black,
                title: const Text("Use location service?"),
                titleTextStyle: const TextStyle(
                  color: Color(0xffFBD732),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,),
                content: const Text(
                    "Let us help determine location. This means sending anonymous location data to us. In order to use our app you must enable Location from Settings!"),
                contentTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      location.Location.instance.requestService().then((value) {
                        if(!value) {
                          Navigator.pushReplacementNamed(context, '/location');
                        } else {
                          return const Wrapper();/*Navigator.pushReplacementNamed(context, '/wrapper');*/
                        }
                      });
                    },
                    child: const Text('DISAGREE',
                      style: TextStyle(
                        color: Color(0xffFBD732),
                        fontSize: 14.0,
                      ),),
                  ),
                  TextButton(
                    onPressed: () {
                      location.Location.instance.requestService().then((value) {
                        if(value) {
                          return const Wrapper();/*Navigator.pushReplacementNamed(context, '/wrapper');*/
                        } else {
                          Navigator.pushReplacementNamed(context, 'location');
                        }
                      });
                    },
                    child: const Text('AGREE',
                      style: TextStyle(
                        color: Color(0xffFBD732),
                        fontSize: 14.0,
                      ),),
                  ),
                ],

              ),
            ),
          ),
        );
      }
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: AlertDialog(
          backgroundColor: Colors.black,
          title: const Text("ENABLE Location!"),
          titleTextStyle: const TextStyle(
            color: Color(0xffFBD732),
            fontSize: 18.0,
            fontWeight: FontWeight.w500,),
          content: const Text("In order to use our app you must enable the location from Settings!"),
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: const Text('Close App!',
                style: TextStyle(
                  color: Color(0xffFBD732),
                  fontSize: 14.0,),
              ),
            ),
          ],
        ),
      );
    }

  }
}


