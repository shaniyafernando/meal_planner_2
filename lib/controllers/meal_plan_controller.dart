import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/guest.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import 'bookmark_controller.dart';

class MealPlanController{

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('mealPlan');

  final BookmarkController bookmarkController = BookmarkController();

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addMealPlan(MealPlan mealPlan) {
    return collection.add(mealPlan.toFireStore());
  }

  void updateMealPlan(MealPlan mealPlan) async {
    await collection.doc(mealPlan.referenceId).update(mealPlan.toFireStore());
  }

  void deleteMealPlan(MealPlan mealPlan) async {
    await collection.doc(mealPlan.referenceId).delete();
  }


  List<MealPlan> getMealPlanByDateRange(DateTimeRange range){
    List<MealPlan> mealPlanList = [];

    Stream<QuerySnapshot> mealPlans = getStream();
    mealPlans.forEach((element) {
      // mealPlanList.addAll(element.docs.map((e) => MealPlan.fromFireStore(e)));
    });

    return mealPlanList.where((element) =>
            element.date.isBefore(range.end) &&
                element.date.isAfter(range.start)).toList();
  }
}