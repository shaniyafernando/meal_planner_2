import 'package:flutter/material.dart';
import 'package:meal_planner/fragments/text__field.dart';

import '../fragments/button.dart';

class ConverterView extends StatefulWidget {
  const ConverterView({Key? key}) : super(key: key);

  @override
  State<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<ConverterView> {
  final _inputController = TextEditingController();
  double symmetricHorizontalPadding = 0.25;
  List<String> selectionList = ['mg','g','kg','oz','lb','cup'];
  List<List<double>> conversionMatrix = [
    [1,	1000, 10000000,	28349.57291,	453597.0244,	236.4066194],
    [0.001,	1,	1000,	28.34949254,	453.5929094,	236.4066194],
    [0.0000001,	0.001,	1,	0.028349573,	0.453597024,	0.2015968],
    [0.0000352739,	0.035274,	35.2739,	1,	16,	8],
    [0.0000022046,	0.00220462,	2.2046,	0.0625,	1,	0.552486188],
    [201600,	0.00423,	4.960396197,	0.125,	1.81,	1]] ;

  @override
  void dispose(){
    _inputController.dispose();
    super.dispose();
  }

  Future convertMeasurement() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[700],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
                symmetricHorizontalPadding: symmetricHorizontalPadding,
                hintText: 'Enter an input here',
                controller: _inputController,
                obscureText: false),
            const SizedBox(height: 20.0,),
            DropdownField(
                selectionList: selectionList,
                symmetricHorizontalPadding: symmetricHorizontalPadding),
            const SizedBox(height: 50.0,),
            const Text('convert to'),
            const SizedBox(height: 50.0,),
            DropdownField(
                selectionList: selectionList,
                symmetricHorizontalPadding: symmetricHorizontalPadding),
            const SizedBox(height: 20.0,),
            Button(
                colour: Colors.lime[100],
                textColour: Colors.black54,
                buttonText: 'Convert',
                fontSize: 16.0,
                buttonTapped: convertMeasurement),
          ],
        ),
      ),
    );
  }
}

