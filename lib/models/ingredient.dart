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

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _ingredientFromJson(json);

  Map<String, dynamic> toJson() => _ingredientToJson(this);

  @override
  String toString() {
    return 'IngredientModel{foodCategory: $foodCategory, quantity: $quantity, weight: $weight, measure: $measure, food: $food, foodId: $foodId}';
  }
}

Ingredient _ingredientFromJson(Map<String, dynamic> json) {
  return Ingredient(
      foodCategory: json['foodCategory'] as String,
      quantity: json['quantity'] as double,
      weight: json['weight'] as double,
      measure: json['measure'] as String,
      food: json['food'] as String,
      foodId: json['foodId'] as String);
}

Map<String, dynamic> _ingredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'foodCategory': instance.foodCategory,
      'quantity': instance.quantity,
      'weight': instance.weight,
      'measure': instance.measure,
      'food': instance.food,
      'foodId': instance.foodId
    };

