import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/fragments/recipe_card.dart';
import 'package:meal_planner/views/recipe/search_view.dart';

import '../../controllers/authentication_controller.dart';
import '../../controllers/recipe_api.dart';
import '../../fragments/drawer.dart';
import '../../models/recipe.dart';
import 'filter_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var data = RecipeApi().getRecipesBySearch('fish');

    var screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;

    if (screenWidth < 500) {
      crossAxisCount = 1;
    } else if (screenWidth < 900) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FilterView()));
                },
                icon: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.filter,
                    color: Colors.white,
                  ),
                )),
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchView());
                },
                icon: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )),
            IconButton(
                onPressed: () {
                  AuthenticationController(FirebaseAuth.instance).signOut(context);
                },
                icon: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
        backgroundColor: Colors.lime[50],
        drawer: const CustomDrawer(),
        body:
        FutureBuilder<List<Recipe>>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Recipe>?  snapshotData = snapshot.data;
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 2.5),
                  itemCount: snapshotData!.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      recipe: snapshotData[index],
                      showDeleteButton: false,
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount, childAspectRatio: 1.75),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child:  Text("no data"));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        );
  }
}
