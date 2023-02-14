import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:meal_planner/models/ingredient.dart';
import 'package:meal_planner/models/recipe.dart';
import '../../controllers/share.dart';
import '../../fragments/drawer.dart';
import '../../models/meal_plan.dart';

class ShoppingCartItem{
  String item;
  double weight;

  ShoppingCartItem(this.item, this.weight);
}


class ShoppingListView extends StatelessWidget {
  final List<Ingredient> ingredients ;
  const ShoppingListView({Key? key, required this.ingredients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map<String, List<String>> map = {
    //   'Vegetable': ["100g scallions"],
    //   'Dairy': ["50g butter"],
    //   "Meat/Fish": ["400g fish filet"],
    // };

    // Stream<QuerySnapshot<MealPlan>> mealPlanSnapShots = FirebaseFirestore
    //     .instance
    //     .collection('mealPlan')
    //     .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .where('date', isLessThanOrEqualTo: dateTimeRange.end)
    //     .where('date', isGreaterThanOrEqualTo: dateTimeRange.start)
    //     .withConverter(
    //         fromFirestore: MealPlan.fromFireStore,
    //         toFirestore: (MealPlan mealPlan, _) => mealPlan.toFireStore())
    //     .snapshots();
    //
    // Set<String> recipeIdSet = {};
    //
    // mealPlanSnapShots.forEach((element) {
    //    for (var element in element.docs) {
    //      recipeIdSet.addAll( element.data().recipeIds);
    //    }});

    // Stream<QuerySnapshot<Recipe>> recipeSnapShots = FirebaseFirestore
    //     .instance
    //     .collection('recipe')
    //     .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     .where('Document ID', arrayContainsAny: recipeIdSet.toList())
    //     .withConverter(
    //     fromFirestore: Recipe.fromFireStore,
    //     toFirestore: (Recipe recipe, _) => recipe.toFireStore())
    //     .snapshots();
    //
    //
    //
    // recipeSnapShots.forEach((element) {
    //   for (var element in element.docs) {
    //     ingredients.addAll( element.data().ingredients);
    //   }});

    Map<String,Map<String,double>> shoppingList = {};

    for (var ingredient in ingredients) {
      bool categoryExists = shoppingList.containsKey(ingredient.foodCategory);
      bool foodExists = shoppingList[ingredient.foodCategory]!.containsKey(ingredient.food);

      if(categoryExists){
        if(foodExists){
          shoppingList[ingredient.foodCategory!]!.update(ingredient.food!, (value) => value + ingredient.weight!);
        }else{
          shoppingList[ingredient.foodCategory!]![ingredient.food!] = ingredient.weight!;
        }
      }else{
        shoppingList[ingredient.foodCategory!]![ingredient.food!] = ingredient.weight!;
      }
    }

    Map<String, List<String>> groupedShoppingList = {};

    for (String foodCategory in shoppingList.keys) {
      Map<String, double> item = shoppingList[foodCategory]!;
      List<String> ingredients = [];

      item.forEach((key, value) {
        String ingredient = '$value g  $key';
        ingredients.add(ingredient);
      });

      groupedShoppingList[foodCategory] = ingredients;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  printDoc("SHARE", 'shopping-list', groupedShoppingList, null, null);
                },
                icon: const Icon(Icons.download_for_offline)),
          ],
        ),
        backgroundColor: Colors.lime[50],
        drawer: const CustomDrawer(),
        body: GroupListView(
          sectionsCount: groupedShoppingList.keys.toList().length,
          countOfItemInSection: (int section) {
            return groupedShoppingList.values.toList()[section].length;
          },
          itemBuilder: (BuildContext context, IndexPath index) {
            return Text(
              groupedShoppingList.values.toList()[index.section][index.index],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            );
          },
          groupHeaderBuilder: (BuildContext context, int section) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Text(
                groupedShoppingList.keys.toList()[section],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          sectionSeparatorBuilder: (context, section) => const SizedBox(height: 10),
        ),
    );
  }
}
