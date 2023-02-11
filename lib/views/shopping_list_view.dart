import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/share.dart';
import '../fragments/drawer.dart';
import '../models/meal_plan.dart';

class ShoppingListView extends StatelessWidget {
  final DateTimeRange dateTimeRange;
  const ShoppingListView({Key? key, required this.dateTimeRange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> map = {
      'Vegetable': ["100g scallions"],
      'Dairy': ["50g butter"],
      "Meat/Fish": ["400g fish filet"],
    };

    Stream<QuerySnapshot<MealPlan>> mealPlanSnapShots = FirebaseFirestore
        .instance
        .collection('mealPlan')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isLessThanOrEqualTo: dateTimeRange.end)
        .where('date', isGreaterThanOrEqualTo: dateTimeRange.start)
        .withConverter(
            fromFirestore: MealPlan.fromFireStore,
            toFirestore: (MealPlan mealPlan, _) => mealPlan.toFireStore())
        .snapshots();

    mealPlanSnapShots.forEach((element) {

    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  printDoc("SHARE", 'shopping-list', map, null, null);
                },
                icon: const Icon(Icons.download_for_offline)),
          ],
        ),
        backgroundColor: Colors.lime[50],
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.only(right: 40.0, left: 20.0),
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Vegetable",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("100g scallions"),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Dairy",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("50g butter"),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Meat/Fish",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("400g fish filet"),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                );
              }),
        ));
  }
}
