import 'package:flutter/material.dart';
import 'package:meal_planner/views/meal%20plan/redirect_planner.dart';
import 'package:meal_planner/views/recipe/saved_recipes_view.dart';
import 'package:meal_planner/views/meal%20plan/shopping_list_view.dart';

import '../views/guest/guest_list_view.dart';
import '../views/recipe/home_view.dart';
import '../views/meal plan/planner_view.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 15.0;
    Color  fontColour = Colors.black26;
    Color  iconColour = Colors.lime;
    return  Drawer(
        child:ListView(
          children:  [
            const DrawerHeader(child: Icon(Icons.local_drink,size: 46)),
            ListTile(
              leading:Icon(Icons.home_filled, color: iconColour),
              title: Text(
                'H O M E',
                style: TextStyle(
                  fontSize: fontSize,
                  color: fontColour,
                ),
              ),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                    const HomeView()
                    )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark, color: iconColour),
              title: Text(
                'B O O K M A R K',
                style: TextStyle(
                  fontSize: fontSize,
                  color: fontColour,
                ),
              ),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                    const SavedRecipeView()
                    )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_task, color: iconColour),
              title: Text(
                'P L A N N E R',
                style: TextStyle(
                  fontSize: fontSize,
                  color: fontColour,
                ),
              ),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                    const RedirectPlanner()
                    )
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.perm_contact_cal, color: iconColour),
              title: Text(
                'G U E S T  L I S T',
                style: TextStyle(
                  fontSize: fontSize,
                  color: fontColour,
                ),
              ),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                        const GuestListView()
                    )
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.shopping_cart, color: iconColour),
            //   title: Text(
            //     'S H O P P I N G  L I S T',
            //     style: TextStyle(
            //       fontSize: fontSize,
            //       color: fontColour,
            //     ),
            //   ),
            //   onTap: (){
            //     Navigator.of(context).push(
            //         MaterialPageRoute(
            //             builder: (context) =>
            //             const ShoppingListView()
            //         )
            //     );
            //   },
            // ),
          ],
        )
    );
  }
}
