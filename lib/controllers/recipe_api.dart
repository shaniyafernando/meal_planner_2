import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:meal_planner/models/ingredient.dart';
import 'package:meal_planner/models/lists.dart';
import 'dart:convert';

import 'package:meal_planner/models/recipe.dart';

class RecipeApi{


  Future<List<Recipe>> getRecipesBySearch(String query) async {

    String appId = '38c42093';
    String apiKey = '9fdbc777449eb27aaa83133397001cf4';

    String url = 'https://api.edamam.com/search?app_id=$appId&app_key=$apiKey&q=$query';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    var searchHits = jsonData['hits'];

    List<Recipe> recipes = getRecipes(searchHits);
    return recipes;
  }


  Future<List<Recipe>> getRecipesByFilter(List<String> dietFilterList,List<String> healthFilterList,
      List<String> mealTypeFilterList, List<String> dishTypeFilterList ,List<String> cuisineTypeFilterList ,
      String rangeOfIngredients ,String rangeOfCalories) async {

    String substring = createSubStringOfFilterApi(dietFilterList, healthFilterList, mealTypeFilterList,
        dishTypeFilterList, cuisineTypeFilterList, rangeOfIngredients, rangeOfCalories);

    String appId = '38c42093';
    String apiKey = '9fdbc777449eb27aaa83133397001cf4';

    String url = 'https://api.edamam.com/search?app_id=$appId&app_key=$apiKey$substring';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    var searchHits = jsonData['hits'];
    List<Recipe> recipes = getRecipes(searchHits);
    return recipes;
  }

  String createSubStringOfFilterApi(List<String> dietFilterList,List<String> healthFilterList,
  List<String> mealTypeFilterList, List<String> dishTypeFilterList ,List<String> cuisineTypeFilterList ,
      String rangeOfIngredients ,String rangeOfCalories){

    String api = '';

    for (var value in dietFilterList){
        return '$api&diet=${dietMap[value]}';
    }

    for (var value in healthFilterList){
      return '$api&health=${healthMap[value]}';
    }
    for (var value in mealTypeFilterList){
      return '$api&mealType=$value';
    }

    for (var value in dishTypeFilterList){
      return '$api&dishType=$value}';
    }

    for (var value in cuisineTypeFilterList){
      return '$api&cuisineType=$value}';
    }

    return '$api&ingr=$rangeOfIngredients&calories=$rangeOfCalories}';
  }

  List<Recipe> getRecipes(var searchHits){
    List<Recipe> recipes = <Recipe>[];
    for(var hit in searchHits){
      List<Ingredient> ingredients = [];

      for(var ingredient in hit['recipe']['ingredients']){
        var i = Ingredient(
            foodCategory: ingredient['foodCategory'], quantity: ingredient['quantity'],
            weight: ingredient['weight'], measure: ingredient['measure'],
            food: ingredient['food'], foodId: ingredient['foodId']);
        ingredients.add(i);
      }

      Recipe recipe = Recipe(
        uri: hit['recipe']['uri'], label: hit['recipe']['label'], image: hit['recipe']['image'],
        source: hit['recipe']['source'], url: hit['recipe']['url'], numberOfServings: hit['recipe']['yield'],
        calories: hit['recipe']['calories'], totalWeight: hit['recipe']['totalWeight'], ingredientLines: hit['recipe']['ingredientLines'],
        dietLabels: hit['recipe']['dietLabels'], healthLabels: hit['recipe']['healthLabels'],
        mealType: hit['recipe']['mealType'], dishType: hit['recipe']['dishType'],
        cuisineType: hit['recipe']['cuisineType'], externalId: hit['recipe']['externalId'], ingredients: ingredients,
        userId: FirebaseAuth.instance.currentUser!.uid, referenceId: ''
      );
      recipes.add(recipe);
    }

    return recipes;
  }




}

