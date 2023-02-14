import 'dart:core';

import 'package:flutter/material.dart';
import 'package:meal_planner/fragments/button.dart';
import 'package:multiselect/multiselect.dart';

import '../../models/lists.dart';

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  List<String> dietFilterList = [];
  List<String> healthFilterList = [];
  List<String> mealTypeFilterList = [];
  List<String> dishTypeFilterList = [];
  List<String> cuisineTypeFilterList = [];
  String rangeOfIngredients = '5-8';
  String rangeOfCalories = '800-1200';

  @override
  Widget build(BuildContext context) {
    double symmetricHorizontalPadding = 25.0;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0,),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      dietFilterList = x;
                    });
                  },
                  options: dietMap.keys.toList(),
                  selectedValues: dietFilterList,
                  whenEmpty: 'Select Diet Type',
                ),
                const SizedBox(height: 20.0,),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      healthFilterList =x;
                    });
                  },
                  options: healthMap.keys.toList(),
                  selectedValues: healthFilterList,
                  whenEmpty: 'Select for Specific Health Requirements',
                ),
                const SizedBox(height: 20.0,),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      mealTypeFilterList =x;
                    });
                  },
                  options: mealTypeList,
                  selectedValues: mealTypeFilterList,
                  whenEmpty: 'Select Meal type',
                ),
                const SizedBox(height: 20.0,),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      dishTypeFilterList =x;
                    });
                  },
                  options: dishTypeList,
                  selectedValues:dishTypeFilterList,
                  whenEmpty: 'Select Dish Type',
                ),
                const SizedBox(height: 20.0,),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      cuisineTypeFilterList =x;
                    });
                  },
                  options: cuisineTypeList,
                  selectedValues: cuisineTypeFilterList,
                  whenEmpty: 'Select Cuisine',
                ),
                const SizedBox(height: 20.0,),
                const Text("No of ingredients: "),
                const SizedBox(height: 10.0,),
                Wrap(
                  children: [
                    RadioListTile<String>(
                      title: const Text('3-5'),
                      value: '3-5',
                      groupValue: rangeOfIngredients,
                      onChanged: (String? value) {
                        setState(() {
                          rangeOfIngredients = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('5-8'),
                      value: '5-8',
                      groupValue: rangeOfIngredients,
                      onChanged: (String? value) {
                        setState(() {
                          rangeOfIngredients = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('8-12'),
                      value: '8-12',
                      groupValue: rangeOfIngredients,
                      onChanged: (String? value) {
                        setState(() {
                          rangeOfIngredients = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('12-17'),
                      value: '12-17',
                      groupValue: rangeOfIngredients,
                      onChanged: (String? value) {
                        setState(() {
                          rangeOfIngredients = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0,),
            const Text("Calorie range: "),
            const SizedBox(height: 10.0,),
            Wrap(
                children: [
                  RadioListTile<String>(
                    title: const Text('300-500'),
                    value: '300-500',
                    groupValue: rangeOfCalories,
                    onChanged: (String? value) {
                      setState(() {
                        rangeOfCalories = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('500-800'),
                    value: '500-800',
                    groupValue: rangeOfCalories,
                    onChanged: (String? value) {
                      setState(() {
                        rangeOfCalories = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('800-1200'),
                    value: '800-1200',
                    groupValue: rangeOfCalories,
                    onChanged: (String? value) {
                      setState(() {
                        rangeOfCalories = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('1200-1500'),
                    value: '1200-1500',
                    groupValue: rangeOfCalories,
                    onChanged: (String? value) {
                      setState(() {
                        rangeOfCalories = value!;
                      });
                    },
                  ),
                ]),
                const SizedBox(height: 50.0,),
                Button(
                    colour: Colors.orange,
                    textColour: Colors.white,
                    buttonText: "Filter",
                    fontSize: 16.0,
                    buttonTapped: (){})
              ]
            ),
          ),
        )
    );
  }
}
