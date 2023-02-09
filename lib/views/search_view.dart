import 'package:flutter/material.dart';
import 'package:meal_planner/models/recipe.dart';

import '../controllers/recipe_api.dart';
import '../fragments/recipe_card.dart';

class SearchView extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    RecipeApi recipeApi = RecipeApi();
    var data = recipeApi.getRecipesBySearch(query);
    print(recipeApi.getRecipesBySearch("fish"));
    var screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if(screenWidth < 500){
      crossAxisCount = 1;
    }else if(screenWidth < 900){
      crossAxisCount = 2;
    }else{
      crossAxisCount = 3;
    }
    return FutureBuilder <List<Recipe>>(
        future: data,
        builder: (context, snapshot){
          if (snapshot.hasData) {
            List<Recipe>? data = snapshot.data;

            return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
                itemCount: data!.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RecipeCard(recipe: data[index], showDeleteButton: false,);
                }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.75

            ),);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else{
            return const Center(child: CircularProgressIndicator());
          }
        } );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return  const Center(child: Text('Search recipes'));
  }
}


