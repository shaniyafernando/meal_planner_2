import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_planner/models/recipe.dart';

import 'guest.dart';

class MealPlan{
  String? referenceId;
  DateTime date;
  double numberOfServings;
  List<Recipe> recipeIds;
  List<Guest> guestIds;
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
        recipeIds: _convertRecipes(data?['recipeIds']),
        guestIds: _convertGuests(data?['guestIds']),
        uid: data?['uid']
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'date': date,
      'numberOfServings': numberOfServings,
      'recipeIds': _recipeList(recipeIds),
      'guestIds': _guestList(guestIds),
      'uid': uid
    };
  }

}

List<Recipe> _convertRecipes(List<dynamic> recipeMap) {
  final recipes = <Recipe>[];

  for (var recipe in recipeMap) {
    recipes.add(Recipe.fromFireStore(recipe,null));
  }
  return recipes;
}

List<Map<String, dynamic>>? _recipeList(List<Recipe>? recipes) {
  if (recipes == null) {
    return null;
  }
  final recipeMap = <Map<String, dynamic>>[];
  for (var recipe in recipes) {
    recipeMap.add(recipe.toFireStore());
  }
  return recipeMap;
}

List<Guest> _convertGuests(List<dynamic> guestMap) {
  final guests = <Guest>[];

  for (var guest in guestMap) {
    guests.add(Guest.fromFireStore(guest,null));
  }
  return guests;
}

List<Map<String, dynamic>>? _guestList(List<Guest>? guests) {
  if (guests == null) {
    return null;
  }
  final guestMap = <Map<String, dynamic>>[];
  for (var guest in guests) {
    guestMap.add(guest.toFireStore());
  }
  return guestMap;
}