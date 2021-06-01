// SecondScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myeatsapp/recipe_steps.dart';

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
      body: Container(child: recipes(widget.screenTitle)),
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

  //Visual stuff & widgets
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
            return ListView.builder(
                itemCount: int.parse('${snapshot.data.length}'),
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        print('Card tapped.');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeSteps(
                                    type, '${snapshot.data[index]['Title']}')));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 250,
                            height: 100,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                '${snapshot.data[index]['Title']}\n\n${snapshot.data[index]['Description']}',
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: getImage(
                                snapshot.data[index]['Title'] + ".jpg"),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Text('Loading....');
                                default:
                                  if (snapshot.hasError)
                                    return Text('Error: ${snapshot.error}');
                                  else
                                    return Image.network(snapshot.data);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
      }
    },
  );
}

Future<List> getData(CollectionReference ref) async {
  QuerySnapshot querySnapshot = await ref.get();
  /*var doc_ref = await FirebaseFirestore.instance.collection("Medium").get();
  doc_ref.docs.forEach((result) {
    print(result.id);
  });*/

  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return allData;
}

Future<String> getImage(String image) async {
  print(image);
  Reference ref = FirebaseStorage.instance.ref().child(image);
  String url = (await ref.getDownloadURL()).toString();
  print(url);
  return url;
}

/*ElevatedButton(
            child: Text('Back To HomeScreen'),
            onPressed: () => {
              FirebaseFirestore.instance
                  .collection(widget.screenTitle)
                  .add({'title': 'data added through app'}),
            }, //Navigator.pop(context)),
          ),*/
