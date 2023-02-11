import 'package:cloud_firestore/cloud_firestore.dart';

class Guest{
  String? referenceId;
  String name;
  List<dynamic> healthLabels;
  String userId;

  Guest({this.referenceId,required this.name, required this.healthLabels, required this.userId});

  factory Guest.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Guest(
      referenceId: snapshot.reference.id,
      name: data?['name'],
      healthLabels: data?['healthLabels'],
      userId: data?['userId'],
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "name": name,
      "healthLabels": healthLabels,
      "userId": userId
    };
  }


}
