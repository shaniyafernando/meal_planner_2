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
import '../../models/guest.dart';
import '../../models/ingredient.dart';
import '../../models/meal_plan.dart';
import '../../models/recipe.dart';

class PlannerView extends StatefulWidget {
  const PlannerView({Key? key}) : super(key: key);

  @override
  State<PlannerView> createState() => _PlannerViewState();
}

class _PlannerViewState extends State<PlannerView> {
  DateTimeRange initialDateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 5)));
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
        .snapshots();


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
          padding: const EdgeInsets.all(40.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  const SizedBox(
                    height: 20.0,
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
                              builder: (context) => ShoppingListView(ingredients: [],)));
                        }),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: StreamBuilder<QuerySnapshot<MealPlan>>(
                      stream: mealPlanSnapShots,
                      builder: (context, snapshot) {
                        List<QueryDocumentSnapshot<MealPlan>> data =
                            snapshot.data!.docs;

                        return ListView.builder(
                            itemCount: data.length,
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
                                  .elementAt(index).data().date.day.toString();
                              String uppercase = getUpperCase(
                                  data.elementAt(index).data().date.day);
                              String weekday = data
                                  .elementAt(index).data().date.weekday.toString();
                              String month = data
                                  .elementAt(index).data().date.month.toString();
                              String year = data
                                  .elementAt(index).data().date.year.toString();
                              String dateFormat =
                                  "$weekday, $date$uppercase $month, $year";

                              var recipeSnapshots = FirebaseFirestore.instance.collection('recipe')
                                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .where('Document ID',arrayContainsAny: data.elementAt(index).data().recipeIds)
                                  .withConverter(fromFirestore: Recipe.fromFireStore,
                                  toFirestore: (Recipe recipe,_) => recipe.toFireStore())
                                  .snapshots();

                              List<String> nameOfGuests = [];
                              var guestSnapshots = FirebaseFirestore.instance.collection('guest')
                                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                                  .where('Document ID',arrayContainsAny: data.elementAt(index).data().guestIds)
                                  .withConverter(fromFirestore: Guest.fromFireStore,
                                  toFirestore: (Guest guest,_) => guest.toFireStore())
                                  .snapshots();

                              String noOfServings = data
                                  .elementAt(index).data().numberOfServings.toString();

                              return Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                        title: Text(dateFormat),
                                        subtitle: Text("No of Servings: $noOfServings"),
                                        trailing: Row(
                                          children: [
                                            IconButton(onPressed:  (){
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (context) =>
                                                      AddMealPlanView(existingMealPlan: data.elementAt(index).data())
                                                  )
                                              );
                                            }, icon: const Icon(Icons.edit)),
                                            IconButton(onPressed:  (){
                                              MealPlanService().deleteMealPlan(data.elementAt(index).data());
                                            }, icon: const Icon(Icons.delete)),
                                          ],
                                        ),
                                    ),
                                    StreamBuilder<QuerySnapshot<Guest>>(
                                      stream: guestSnapshots,
                                      builder: (context, snapshot) {
                                        List<String> guests = [];
                                        for (var element in snapshot.data!.docs) {
                                          guests.add(element.data().name);
                                        }
                                        return ListTile(
                                          subtitle: Text(convertListToString(guests)),
                                        );
                                      }
                                    ),
                                    StreamBuilder<QuerySnapshot<Recipe>>(
                                      stream: recipeSnapshots,
                                      builder: (context, snapshot) {
                                        var screenWidth = MediaQuery.of(context).size.width;
                                        int crossAxisCount = 1;
                                        if(screenWidth < 500){
                                          crossAxisCount = 1;
                                        }else if(screenWidth < 900){
                                          crossAxisCount = 2;
                                        }else{
                                          crossAxisCount = 3;
                                        }
                                        return GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              childAspectRatio: 1.75
                                          ),
                                          itemBuilder: (BuildContext context, int index) {
                                            return RecipeCard(recipe: snapshot.data!.docs.elementAt(index).data(),
                                              showDeleteButton: false,);
                                          },
                                        );
                                      }
                                    ),
                                  ],
                                ),
                              );
                            });
                      })),
            ],
          )),
    );
  }
}
