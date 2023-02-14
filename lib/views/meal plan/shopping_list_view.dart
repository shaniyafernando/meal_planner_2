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

    // Map<String,List<Ingredient>> shoppingListWithFoodType = {};
    //
    // for (var ingredient in ingredients) {
    //   shoppingListWithFoodType[ingredient.foodCategory]= [];
    // }
    //
    // for(Ingredient ingredient in ingredients){
    //   if(shoppingListWithFoodType[ingredient.foodCategory] != []){
    //     shoppingListWithFoodType[ingredient.foodCategory]?.add(ingredient);
    //   }
    //
    // }
    //
    // print(shoppingListWithFoodType);
    Map<String, List<String>> groupedShoppingList = {
      ingredients[0].foodCategory: ['${ingredients[0].weight}g ${ingredients[0].food}'],
      ingredients[1].foodCategory: ['${ingredients[1].weight}g ${ingredients[1].food}'],
      ingredients[2].foodCategory: ['${ingredients[2].weight}g ${ingredients[2].food}'],
      ingredients[3].foodCategory: ['${ingredients[3].weight}g ${ingredients[3].food}'],
      ingredients[4].foodCategory: ['${ingredients[4].weight}g ${ingredients[4].food}'],
      ingredients[5].foodCategory: ['${ingredients[5].weight}g ${ingredients[5].food}','${ingredients[6].weight}g ${ingredients[6].food}'],
    };



    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize'),
          actions: [
            IconButton(
                onPressed: () {
                  printDoc("DOWNLOAD", 'shopping-list', groupedShoppingList, null, null);
                },
                icon: const Icon(Icons.download_for_offline)),
            IconButton(
                onPressed: () {
                  printDoc("SHARE", 'shopping-list', groupedShoppingList, null, null);
                },
                icon: const Icon(Icons.share)),
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
            return Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Text(
                groupedShoppingList.values.toList()[index.section][index.index],
                style: const TextStyle(color: Colors.grey, fontSize: 18),
              ),
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
