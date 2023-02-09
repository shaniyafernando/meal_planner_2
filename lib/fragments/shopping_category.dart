import 'package:flutter/material.dart';

class ShoppingCategoryCard extends StatelessWidget {
  final String category;
  final List<String> ingredients;
  const ShoppingCategoryCard({Key? key, required this.category, required this.ingredients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(category),
        const SizedBox(height: 10.0),
        ListView.builder(
            itemBuilder: (context, index) {
              return Text(ingredients[index]);
            },
            itemCount: ingredients.length),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
