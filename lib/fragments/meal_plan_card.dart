import 'package:flutter/material.dart';
import 'package:meal_planner/fragments/recipe_card.dart';

class MealPlanCard extends StatelessWidget {
  final String label,noOfServings;
  const MealPlanCard({Key? key, required this.label, required this.noOfServings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Recipe: $label'),
          const SizedBox(height: 10.0),
          Text('Number of servings: $noOfServings'),
          const SizedBox(height: 10.0),
          const Text('Leftovers:'),
          const SizedBox(height: 50.0),
        ],
      )
    );
  }
}
