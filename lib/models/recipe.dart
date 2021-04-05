import 'package:flutter/foundation.dart';

class Recipe{

   String url,image,label,source;

  Recipe({this.url, this.image, this.label, this.source});

  factory Recipe.fromMap(Map<String,dynamic> jsonData){
    return Recipe(
      url: jsonData["url"],
      image: jsonData["image"],
      label: jsonData["label"],
      source: jsonData["source"],
    );
   }
}