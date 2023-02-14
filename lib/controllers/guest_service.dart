import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/guest.dart';

class GuestService{
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('guest');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addGuest(Guest guest) {
    return collection.add(guest.toFireStore());
  }

  void updateGuest(Guest guest) {
     collection.doc(guest.referenceId).update(guest.toFireStore());
  }

  void deleteGuest(Guest guest) async {
    await collection.doc(guest.referenceId).delete();
  }
}




