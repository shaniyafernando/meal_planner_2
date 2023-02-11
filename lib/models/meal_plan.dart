import 'package:cloud_firestore/cloud_firestore.dart';

class MealPlan{
  String? referenceId;
  DateTime date;
  int numberOfServings;
  List<String> recipeIds;
  List<String> guestIds;
  String uid;

  MealPlan(
      {this.referenceId, required this.date,
        required this.numberOfServings, required this.recipeIds, required this.guestIds,required this.uid});

  factory MealPlan.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return MealPlan(
        referenceId: snapshot.reference.id,
        date: data?['date'],
        numberOfServings: data?['numberOfServings'],
        recipeIds: data?['recipeIds'],
        guestIds: data?['guestIds'],
        uid: data?['uid']
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'date': date,
      'numberOfServings': numberOfServings,
      'recipeIds': recipeIds,
      'guestIds': guestIds,
      'uid': uid
    };
  }

}