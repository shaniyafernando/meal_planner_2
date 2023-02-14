import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_ranger/date_ranger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/share.dart';
import 'package:meal_planner/fragments/button.dart';
import 'package:meal_planner/fragments/recipe_card.dart';
import 'package:meal_planner/views/meal%20plan/add_meal_plan_view.dart';
import 'package:meal_planner/views/meal%20plan/shopping_list_view.dart';
import '../../controllers/meal_plan_service.dart';
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
      start: DateTime.now().subtract(const Duration(days: 2)), end: DateTime.now().add(const Duration(days: 5)));
  List<Ingredient> ingredients = [];

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<MealPlan>> mealPlanSnapShots = FirebaseFirestore
        .instance
        .collection('mealPlan')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore: MealPlan.fromFireStore,
            toFirestore: (MealPlan mealPlan, _) => mealPlan.toFireStore())
        .snapshots().where((event) => event.docs.iterator.current.data().date.isAfter(initialDateRange.start) &&
        event.docs.iterator.current.data().date.isBefore(initialDateRange.end));

    var screenWidth =
        MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (screenWidth < 500) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: const Text("foodnertize"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.download_for_offline)),
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
                        element.data().recipeIds.forEach((element) {
                          ingredients.addAll(element.ingredients);
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

                            String date = data
                                .elementAt(index)
                                .data()
                                .date
                                .day
                                .toString();
                            String uppercase = getUpperCase(
                                data.elementAt(index).data().date.day);
                            String weekday = data
                                .elementAt(index)
                                .data()
                                .date
                                .weekday
                                .toString();
                            String month = data
                                .elementAt(index)
                                .data()
                                .date
                                .month
                                .toString();
                            String year = data
                                .elementAt(index)
                                .data()
                                .date
                                .year
                                .toString();
                            String dateFormat =
                                "$weekday, $date$uppercase $month, $year";


                            String noOfServings = data
                                .elementAt(index)
                                .data()
                                .numberOfServings
                                .toString();

                            List<String> guestNames = [];
                            data.elementAt(index).data().guestIds.forEach((element) { guestNames.add(element.name);});

                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(dateFormat),
                                    subtitle:
                                        Text("No of Servings: $noOfServings"),
                                    trailing: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddMealPlanView(
                                                              existingMealPlan:
                                                                  data
                                                                      .elementAt(
                                                                          index)
                                                                      .data())));
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            onPressed: () {
                                              MealPlanService().deleteMealPlan(
                                                  data.elementAt(index).data());
                                            },
                                            icon: const Icon(Icons.delete)),
                                      ],
                                    ),
                                  ),
                             ListTile(
                            subtitle:
                            Text(convertListToString(guestNames)),
                            ),
                                  GridView.builder(
                                    itemCount: data.elementAt(index).data().recipeIds.length ,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: 1.75),
                                    itemBuilder: (BuildContext context, int index) {
                                      return RecipeCard(
                                        recipe: data.elementAt(index).data().recipeIds.elementAt(index),
                                        showDeleteButton: false,
                                      );
                                    },
                                  ),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShoppingListView(
                                ingredients: ingredients,
                              )));
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
