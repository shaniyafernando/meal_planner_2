import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/meal_plan_service.dart';
import 'package:meal_planner/controllers/share.dart';
import 'package:meal_planner/models/meal_plan.dart';
import 'package:multiselect/multiselect.dart';

import '../fragments/button.dart';
import '../models/guest.dart';
import '../models/recipe.dart';

class GuestDTO{
  String name;
  List healthLabels;

  GuestDTO(this.name, this.healthLabels);
}

class AddMealPlanView extends StatefulWidget {
  final MealPlan? existingMealPlan;
  const AddMealPlanView({Key? key, this.existingMealPlan}) : super(key: key);

  @override
  State<AddMealPlanView> createState() => _AddMealPlanViewState();
}

class _AddMealPlanViewState extends State<AddMealPlanView> {
  @override
  Widget build(BuildContext context) {
    double symmetricHorizontalPadding = 25.0;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    List<String> selectedRecipes = [];
    List<String> selectedRecipeIds = [];
    Map<String,String> recipeOptions = {};
    List<String> selectedGuests = [];
    List<String> selectedGuestIds = [];
    Map<String,GuestDTO> guestOptions = {};
    Set healthLabelsOfSelectedGuests = {};

    var guestSnapshots = FirebaseFirestore.instance
        .collection('guest')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
        fromFirestore: Guest.fromFireStore,
        toFirestore: (Guest guest, _) => guest.toFireStore())
        .snapshots();
    guestSnapshots.forEach((element) {
      for (var element in element.docs) {
        guestOptions[element.data().referenceId!] =
            GuestDTO(element.data().name, element.data().healthLabels);
      }
    });

    for (var element in selectedGuests) {
      String key = guestOptions.keys
          .firstWhere((k) => guestOptions[k]?.name == element);
      selectedGuestIds.add(key);
      healthLabelsOfSelectedGuests.addAll(guestOptions[key]?.healthLabels as Iterable);
    }

    if(healthLabelsOfSelectedGuests.isNotEmpty){
      var recipeSnapshots = FirebaseFirestore.instance
          .collection('recipe')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('healthLabels', arrayContainsAny: healthLabelsOfSelectedGuests.toList())
          .withConverter(
          fromFirestore: Recipe.fromFireStore,
          toFirestore: (Recipe recipe, _) => recipe.toFireStore())
          .snapshots();
      recipeSnapshots.forEach((element) {
        for (var element in element.docs) {
          recipeOptions[element.data().referenceId!] = element.data().label!;
        }
      });
    }else{
      var recipeSnapshots = FirebaseFirestore.instance
          .collection('recipe')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
          fromFirestore: Recipe.fromFireStore,
          toFirestore: (Recipe recipe, _) => recipe.toFireStore())
          .snapshots();
      recipeSnapshots.forEach((element) {
        for (var element in element.docs) {
          recipeOptions[element.data().referenceId!] = element.data().label!;
        }
      });
    }


    for (var element in selectedRecipes) {
      String key = recipeOptions.keys
          .firstWhere((k) => recipeOptions[k] == element);
      selectedRecipeIds.add(key);
    }


    DateTime dateTime = DateTime.now();
    String year = dateTime.year.toString();
    String month = dateTime.month.toString();
    String day = dateTime.day.toString();
    String date = '$day-$month-$year';

    final noOfServingsController = TextEditingController();
    final dateController = TextEditingController(text: date);

    if (width < 500) {
      symmetricHorizontalPadding;
    } else if (width < 900) {
      symmetricHorizontalPadding = 100.0;
    } else if (width < 1100) {
      symmetricHorizontalPadding = 200.0;
    } else if (width < 1280) {
      symmetricHorizontalPadding = 300.0;
    } else {
      symmetricHorizontalPadding = 400.0;
    }

    if (widget.existingMealPlan != null) {
      for (var element in widget.existingMealPlan!.guestIds) {
        selectedGuests.add(guestOptions[element]!.name);
      }
      for (var element in widget.existingMealPlan!.recipeIds) {
        selectedRecipes.add(recipeOptions[element]!);
      }

      dateTime = widget.existingMealPlan!.date;
      noOfServingsController.text =
          widget.existingMealPlan!.numberOfServings.toString();
    }

    return Scaffold(
        backgroundColor: Colors.lime[50],
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              height: 50.0,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
              child: Wrap(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: dateController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: date),
                          ))),
                  Button(
                      colour: Colors.orange,
                      textColour: Colors.white,
                      buttonText: "Select a Date",
                      fontSize: 16.0,
                      buttonTapped: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2025))
                            .then((value) {
                          setState(() {
                            dateTime = value!;
                          });
                        });
                      })
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: noOfServingsController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Number Of Servings"),
                      ))),
            ),
            const SizedBox(
              height: 20.0,
            ),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  selectedGuests = x;
                });
              },
              options: convertListToString(guestOptions.values.toList()),
              selectedValues: selectedGuests,
              whenEmpty: 'Select Guests',
            ),
            const SizedBox(
              height: 20.0,
            ),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  selectedRecipes = x;
                });
              },
              options: convertListToString(recipeOptions.values.toList()),
              selectedValues: selectedRecipes,
              whenEmpty: 'Select Recipes',
            ),

            const SizedBox(
              height: 50.0,
            ),
            Button(
                colour: Colors.orange,
                textColour: Colors.white,
                buttonText: "Save",
                fontSize: 16.0,
                buttonTapped: () {

                  MealPlan mealPlan = MealPlan(
                      date: dateTime,
                      numberOfServings:
                          int.parse(noOfServingsController.text.trim()),
                      recipeIds: selectedRecipeIds,
                      guestIds: selectedGuestIds,
                    uid: FirebaseAuth.instance.currentUser!.uid
                  );

                  if(widget.existingMealPlan != null){
                    MealPlanService().addMealPlan(mealPlan);
                  }else{
                    MealPlanService().updateMealPlan(mealPlan);
                  }

                })
          ]),
        ));
  }
}
