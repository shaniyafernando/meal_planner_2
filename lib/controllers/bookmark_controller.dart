import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipe.dart';


class BookmarkController {

  final CollectionReference collection =
  FirebaseFirestore.instance.collection('recipe');


  Stream<QuerySnapshot> getStream() {
    return FirebaseFirestore.instance.collection('recipe')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<DocumentReference> addRecipe(Recipe recipe) {
    return collection.add(recipe.toFireStore());
  }

  void deleteRecipe(Recipe recipe){
    collection.doc(recipe.referenceId).delete();
  }
}

