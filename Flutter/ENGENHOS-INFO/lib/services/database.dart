import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String phoneNumber) async {
    return await usersCollection.doc(uid).set({
      'fullName': name,
      'phoneNumber': phoneNumber,
    });
  }

  Future updateUserName(String name) async {
    return await usersCollection.doc(uid).set({
      'fullName': name,
    });
  }

  Future updateUserPhoneNumber(String phoneNumber) async {
    return await usersCollection.doc(uid).set({
      'phoneNumber': phoneNumber,
    });
  }

  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }
}