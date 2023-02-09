import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/guest.dart';
import '../models/ingredient.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';
import 'bookmark_service.dart';

class MealPlanService{

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('mealPlan');

  final BookmarkController bookmarkService = BookmarkController();

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addMealPlan(MealPlan mealPlan) {
    return collection.add(mealPlan.toJson());
  }

  void updateMealPlan(MealPlan mealPlan) async {
    await collection.doc(mealPlan.referenceId).update(mealPlan.toJson());
  }

  void deleteMealPlan(MealPlan mealPlan) async {
    await collection.doc(mealPlan.referenceId).delete();
  }

  List getRecipesByGuestPreferences(List<Guest>? guests){
    List<Recipe> recipes = [];

    Stream<QuerySnapshot> savedRecipes = FirebaseFirestore.instance.collection('recipe').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
    savedRecipes.forEach((element) { recipes.addAll(element.docs.map((e) => Recipe.fromSnapshot(e))); });

    if(guests != null){
      List<Recipe> filteredRecipes = [];
      Set healthRequirementsOfAllGuests = {};

      for (var element in guests) { healthRequirementsOfAllGuests.addAll(element.healthLabels); }

      for (var element in recipes) {
        Set healthReqOfRecipe = {};
        healthReqOfRecipe.addAll(element.healthLabels);
        Set healthReqInCommon = healthRequirementsOfAllGuests.intersection(healthReqOfRecipe);

        if(healthReqInCommon.isEmpty){ break;}

        filteredRecipes.add(element);
      }

      return filteredRecipes;
    }

    return recipes;
  }


  List<MealPlan> getMealPlanByDateRange(DateTimeRange range){
    List<MealPlan> mealPlanList = [];

    Stream<QuerySnapshot> mealPlans = getStream();
    mealPlans.forEach((element) {
      mealPlanList.addAll(element.docs.map((e) => MealPlan.fromSnapshot(e)));
    });

    return mealPlanList.where((element) =>
            element.date!.isBefore(range.end) &&
                element.date!.isAfter(range.start)).toList();
  }

  Map generateShoppingList(List<MealPlan> mealPlans ){
    Map shoppingList = {};
    Set<Ingredient> ingredients = {};
    Set<String?> foodsInIngredients = {};

    for (MealPlan mealPlan in mealPlans) {
      for (Recipe element in mealPlan.recipeIds!) {
        for (Ingredient i in element.ingredients) {
          if(foodsInIngredients.contains(i.foodId)){
            for (Ingredient ingredient in ingredients) {
              if(ingredient.foodId == i.foodId){
                double ratio = mealPlan.numberOfServings! / element.numberOfServings!;
                Ingredient newIngredient = Ingredient(foodCategory: ingredient.foodCategory,
                    quantity: ingredient.quantity! * ratio, weight: ingredient.weight! * ratio,
                    measure: ingredient.measure, food: ingredient.food, foodId: ingredient.foodId);
                ingredients.add(newIngredient);
                ingredients.remove(ingredient);
              }
            }
          }
          ingredients.add(i);
          foodsInIngredients.add(i.foodId);}}}

    for(Ingredient j in ingredients){
        String amount = j.weight!.toStringAsFixed(0);
        String food = j.food!;
        shoppingList[j.foodCategory] = "$amount g  $food";}

    return shoppingList;
  }

}