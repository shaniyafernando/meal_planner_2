import 'package:date_ranger/date_ranger.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/fragments/button.dart';
import 'package:meal_planner/fragments/meal_plan_card.dart';
import 'package:meal_planner/views/shopping_list_view.dart';
import '../controllers/meal_plan_service.dart';
import '../fragments/drawer.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';

class PlannerView extends StatefulWidget {
  const PlannerView({Key? key}) : super(key: key);

  @override
  State<PlannerView> createState() => _PlannerViewState();
}

class _PlannerViewState extends State<PlannerView> {
  var initialDateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 5)));

  MealPlanService mealPlanService = MealPlanService();
  List<MealPlan> mealPlanList = [];

  @override
  void initState() {
    super.initState();
    mealPlanList = mealPlanService.getMealPlanByDateRange(initialDateRange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lime,
        title: const Text("foodnertize"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.download_for_offline)),
        ],
      ),
      backgroundColor: Colors.lime[50],
      drawer: const CustomDrawer(),
      body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.0,
                    width: 300.0,
                    child: Button(
                        colour: Colors.lime[700],
                        textColour: Colors.white,
                        buttonText: "Create a Meal Plan",
                        fontSize: 16.0,
                        buttonTapped: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ShoppingListView()));
                        }),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: 300.0,
                    child: DateRanger(
                      borderColors: Colors.orange[800],
                      errorColor: Colors.lime[800],
                      activeItemBackground: Colors.orange[900],
                      rangeBackground: Colors.orange[600],
                      backgroundColor: Colors.white,
                      initialRange: initialDateRange,
                      onRangeChanged: (range) {
                        setState(() {
                          initialDateRange = range;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                    width: 300.0,
                    child: Button(
                        colour: Colors.lime[700],
                        textColour: Colors.white,
                        buttonText: "Generate Shopping List",
                        fontSize: 16.0,
                        buttonTapped: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ShoppingListView()));
                        }),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                      itemCount: mealPlanList.length,
                      itemBuilder: (context, index) {
                        String getUpperCase(int i) {
                          if (i == 1 || i == 21 || i == 31) {
                            return 'st';
                          } else if (i == 2 || i == 22) {
                            return 'nd';
                          } else if (i == 3 || i == 23) {
                            return 'rd';
                          } else {
                            return 'th';
                          }
                        }

                        String date = mealPlanList[index].date!.day.toString();
                        String uppercase =
                            getUpperCase(mealPlanList[index].date!.day);
                        String weekday =
                            mealPlanList[index].date!.weekday.toString();
                        String month =
                            mealPlanList[index].date!.month.toString();
                        String year = mealPlanList[index].date!.year.toString();
                        String dateFormat =
                            "$weekday, $date$uppercase $month, $year";
                        List<Recipe>? recipes = mealPlanList[index].recipeIds;
                        return ListTile(
                            title: Text(dateFormat),
                            subtitle: ListView.builder(
                                itemCount: recipes!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return MealPlanCard(
                                      label: recipes[index].label!,
                                      noOfServings: recipes[index]
                                          .numberOfServings
                                          .toString());
                                }));
                      })),
            ],
          )),
    );
  }
}
