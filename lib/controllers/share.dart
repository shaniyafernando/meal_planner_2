
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/guest.dart';
import '../models/recipe.dart';

// class ShareModelView{

  convertListToString(List<dynamic> list) {
    String line = list.toString();
    int i = line.length;
    return line.substring(1, i - 1);
  }

  buildRecipePdfContent(Recipe recipe) {
    String source = recipe.source ?? 'Not Available'; String url = recipe.url ?? 'Not Available';
    String numberOfServings = recipe.numberOfServings.toString(); String calories = recipe.calories.toString();
    String totalWeight = recipe.totalWeight.toString(); String dietLabels = convertListToString(recipe.dietLabels);
    String healthLabels = convertListToString(recipe.healthLabels); String mealType = convertListToString(recipe.mealType);
    String dishType = convertListToString(recipe.dishType);  String cuisineType = convertListToString(recipe.cuisineType);
    return pw.Padding(
        padding: const pw.EdgeInsets.all(25.0),
        child:
        pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
          pw.Text(recipe.label!), pw.SizedBox(height: 10.0),
          pw.Text("Source: $source"), pw.SizedBox(height: 10.0),
          pw.Text("Website: $url"), pw.SizedBox(height: 10.0),
          pw.Text("calories: $calories"),
          pw.SizedBox(height: 10.0), pw.Text("totalWeight: $totalWeight"),
          pw.SizedBox(height: 10.0), pw.Text("numberOfServings: $numberOfServings"),
          pw.SizedBox(height: 10.0), pw.Text("Diet Type: $dietLabels"),
          pw.SizedBox(height: 10.0), pw.Text("Health Requirements: $healthLabels"),
          pw.SizedBox(height: 10.0), pw.Text("Meal Type: $mealType"),
          pw.SizedBox(height: 10.0), pw.Text("Dish Type: $dishType"),
          pw.SizedBox(height: 10.0), pw.Text("Cuisine: $cuisineType"), pw.SizedBox(height: 10.0),
          pw.ListView.builder(
              itemBuilder: (context, index) {
                return pw.Padding(
                    padding: const pw.EdgeInsets.all(5.0),
                    child: pw.Text(recipe.ingredientLines[index]));
              },
              itemCount: recipe.ingredientLines.length)
        ]));
  }


  guestTile(Guest guest) {
    String name = guest.name;
    String healthReq = convertListToString(guest.healthLabels);
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(name),
        pw.SizedBox(height: 10.0),
        pw.Text("Health Requirements: $healthReq"),
        pw.SizedBox(height: 20.0),
      ],
    );
  }

  buildGuestListPdf(List<Guest> guests) {
    return pw.Padding(
        padding: const pw.EdgeInsets.all(25.0),
        child: pw.ListView.builder(
            itemBuilder: (context, index) {
              return guestTile(guests[index]);
            },
            itemCount: guests.length));
  }

  mealPlanTile(Recipe recipe, String noOfServings){
    String label = recipe.label!;
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text('Recipe: $label'),
        pw.SizedBox(height: 10.0),
        pw.Text('Number of servings: $noOfServings'),
        pw.SizedBox(height: 10.0),
        pw.Text('Leftovers:'),
        pw.SizedBox(height: 50.0),
      ],
    );
  }

  buildMealPlanPdf(Map map) {
    String date = '';
    List<String> items = [];

    map.forEach((key, value) { date = key;items = value; });

    return pw.Padding(
        padding: const pw.EdgeInsets.all(25.0),
        child:pw.ListView.builder(
            itemBuilder: (context, index) {
              return shoppingCategoryTile(date, items);
            },
            itemCount: map.length)
    );
  }


  shoppingCategoryTile(String key, List<String> values) {
    String category = key;
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(category),
        pw.SizedBox(height: 10.0),
        pw.ListView.builder(
            itemBuilder: (context, index) {
              return pw.Text(values[index]);
            },
            itemCount: values.length),
        pw.SizedBox(height: 20.0),
      ],);
  }

  buildShoppingListPdf(Map map) {
    return pw.ListView.builder(
            itemBuilder: (context, index) {
              return shoppingCategoryTile(map.keys.elementAt(index), map.values.elementAt(index));
            },
            itemCount: map.length
    );
  }


  Future<void> printDoc(String action, String component, Map? map, List<Guest>? guests, Recipe? recipe) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          if(component == "recipe"){
            return buildRecipePdfContent(recipe!);
          }
          else if(component == "meal-plan"){
            return buildMealPlanPdf(map!);
          }
          else if(component == "shopping-list"){
            return buildShoppingListPdf(map!);
          }
          else {
            return buildGuestListPdf(guests!);
          }
        }));
    if(action == 'SHARE'){
      await Printing.sharePdf(bytes: await doc.save(), filename: 'my-$component.pdf');
    }else{
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save());
    }
  }



// }


