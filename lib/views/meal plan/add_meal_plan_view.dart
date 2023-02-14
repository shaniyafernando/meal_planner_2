import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/meal_plan_service.dart';
import 'package:meal_planner/controllers/share.dart';
import 'package:meal_planner/models/meal_plan.dart';
import 'package:multiselect/multiselect.dart';

import '../../fragments/button.dart';
import '../../models/guest.dart';
import '../../models/recipe.dart';

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
  final noOfServingsController = TextEditingController();
  final dateController = TextEditingController();
  DateTime dateTime = DateTime.now();

  List<String> selectedGuests = [];
  List<String> selectedRecipes = [];


  @override
  Widget build(BuildContext context) {
    dateController.text = '${dateTime.day}-${dateTime.month}-${dateTime.year}';

    double symmetricHorizontalPadding = 25.0;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;


    List<String> selectedRecipeIds = [];
    Map<String,String> recipeOptions = {};
    List<Recipe> selectedRecipeList = [];

    List<Guest> selectedGuestList =[];
    List<String> selectedGuestIds = [];
    Map<String,GuestDTO> guestOptionsMap = {};
    List<String> guestOptions = [];
    Set healthLabelsOfSelectedGuests = {};

    FirebaseFirestore.instance
        .collection('guest')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
        fromFirestore: Guest.fromFireStore,
        toFirestore: (Guest guest, _) => guest.toFireStore())
        .snapshots().listen((event) {
      for (var element in event.docs) {
        guestOptionsMap[element.data().referenceId!] =
            GuestDTO(element.data().name, element.data().healthLabels);
        guestOptions.add(element.data().name);
      }
      print(guestOptions);
      print(guestOptionsMap);
    });

    for (var element in selectedGuests) {
      String key = guestOptionsMap.keys
          .firstWhere((k) => guestOptionsMap[k]!.name == element);
      selectedGuestIds.add(key);
      FirebaseFirestore.instance
          .collection('guest')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('Document ID', arrayContainsAny: selectedGuestIds)
          .withConverter(
          fromFirestore: Guest.fromFireStore,
          toFirestore: (Guest guest, _) => guest.toFireStore())
          .snapshots().listen((event) {
        for (var element in event.docs) {
          selectedGuestList.add(element.data());
        }
      });
      healthLabelsOfSelectedGuests.addAll(guestOptionsMap[key]!.healthLabels);
    }

    if(healthLabelsOfSelectedGuests.isNotEmpty){
      FirebaseFirestore.instance
          .collection('recipe')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('healthLabels', arrayContainsAny: healthLabelsOfSelectedGuests.toList())
          .withConverter(
          fromFirestore: Recipe.fromFireStore,
          toFirestore: (Recipe recipe, _) => recipe.toFireStore())
          .snapshots().listen((event) {
        for (var element in event.docs) {
          recipeOptions[element.data().referenceId] = element.data().label!;
        }
        print(recipeOptions);
        print(healthLabelsOfSelectedGuests);
      });
    }else{
      FirebaseFirestore.instance
          .collection('recipe')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .withConverter(
          fromFirestore: Recipe.fromFireStore,
          toFirestore: (Recipe recipe, _) => recipe.toFireStore())
          .snapshots().listen((event) {
        for (var element in event.docs) {
          recipeOptions[element.data().referenceId] = element.data().label!;
        }
        print(recipeOptions);
        print(healthLabelsOfSelectedGuests);

      });
    }


    for (var element in selectedRecipes) {
      String key = recipeOptions.keys
          .firstWhere((k) => recipeOptions[k] == element);
      selectedRecipeIds.add(key);
      FirebaseFirestore.instance
          .collection('recipe')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('Document ID', arrayContainsAny: selectedRecipeIds)
          .withConverter(
          fromFirestore: Recipe.fromFireStore,
          toFirestore: (Recipe recipe, _) => recipe.toFireStore())
          .snapshots().listen((event) {
        for (var element in event.docs) {
          selectedRecipeList.add(element.data());
        }
      });
    }



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
        selectedGuests.add(guestOptionsMap[element]!.name);
      }
      for (var element in widget.existingMealPlan!.recipeIds) {
        selectedRecipes.add(recipeOptions[element]!);
      }

      dateController.text = '${widget.existingMealPlan!.date.day}-${widget.existingMealPlan!.date.month}-${widget.existingMealPlan!.date.year}';
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
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(
                height: 50.0,
              ),
              Wrap(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.lime[50],
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: dateController,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                              // hintText: date,hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ))),

                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: Button(
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
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.lime[50],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: noOfServingsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Number Of Servings",
                        hintStyle: TextStyle(color: Colors.grey)),
                      ))),
              const SizedBox(
                height: 20.0,
              ),
              DropDownMultiSelect(
                onChanged: (List<String> x) {
                  setState(() {
                    print(x);
                    selectedGuests = x;
                    print(selectedGuests);
                  });
                },
                options: guestOptions,
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
                options: recipeOptions.values.toList(),
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

                    List<Recipe> r = [];
                    List<Guest> g = [];

                    FirebaseFirestore.instance
                        .collection('recipe')
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('Document ID', arrayContainsAny: selectedRecipeIds)
                        .withConverter(
                        fromFirestore: Recipe.fromFireStore,
                        toFirestore: (Recipe recipe, _) => recipe.toFireStore())
                        .snapshots().listen((event) {
                      for (var element in event.docs) {
                        r.add(element.data());
                      }
                    });

                    FirebaseFirestore.instance
                        .collection('guest')
                        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('Document ID', arrayContainsAny: selectedGuestIds)
                        .withConverter(
                        fromFirestore: Guest.fromFireStore,
                        toFirestore: (Guest guest, _) => guest.toFireStore())
                        .snapshots().listen((event) {
                      for (var element in event.docs) {
                        g.add(element.data());
                      }
                    });

                    MealPlan mealPlan = MealPlan(
                        date: dateTime,
                        numberOfServings:
                            int.parse(noOfServingsController.text.trim()),
                        // recipeIds: selectedRecipeList,
                        // guestIds: selectedGuestList,
                      uid: FirebaseAuth.instance.currentUser!.uid, recipeIds: r, guestIds: g
                    );

                    if(widget.existingMealPlan == null){
                      MealPlanService().addMealPlan(mealPlan);
                    }else{
                      MealPlan updateMealPlan = MealPlan(
                          date: dateTime,
                          numberOfServings:
                          int.parse(noOfServingsController.text.trim()),
                          recipeIds: selectedRecipeList,
                          guestIds: selectedGuestList,
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        referenceId: widget.existingMealPlan!.referenceId
                      );
                      MealPlanService().updateMealPlan(updateMealPlan);
                    }

                  })
            ]),
          ),
        ));
  }
}
