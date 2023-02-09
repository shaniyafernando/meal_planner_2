import 'package:flutter/material.dart';


loadingDialog(){
  return const Center(
    child: CircularProgressIndicator(),
  );
}

// Future<void> showInformationDialog(BuildContext context) async {
//   return await showDialog(
//       context: context,
//       builder: (context){
//         return AlertDialog(
//           content: ,
//           actions: [],
//         )
//       })
// }