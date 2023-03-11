import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_ranger/date_ranger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/share_controller.dart';
import 'package:meal_planner/fragments/button.dart';
import 'package:meal_planner/utils.dart';
import 'package:meal_planner/views/meal%20plan/add_meal_plan_view.dart';
import 'package:meal_planner/views/meal%20plan/shopping_list_view.dart';
import '../../controllers/meal_plan_controller.dart';
import '../../fragments/drawer.dart';
import '../../models/ingredient.dart';
import '../../models/meal_plan.dart';

class PlannerMobileView extends StatefulWidget {
  const PlannerMobileView({Key? key}) : super(key: key);

  @override
  State<PlannerMobileView> createState() => _PlannerMobileViewState();
}

class _PlannerMobileViewState extends State<PlannerMobileView> {
  DateTimeRange initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 2)),
      end: DateTime.now().add(const Duration(days: 5)));
  List<Ingredient> ingredients = [];
  List<MealPlan> mealPlans = [];

  @override
  Widget build(BuildContext context) {
    var mealPlanSnapShots = FirebaseFirestore.instance
        .collection('mealPlan')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: MealPlan.fromFireStore,
            toFirestore: (MealPlan mealPlan, _) => mealPlan.toFireStore())
        .snapshots();

    //     .toList().then((value) {
    //       for (var element in value) {
    //         for (var element in element.docs) {
    //           mealPlans.add(element.data());
    //         }}});
    // print(mealPlans);

    // var screenWidth = MediaQuery.of(context).size.width;
    // int crossAxisCount = 1;
    // if (screenWidth < 500) {
    //   crossAxisCount = 1;
    // } else if (screenWidth < 900) {
    //   crossAxisCount = 2;
    // } else {
    //   crossAxisCount = 3;
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: const Text("foodnertize"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Map<String,List<String>> mealPlans = {
                  '23-02-2023':['Number of servings: 3','guests: Shaniya Fernando','recipes: Homemade fish fingers']
                };
                ShareController().printDoc("DOWNLOAD", "meal-plan", mealPlans, null, null);
              },
              icon: const Icon(Icons.download_for_offline)),
          IconButton(
              onPressed: () {
                Map<String,List<String>> mealPlans = {
                  '23-02-2023':['Number of servings: 3','guests: Shaniya Fernando','recipes: Homemade fish fingers']
                };
                ShareController().printDoc("SHARE", "meal-plan", mealPlans, null, null);
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      backgroundColor: Colors.lime[50],
      drawer: const CustomDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Filter Meal Plans'),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: 300.0,
                child: DateRanger(
                  borderColors: Colors.orange[800],
                  errorColor: Colors.lime[800],
                  activeItemBackground: Colors.orange[900],
                  rangeBackground: Colors.orange[600],
                  backgroundColor: Colors.white,
                  initialRange: initialDateRange,
                  onRangeChanged: (range) {
                    setState(() {
                      initialDateRange = range;
                    });
                  },
                ),
              ),
              StreamBuilder<QuerySnapshot<MealPlan>>(
                  stream: mealPlanSnapShots,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<MealPlan>> data =
                          snapshot.data!.docs;

                      for (var element in data) {
                        double requestedServings =
                            element.data().numberOfServings;
                        element.data().recipeIds.forEach((element) {
                          for (var ingredient in element.ingredients) {
                            double ratio =
                                requestedServings / element.numberOfServings!;
                            double adjustedWeight = ingredient.weight! * ratio;
                            ingredients.add(Ingredient(
                                foodCategory: ingredient.foodCategory,
                                quantity: ingredient.quantity,
                                weight: adjustedWeight,
                                measure: ingredient.measure,
                                food: ingredient.food,
                                foodId: ingredient.foodId));
                          }
                        });
                      }

                      return ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            String getUpperCase(int i) {
                              if (i == 1 || i == 21 || i == 31) {
                                return 'st';
                              } else if (i == 2 || i == 22) {
                                return 'nd';
                              } else if (i == 3 || i == 23) {
                                return 'rd';
                              } else {
                                return 'th';
                              }
                            }

                            String date = data.elementAt(index).data().date.day.toString();
                            String uppercase = getUpperCase(data.elementAt(index).data().date.day);
                            String weekday = data.elementAt(index).data().date.weekday.toString();
                            String month = data.elementAt(index).data().date.month.toString();
                            String year = data.elementAt(index).data().date.year.toString();
                            String dateFormat = "$weekday, $date$uppercase $month, $year";

                            String noOfServings = data.elementAt(index).data().numberOfServings.toString();

                            List<String> guestNames = [];
                            data.elementAt(index).data().guestIds.forEach((element) {
                              guestNames.add(element.name);
                            });

                            List<String> recipeNames = [];
                            data.elementAt(index).data().recipeIds.forEach((element) {
                              recipeNames.add(element.label!);
                            });


                            return Card(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            MealPlan existingMealPlan =
                                            MealPlan(
                                                date: data.elementAt(index).data().date,
                                                numberOfServings: data.elementAt(index).data().numberOfServings,
                                                recipeIds: data.elementAt(index).data().recipeIds,
                                                guestIds: data.elementAt(index).data().guestIds,
                                                uid: data.elementAt(index).data().uid,
                                                referenceId: data.elementAt(index).reference.id);
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddMealPlanView(existingMealPlan: existingMealPlan)));
                                          },
                                          icon: const Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            MealPlanController().deleteMealPlan(data.elementAt(index).data());
                                          },
                                          icon: const Icon(Icons.delete)),
                                    ],
                                  ),
                                  Text(dateFormat),
                                  Text("No of Servings: $noOfServings"),
                                  Text(convertListToString(guestNames)),
                                  Text(convertListToString(recipeNames)),
                                ],
                              ),
                            );
                          });
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('no data!'));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 50.0,
                width: 300.0,
                child: Button(
                    colour: Colors.lime[700],
                    textColour: Colors.white,
                    buttonText: "Generate Shopping List",
                    fontSize: 16.0,
                    buttonTapped: () {
                      List<Ingredient> ingredients = [
                        Ingredient(food: "flour", foodCategory:"grains", foodId: "food_ahebfs0a985an4aubqaebbipra58", measure: "tablespoon", quantity: 3, weight: 24),
                        Ingredient(food: "egg", foodCategory:"Eggs", foodId: "food_ahebfs0a985an4aubqaebbipra58", measure: "tablespoon", quantity: 1, weight: 50),
                        Ingredient(food: "breadcrumbs", foodCategory:"bread, rolls and tortillas", foodId: "food_ahebfs0a985an4aubqaebbipra58", measure: "tablespoon", quantity: 3, weight: 50),
                        Ingredient(food: "fish", foodCategory:"seafood", foodId: "food_ahebfs0a985an4aubqaebbipra58", measure: "tablespoon", quantity: 3, weight: 500),
                        Ingredient(food: "sunflower oil", foodCategory:"Oils", foodId: "food_ahebfs0a985an4aubqaebbipra58", measure: "tablespoon", quantity: 3, weight: 40.8),
                        Ingredient(food: "salt", foodCategory:"Condiments and sauces", foodId: "food_ahebfs0a985an4aubqaebbipra58", measure: "tablespoon", quantity: 3, weight: 4),
                        Ingredient(food: "black pepper", foodCategory:"Condiments and sauces", foodId: "food_ahebfs0a985an4aubqaebbipra58", measure: "tablespoon", quantity: 3, weight: 2),
                      ];
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  ShoppingListView(ingredients: ingredients,)));
                    }),
              ),
              SizedBox(
                height: 50.0,
                width: 300.0,
                child: Button(
                    colour: Colors.lime[700],
                    textColour: Colors.white,
                    buttonText: "Create a Meal Plan",
                    fontSize: 16.0,
                    buttonTapped: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddMealPlanView()));
                    }),
              ),
            ],
          )),
    );
  }
}
