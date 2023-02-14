import 'package:flutter/material.dart';

var textFieldBoxDecoration = BoxDecoration(
    color: Colors.lime[50],
    border: Border.all(color: Colors.white),
    // borderRadius: BorderRadius.circular(20.0)
);

class InputField extends StatelessWidget {
  final double symmetricHorizontalPadding;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  const InputField({Key? key, required this.symmetricHorizontalPadding,
    required this.hintText, required this.controller, required this.obscureText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: symmetricHorizontalPadding),
      child: Container(
          decoration: textFieldBoxDecoration,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextField(
                obscureText: obscureText,
                controller: controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText
                ),
              )
          )
      ),
    );
  }
}

class DropdownField extends StatefulWidget {
  final List<String> selectionList;
  final double symmetricHorizontalPadding;
  const DropdownField({Key? key, required this.selectionList, required this.symmetricHorizontalPadding}) : super(key: key);

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  @override
  Widget build(BuildContext context) {
    List<String> list = widget.selectionList ;
    String selectedValue = list.first;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.symmetricHorizontalPadding),
      child: Container(
          decoration: textFieldBoxDecoration,
          child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: DropdownButton(
                isExpanded: true,
                value: selectedValue,
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              )
          )
      ),
    );
  }
}

