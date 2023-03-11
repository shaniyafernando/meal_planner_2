import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/guest_controller.dart';
import 'package:meal_planner/models/lists.dart';
import 'package:meal_planner/views/guest/guest_list_view.dart';
import 'package:multiselect/multiselect.dart';

import '../../fragments/button.dart';
import '../../models/guest.dart';

class AddGuest extends StatefulWidget {
  final Guest? guest;
  const AddGuest({Key? key,  this.guest}) : super(key: key);

  @override
  State<AddGuest> createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> {
  List<String> selectedHealthLabels = [];
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double symmetricHorizontalPadding = 25.0;
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    if(widget.guest != null){
      nameController.text = widget.guest!.name;
    }

    if(width < 500){
      symmetricHorizontalPadding;
    }else if(width < 900){
      symmetricHorizontalPadding = 100.0;
    }else if(width < 1100){
      symmetricHorizontalPadding = 200.0;
    }else if(width < 1280){
      symmetricHorizontalPadding = 300.0;
    }else{
      symmetricHorizontalPadding = 400.0;
    }

    return Scaffold(
        backgroundColor: Colors.lime[50],
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0,),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.lime[50],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name", hintStyle: TextStyle(color: Colors.grey)
                          ),
                        )
                    )
                ),
                const SizedBox(height: 20.0,),
                DropDownMultiSelect(
                  onChanged: (List<String> x) {
                    setState(() {
                      selectedHealthLabels = x;
                    });
                  },
                  options: healthMap.keys.toList(),
                  selectedValues: selectedHealthLabels,
                  whenEmpty: 'Select Health Labels',
                ),
                const SizedBox(height: 50.0,),
                Button(
                    colour: Colors.orange,
                    textColour: Colors.white,
                    buttonText: "Save",
                    fontSize: 16.0,
                    buttonTapped: (){
                      if(widget.guest != null ){
                        GuestController().updateGuest( Guest(
                            name: nameController.text.trim(),
                            healthLabels: selectedHealthLabels,
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            referenceId: widget.guest!.referenceId
                        ));
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                                const GuestListView()
                            )
                        );
                      }else{
                        GuestController().addGuest( Guest(
                            name: nameController.text.trim(),
                            healthLabels: selectedHealthLabels,
                            userId: FirebaseAuth.instance.currentUser!.uid));
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                            const GuestListView()
                            )
                        );
                      }
                    })
              ]
          ),
        )
    );
  }
}
