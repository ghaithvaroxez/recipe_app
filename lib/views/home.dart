import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/views/recipeview.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _text;
  TextEditingController textEditingController = new TextEditingController();
  List<Recipe> recipes=new List<Recipe>
    ();

  getRecipes(String query) async {
    recipes.clear();
    String url =
        "https://api.edamam.com/search?q=$query&app_id=063d87fc&app_key=e73e40b5573307d6130221f86469ba68&from=0&to=3&calories=591-722&health=alcohol-free";
    var response = await http.get(url);
    Map<String, dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element) {
      Recipe recipe = new Recipe();
      recipe = Recipe.fromMap(element["recipe"]);
      recipes.add(recipe);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipes("juice");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xff213A50),
                Color(0xff071930),
              ])),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Varoxez",
                          style: GoogleFonts.aBeeZee(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Rexipes",
                          style: GoogleFonts.aBeeZee(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "What will you cock today?",
                      style: GoogleFonts.wireOne(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Just Enter ingredients you have and we will show best recipes for you",
                      style: GoogleFonts.wireOne(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter Ingredients",
                                hoverColor: Colors.white70,
                                fillColor: Colors.white70,
                                focusColor: Colors.white70,
                              ),
                              onChanged: (value) {
                                _text = value;
                              },
                              cursorColor: Colors.yellow.shade800,
                              controller: textEditingController,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                if (textEditingController.text.isNotEmpty) {
                                  getRecipes(textEditingController.text);
                                }
                              },
                              child: Container(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white70,
                                ),
                                color: Colors.yellow.shade800,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisSpacing: 10,
                      ),
                      children: List.generate(recipes.length!=0?recipes.length:0, (index) {
                        return RecipeTile(
                          title: recipes[index].label,
                          desc: recipes[index].source,
                          imgUrl: recipes[index].image,
                          url: recipes[index].url,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            print(widget.url + " this is what we are going to see");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipeView(
                          postUrl: widget.url,
                        )));
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
