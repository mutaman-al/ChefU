// SecondScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeList extends StatefulWidget {
  final String screenTitle;
  // ignore: non_constant_identifier_names
  RecipeList(this.screenTitle, {Key, key}) : super(key: key);

  @override
  State createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.screenTitle,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
            color: Colors.red,
          ),
        ],
      ),
      body: ListView(
        children: [
          recipes(widget.screenTitle),
          ElevatedButton(
            child: Text('Back To HomeScreen'),
            onPressed: () => {
              FirebaseFirestore.instance
                  .collection(widget.screenTitle)
                  .add({'title': 'data added through app'}),
            }, //Navigator.pop(context)),
          ),
        ],
      ),
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

Widget recipes(String type) {
  CollectionReference ref = FirebaseFirestore.instance.collection(type);
  Future data = getData(ref);
  print(data);
  return FutureBuilder<List>(
    future: data, // async work
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Text('Loading....');
        default:
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          else
            return Text('Result: ${snapshot.data}');
      }
    },
  );
}

Future<List> getData(CollectionReference ref) async {
  QuerySnapshot querySnapshot = await ref.get();

  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return allData;
}

Widget recipeCard = Container(
  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
  height: 220,
  width: double.maxFinite,
  child: Card(
    elevation: 5,
  ),
);
