import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_planner/models/ingredient.dart';

class Recipe {
  String? uri;
  String? label;
  String? image;
  String? source;
  String? url;
  double? numberOfServings;
  double? calories;
  double? totalWeight;
  List<Ingredient> ingredients = [];
  List<dynamic> ingredientLines = [];
  List<dynamic> dietLabels = [];
  List<dynamic> healthLabels = [];
  List<dynamic> mealType = [];
  List<dynamic> dishType = [];
  List<dynamic> cuisineType = [];
  String? externalId;
  String? referenceId;
  String userId;

  Recipe({
    required this.uri,
    required this.label,
    required this.image,
    this.source,
    required this.url,
    required this.numberOfServings,
    required this.calories,
    this.totalWeight,
    required this.ingredients,
    required this.ingredientLines,
    required this.dietLabels,
    required this.healthLabels,
    required this.mealType,
    required this.dishType,
    required this.cuisineType,
    required this.externalId,
    required this.userId,
    this.referenceId
  });

  factory Recipe.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options
      ) {
    final json = snapshot.data();
    return Recipe(
        uri: json?['uri'] ,
        label: json?['label'],
        image: json?['image'],
        source: json?['source'],
        url: json?['url'],
        numberOfServings: json?['yield'],
        calories: json?['calories'],
        totalWeight: json?['totalWeight'],
        ingredientLines: json?['ingredientLines'],
        dietLabels: json?['dietLabels'],
        healthLabels: json?['healthLabels'],
        mealType: json?['mealType'],
        dishType: json?['dishType'],
        cuisineType: json?['cuisineType'],
        ingredients: _convertIngredients(json?['ingredients']),
        externalId: json?['externalId'],
        userId: json?['userId']
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'uri': uri,
      'label': label,
      'image': image,
      'source': source,
      'url': url,
      'numberOfServings': numberOfServings,
      'calories': calories,
      'totalWeight': totalWeight,
      'ingredientLines': ingredientLines,
      'dietLabels': dietLabels,
      'healthLabels': healthLabels,
      'mealType': mealType,
      'dishType': dishType,
      'cuisineType': cuisineType,
      'ingredients': _ingredientList(ingredients),
      'externalId': externalId,
      'userId': userId
    };
  }
}

List<Ingredient> _convertIngredients(List<DocumentSnapshot<Map<String, dynamic>>> ingredientMap) {
  final ingredients = <Ingredient>[];

  for (var ingredient in ingredientMap) {
    ingredients.add(Ingredient.fromFireStore(ingredient,null));
  }
  return ingredients;
}

List<Map<String, dynamic>>? _ingredientList(List<Ingredient>? ingredients) {
  if (ingredients == null) {
    return null;
  }
  final ingredientMap = <Map<String, dynamic>>[];
  for (var ingredient in ingredients) {
    ingredientMap.add(ingredient.toFireStore());
  }
  return ingredientMap;
}
