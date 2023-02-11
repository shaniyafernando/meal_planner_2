import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  String? foodCategory;
  double? quantity;
  double? weight;
  String? measure;
  String? food;
  String? foodId;

  Ingredient(
      {required this.foodCategory,
      required this.quantity,
      required this.weight,
      required this.measure,
      required this.food,
      required this.foodId});

  factory Ingredient.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,SnapshotOptions? options
      ) {
    final json = snapshot.data();
    return Ingredient(
        foodCategory: json?['foodCategory'] as String,
        quantity: json?['quantity'] as double,
        weight: json?['weight'] as double,
        measure: json?['measure'] as String,
        food: json?['food'] as String,
        foodId: json?['foodId'] as String
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'foodCategory': foodCategory,
      'quantity': quantity,
      'weight': weight,
      'measure': measure,
      'food': food,
      'foodId': foodId
    };
  }

}


