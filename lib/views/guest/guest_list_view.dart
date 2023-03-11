import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/guest_controller.dart';
import 'package:meal_planner/views/guest/add_guest_view.dart';
import '../../controllers/share_controller.dart';
import '../../fragments/drawer.dart';
import '../../models/guest.dart';
import '../../utils.dart';

class GuestListView extends StatefulWidget {
  const GuestListView({Key? key}) : super(key: key);

  @override
  State<GuestListView> createState() => _GuestListViewState();
}

class _GuestListViewState extends State<GuestListView> {
  List<Guest> guestList = [];
  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot<Guest>>  savedData =  FirebaseFirestore.instance.collection('guest').where('userId',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid).withConverter(
        fromFirestore: Guest.fromFireStore,
        toFirestore: (Guest guest,_) => guest.toFireStore()).snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: const Text('foodnertize'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        const AddGuest()
                    )
                );
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )),
          IconButton(
              onPressed: () {
                ShareController().printDoc("DOWNLOAD", 'guest', null, guestList, null);
              },
              icon: const Icon(Icons.download_for_offline)),
          IconButton(
              onPressed: () {
                ShareController().printDoc("SHARE", 'guest', null,guestList, null);
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      backgroundColor: Colors.lime[50],
      drawer: const CustomDrawer(),
      body: StreamBuilder<QuerySnapshot<Guest>>(
        stream: savedData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<QueryDocumentSnapshot<Guest>> guests = snapshot.data!.docs;
            return ListView.builder(
                itemCount: guests.length,
                itemBuilder: (context, index){
                  Guest guest = Guest(
                      name: guests.elementAt(index).data().name,
                      healthLabels: guests.elementAt(index).data().healthLabels,
                      userId: guests.elementAt(index).data().userId,
                      referenceId: guests.elementAt(index).reference.id
                  );
                  guestList.add(guest);
                  return ListTile(
                    title: Text(guest.name),
                    subtitle: Text(convertListToString(guest.healthLabels)),
                    leading: IconButton(onPressed:  (){
                      GuestController().deleteGuest(guest);
                    }, icon: const Icon(Icons.delete)),
                    trailing: IconButton(onPressed:  (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>
                              AddGuest(guest: guest)
                          )
                      );
                    }, icon: const Icon(Icons.edit)),
                  );
                });
          }
          if(!snapshot.hasData){
            return const Center(child: Text('no data!'),);
          }
          if(snapshot.hasError){}
          return Center(child: Text("${snapshot.error}"),);
        }
      ),
    );
  }
}
