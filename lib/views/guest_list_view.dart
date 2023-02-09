import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/authentication_service.dart';
import '../controllers/share.dart';
import '../fragments/app_bar.dart';
import '../fragments/drawer.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: width < 500 ? leftAlignAppBarTitle() : centerAlignAppBarTitle(),
        actions: [
          IconButton(
              onPressed: () {
                AuthenticationService(FirebaseAuth.instance).signOut(context);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text("Shaniya Fernando", style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("wheat-free, dairy-free"),
            SizedBox(height: 40,),
            Text("Diren Fernando", style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("wheat-free, kosher"),
            SizedBox(height: 40,),
            Text("Avani Fernando", style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("vegan"),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
