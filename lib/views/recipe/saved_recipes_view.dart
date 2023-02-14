import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../fragments/drawer.dart';
import '../../fragments/recipe_card.dart';
import '../../models/recipe.dart';

class SavedRecipeView extends StatelessWidget {
  const SavedRecipeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot<Recipe>> savedData =  FirebaseFirestore.instance.collection('recipe').where('userId',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid).withConverter(
        fromFirestore: Recipe.fromFireStore,
        toFirestore: (Recipe recipe,_) => recipe.toFireStore()).snapshots();

    var screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 1;
    if(screenWidth < 500){
      crossAxisCount = 1;
    }else if(screenWidth < 900){
      crossAxisCount = 2;
    }else{
      crossAxisCount = 3;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize'),
          centerTitle: true,
        ),
        backgroundColor: Colors.lime[50],
        drawer: const CustomDrawer(),
        body: StreamBuilder<QuerySnapshot<Recipe>>(
            stream: savedData,
            builder: ( context, snapshot){
              if (snapshot.hasData) {
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index)  {
                    return RecipeCard(recipe: snapshot.data!.docs.elementAt(index).data() , showDeleteButton: true,);
                  }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1.75

                ),);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }else if (!snapshot.hasData) {
                return const Text("no data");
              } else{
                return const Center(child: CircularProgressIndicator());
              }
            } )
    );
  }
}
