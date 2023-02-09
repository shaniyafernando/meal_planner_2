import 'package:flutter/material.dart';
import 'package:meal_planner/fragments/shopping_category.dart';
import '../controllers/share.dart';
import '../fragments/drawer.dart';

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String,List<String>> map = {
      'Vegetable' : ["100g scallions"],
      'Dairy' : ["50g butter"],
      "Meat/Fish" : ["400g fish filet"],
    };



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: const Text('foodnertize'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            printDoc("SHARE", 'shopping-list', map, null, null);
          }, icon: const Icon(Icons.download_for_offline)),
        ],
      ),
      backgroundColor: Colors.lime[50],
      drawer: const CustomDrawer(),
      body: Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 20.0),
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text("Vegetable", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("100g scallions"),
                          SizedBox(height: 40,),
                          Text("Dairy", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("50g butter"),
                          SizedBox(height: 40,),
                          Text("Meat/Fish", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("400g fish filet"),
                          SizedBox(height: 40,),
                        ],
                    ),
                  );
                }),
          )
    );
  }
}
