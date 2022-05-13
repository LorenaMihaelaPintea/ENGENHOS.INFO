import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:core';

import 'package:engenhos_info/models/myuser.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  DatabaseService.withoutUID() : uid = "";

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String phoneNumber) async {
    return await usersCollection.doc(uid).set({
      'fullName': name,
      'phoneNumber': phoneNumber,
    });
  }

  Future updateUserName(String name) async {
    return await usersCollection.doc(uid).update({
      'fullName': name,
    });
  }

  Future updateUserPhoneNumber(String phoneNumber) async {
    return await usersCollection.doc(uid).update({
      'phoneNumber': phoneNumber,
    });
  }

  MyUser? _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return MyUser(
        uid: uid,
        name: snapshot.get('fullName'),
        phoneNumber: snapshot.get('phoneNumber')
    );
  }

  Stream<MyUser?> get user {
    return usersCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

}

