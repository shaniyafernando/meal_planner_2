import 'package:flutter/material.dart';
import 'package:meal_planner/views/meal%20plan/planner_mobile_view.dart';
import 'package:meal_planner/views/meal%20plan/planner_view.dart';

class RedirectPlanner extends StatelessWidget {
  const RedirectPlanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width < 500){
      return const PlannerMobileView();
    }else{
      return const PlannerView();
    }
  }
}
