
class Ingredient {
  String foodCategory;
  double quantity;
  double weight;
  String measure;
  String food;
  String foodId;

  Ingredient(
      {required this.foodCategory,
      required this.quantity,
      required this.weight,
      required this.measure,
      required this.food,
      required this.foodId});

  factory Ingredient.fromFireStore(
      Map<String, dynamic> object
      ) {
    final json = object;
    return Ingredient(
        foodCategory: json['foodCategory'],
        quantity: json['quantity'],
        weight: json['weight'] ,
        measure: json['measure'] ,
        food: json['food'],
        foodId: json['foodId']
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


