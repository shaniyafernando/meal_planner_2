import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_planner/controllers/bookmark_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../controllers/share.dart';
import '../../models/recipe.dart';

class RecipeDetailView extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailView({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  final Completer<WebViewController> _completer = Completer<WebViewController>();
  BookmarkController bookmarkController = BookmarkController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lime,
          title: const Text('foodnertize') ,
          centerTitle: true,
          actions: [
            IconButton(onPressed: (){ bookmarkController.addRecipe(widget.recipe);}, icon: const Icon(Icons.bookmark_add)),
            IconButton(onPressed: (){printDoc("SHARE", 'recipe', null,null,widget.recipe);}, icon: const Icon(Icons.download_for_offline)),

          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebView(
            initialUrl: widget.recipe.url ,
            onWebViewCreated: ((WebViewController webViewController){
              _completer.complete(webViewController);
            }),
          ),
        )
    );
  }

}



