import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/guest_service.dart';
import 'package:meal_planner/views/add_guest_view.dart';
import '../controllers/share.dart';
import '../fragments/app_bar.dart';
import '../fragments/drawer.dart';
import '../models/guest.dart';

class GuestListView extends StatefulWidget {
  const GuestListView({Key? key}) : super(key: key);

  @override
  State<GuestListView> createState() => _GuestListViewState();
}

class _GuestListViewState extends State<GuestListView> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    var savedData =  FirebaseFirestore.instance.collection('guest').where('userId',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid).withConverter(
        fromFirestore: Guest.fromFireStore,
        toFirestore: (Guest guest,_) => guest.toFireStore()).snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: width < 500 ? leftAlignAppBarTitle() : centerAlignAppBarTitle(),
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
          IconButton(onPressed: (){
            printDoc("SHARE", 'shopping-list', null, null, null);
          }, icon: const Icon(Icons.download_for_offline)),
        ],
      ),
      backgroundColor: Colors.lime[50],
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot<Guest>>(
          stream: savedData,
          builder: (context, snapshot) {
            List<QueryDocumentSnapshot<Guest>> guests = snapshot.data!.docs;
            return ListView.builder(
              itemCount: guests.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(guests.elementAt(index).data().name),
                    subtitle: Text(convertListToString(guests.elementAt(index).data().healthLabels)),
                    trailing: Row(
                      children: [
                        IconButton(onPressed:  (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>
                               AddGuest(guest: guests.elementAt(index).data())
                              )
                          );
                        }, icon: const Icon(Icons.edit)),
                        IconButton(onPressed:  (){
                          GuestService().deleteGuest(guests.elementAt(index).data());
                        }, icon: const Icon(Icons.delete)),
                      ],
                    ),
                  );
                });
          }
        ),
      ),
    );
  }
}
