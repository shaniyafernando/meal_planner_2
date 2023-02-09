
import 'package:flutter/material.dart';
import '../style_fragments.dart';




leftAlignAppBarTitle(){
  return Text(
    'foodnertize',
    style: dosisFont(25.0),
  );
}

centerAlignAppBarTitle(){
  return Center(
      child: Text(
        'foodnertize',
        style: dosisFont(25.0),
      )
  );
}


class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  const CustomAppBar({Key? key, required this.preferredSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double currentWidth = preferredSize.width;
    return AppBar(
      backgroundColor: Colors.lime,
      title: currentWidth < 500 ? leftAlignAppBarTitle() : centerAlignAppBarTitle(),
      actions: [
         IconButton(
            onPressed: (){},
            icon: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.compare_arrows,color: Colors.lime,),
            )
        ),
        IconButton(
            onPressed: (){},
            icon: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.calculate_outlined,color: Colors.lime,),
            )
        ),
        IconButton(
            onPressed: (){},
            icon: const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.logout_outlined,color: Colors.lime,),
            )
        )
      ],
    );
  }




}
