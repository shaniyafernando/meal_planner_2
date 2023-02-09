import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_planner/models/recipe.dart';

class MealPlan{
  String? referenceId;
  DateTime? date;
  int? numberOfServings;
  List<Recipe>? recipeIds;

  MealPlan(
      {this.referenceId, required this.date,
        required this.numberOfServings, required this.recipeIds});

  factory MealPlan.fromSnapshot(DocumentSnapshot snapshot) {
    final mealPlan = MealPlan.fromJson(snapshot.data() as Map<String, dynamic>);
    mealPlan.referenceId = snapshot.reference.id;
    return mealPlan;
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _mealPlanFromJson(json);

  Map<String, dynamic> toJson() => _mealPlanToJson(this);

  @override
  String toString() {
    return 'MealPlan{referenceId: $referenceId, date: $date, numberOfServings: $numberOfServings, recipeIds: $recipeIds}';
  }
}

MealPlan _mealPlanFromJson(Map<String, dynamic> json) {
  return MealPlan(date: json['date'] as DateTime,
      numberOfServings: json['numberOfServings'] as int,
      recipeIds: json['recipeIds'] as List<Recipe>);
}

Map<String, dynamic> _mealPlanToJson(MealPlan instance) =>
    <String, dynamic>{
      'date': instance.date,
      'numberOfServings': instance.numberOfServings,
      'recipeIds': instance.recipeIds
    };