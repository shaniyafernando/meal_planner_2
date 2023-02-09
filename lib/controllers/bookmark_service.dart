import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipe.dart';


class BookmarkController {

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('recipe');


  // Stream<QuerySnapshot> getStream() {
  //   FirebaseFirestore.instance.collection('recipe').where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();
  // }

  Future<DocumentReference> addRecipe(Recipe recipe) {
    return collection.add(recipe.toJson());
  }

  void deleteRecipe(Recipe recipe) async {
    await collection.doc(recipe.referenceId).delete();
  }
}

