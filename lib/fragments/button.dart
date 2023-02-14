import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color? colour;
  final Color? textColour;
  final String buttonText;
  final double fontSize;
  final Function() buttonTapped;
  const Button({Key? key, required this.colour, required this.textColour, required this.buttonText, required this.fontSize, required this.buttonTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonTapped,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            color: colour,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                  child: Text(buttonText,
                  style: TextStyle(
                    color: textColour,
                    fontSize: fontSize
                  ),
                  ),
              ),
            )
          ),
        ),
      ),
    );
  }
}
