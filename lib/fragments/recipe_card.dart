import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/bookmark_controller.dart';
import 'package:meal_planner/controllers/share_controller.dart';
import 'package:meal_planner/views/recipe/recipe_detail_view.dart';

import '../models/recipe.dart';
import '../utils.dart';


class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool showDeleteButton;
  const RecipeCard({Key? key, required this.recipe, required this.showDeleteButton}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var screenWidth = MediaQuery.of(context).size.width;
    // var widthOfContainer = screenWidth * 0.45;
    // BookmarkController bookmarkController = BookmarkController();
    //
    // if(screenWidth < 500.0){
    //   widthOfContainer = screenWidth;
    // }else if(screenWidth > 900){
    //   widthOfContainer = screenWidth * 0.30;
    // }

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:
            (context) =>  RecipeDetailView( recipe: recipe,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 220.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Row (
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: GridTile(child: Image(
                  image: NetworkImage(recipe.image!),
                  height: 190.0,
                  width: 190.0,
                  fit: BoxFit.cover,
                )),
              ),
              GridTile(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0,),
                  RichText(text: TextSpan(text:recipe.label!,style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black))),
                  const SizedBox(height: 10.0,),
                  const Text("Meal Type", style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 10.0,
                      color: Colors.black
                  )),
                  Text(convertListToString(recipe.mealType)),
                  const SizedBox(height: 10.0,),
                  const Text("Dish Type", style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 10.0,
                      color: Colors.black
                  )),
                  Text(convertListToString(recipe.dishType)),
                  const SizedBox(height: 10.0,),
                  const Text("Cuisine", style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 10.0,
                      color: Colors.black
                  )),
                  Text(convertListToString(recipe.cuisineType)),
                  const SizedBox(height: 5.0,),
                  showDeleteButton == true ? IconButton(
                      onPressed:(){
                        BookmarkController().deleteRecipe(recipe);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red)): const SizedBox(height: 1.0,)
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}