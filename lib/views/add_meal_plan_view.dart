import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import '../fragments/button.dart';
import '../models/recipe.dart';

class AddMealPlanView extends StatefulWidget {
  const AddMealPlanView({Key? key}) : super(key: key);

  @override
  State<AddMealPlanView> createState() => _AddMealPlanViewState();
}

class _AddMealPlanViewState extends State<AddMealPlanView> {
  @override
  Widget build(BuildContext context) {
    double symmetricHorizontalPadding = 25.0;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    List<String> recipeFilterList = [];
    List<String> recipeList = [];

    Map recipeMap = {};

    for (var element in recipeMap.values) {
      recipeList.add(element.toString());
    }

    final _dateController = TextEditingController();
    final _noOfServingsController = TextEditingController();

    if(width < 500){
      symmetricHorizontalPadding;
    }else if(width < 900){
      symmetricHorizontalPadding = 100.0;
    }else if(width < 1100){
      symmetricHorizontalPadding = 200.0;
    }else if(width < 1280){
      symmetricHorizontalPadding = 300.0;
    }else{
      symmetricHorizontalPadding = 400.0;
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
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Date"
                      ),
                    )
                )
            ),
          ),
                const SizedBox(height: 20.0,),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _noOfServingsController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Number Of Servings"
                  ),
                )
            )
        ),
      ),
                const SizedBox(height: 20.0,),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      recipeFilterList = x;
                    });
                  },
                  options: recipeList,
                  selectedValues: recipeFilterList,
                  whenEmpty: 'Select Recipes',
                ),
                const SizedBox(height: 50.0,),
                Button(
                    colour: Colors.orange,
                    textColour: Colors.white,
                    buttonText: "Save Meal Plan",
                    fontSize: 16.0,
                    buttonTapped: (){})
              ]
          ),
        )
    );
  }
}
