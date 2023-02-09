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


  @override
  String toString() {
    return 'Recipe{uri: $uri, label: $label, image: $image, source: $source, url: $url, '
        'numberOfServings: $numberOfServings, calories: $calories, '
        'totalWeight: $totalWeight, ingredients: $ingredients, '
        'ingredientLines: $ingredientLines, dietLabels: $dietLabels, '
        'healthLabels: $healthLabels, mealType: $mealType, dishType: $dishType, '
        'cuisineType: $cuisineType, externalId: $externalId,userId: $userId, referenceId: $referenceId}';

  }


  factory Recipe.fromSnapshot(DocumentSnapshot snapshot) {
    final recipe = Recipe.fromJson(snapshot.data() as Map<String, dynamic>);
    recipe.referenceId = snapshot.reference.id;
    return recipe;
  }
  // 6
  factory Recipe.fromJson(Map<String, dynamic> json) => _recipeFromJson(json);
  // 7
  Map<String, dynamic> toJson() => _recipeToJson(this);
}

// 1
Recipe _recipeFromJson(Map<String, dynamic> json) {
  return Recipe(
      uri: json['uri'] as String?,
      label: json['label'] as String?,
      image: json['image'] as String?,
      source: json['source']as String?,
      url: json['url']as String?,
      numberOfServings: json['yield'] as double?,
      calories: json['calories'] as double?,
      totalWeight: json['totalWeight'] as double?,
      ingredientLines: json['ingredientLines'] as List<dynamic>,
      dietLabels: json['dietLabels'] as List<dynamic>,
      healthLabels: json['healthLabels'] as List<dynamic>,
      mealType: json['mealType'] as List<dynamic>,
      dishType: json['dishType'] as List<dynamic>,
      cuisineType: json['cuisineType'] as List<dynamic>,
      ingredients: _convertIngredients(json['ingredients'] as List<dynamic>),
      externalId: json['externalId']as String?,
      userId: json['userId'] as String
  );
}
// 2
List<Ingredient> _convertIngredients(List<dynamic> ingredientMap) {
  final ingredients = <Ingredient>[];

  for (final ingredient in ingredientMap) {
    ingredients.add(Ingredient.fromJson(ingredient as Map<String, dynamic>));
  }
  return ingredients;
}
// 3
Map<String, dynamic> _recipeToJson(Recipe instance) => <String, dynamic>{
  'uri': instance.uri,
  'label': instance.label,
  'image': instance.image,
  'source': instance.source,
  'url': instance.url,
  'numberOfServings': instance.numberOfServings,
  'calories': instance.calories,
  'totalWeight': instance.totalWeight,
  'ingredientLines': instance.ingredientLines,
  'dietLabels': instance.dietLabels,
  'healthLabels': instance.healthLabels,
  'mealType': instance.mealType,
  'dishType': instance.dishType,
  'cuisineType': instance.cuisineType,
  'ingredients': _ingredientList(instance.ingredients),
  'externalId': instance.externalId,
  'userId': instance.userId
};
// 4
List<Map<String, dynamic>>? _ingredientList(List<Ingredient>? ingredients) {
  if (ingredients == null) {
    return null;
  }
  final ingredientMap = <Map<String, dynamic>>[];
  for (var ingredient in ingredients) {
    ingredientMap.add(ingredient.toJson());
  }
  return ingredientMap;
}
