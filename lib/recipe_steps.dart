// SecondScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeSteps extends StatefulWidget {
  final String collectionTitle;
  final String recipeTitle;

  // ignore: non_constant_identifier_names
  RecipeSteps(this.collectionTitle, this.recipeTitle);

  @override
  State createState() => _RecipeStepsState();
}

class _RecipeStepsState extends State<RecipeSteps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipeTitle,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            color: Colors.red,
          ),
        ],
      ),
      body:
          Container(child: recipes(widget.collectionTitle, widget.recipeTitle)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Colors.amber[800],
      ),
    );
  }
}

Widget recipes(String type, String recipe) {
  CollectionReference ref = FirebaseFirestore.instance.collection(type);
  Future data = getData(ref, recipe);
  //print(data);

  //Visual stuff & widgets
  return FutureBuilder(
    future: data, // async work
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Text('Loading....');
        default:
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          else
            return ListView.builder(
                itemCount: int.parse('${snapshot.data['Steps'].length}'),
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Step ${index + 1}:\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                                Text(
                                  '${snapshot.data['Steps']['${index + 1}']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.volume_up),
                              color: Colors.red,
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.timer),
                              color: Colors.red,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                });
      }
    },
  );
}

Future getData(CollectionReference ref, String name) async {
  var document = await ref.doc(name).get();

  //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return document.data();
}
/*
for (var i = 1;
i <=
int.parse('${snapshot.data['Steps'].length}');
i++)
*/
