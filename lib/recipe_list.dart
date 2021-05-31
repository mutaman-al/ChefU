// SecondScreen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RecipeList extends StatefulWidget {
  final String screenTitle;
  // ignore: non_constant_identifier_names
  RecipeList(this.screenTitle, {Key, key}) : super(key: key);

  @override
  State createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Uint8List imageBytes;
  String errorMsg;

  _RecipeListState() {
    storage
        .ref()
        .child('image.jpg')
        .getData(10000000)
        .then((data) => setState(() {
              imageBytes = data;
            }))
        .catchError((e) => setState(() {
              errorMsg = e.error;
            }));
  }

  @override
  Widget build(BuildContext context) {
    var img = imageBytes != null
        ? Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          )
        : Text(errorMsg != null ? errorMsg : "Loading...");
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
      body: Container(child: recipes(widget.screenTitle, img)),
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

Widget recipes(String type, var thumbnail) {
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
                                builder: (context) =>
                                    RecipeList('Result: ${snapshot.data}')));
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
                          thumbnail,
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

  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return allData;
}

Future<List<Map<String, dynamic>>> _loadImages(String image) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  List<Map<String, dynamic>> files = [];

  final ListResult result = await storage.ref().list();
  final List<Reference> allFiles = result.items;

  await Future.forEach<Reference>(allFiles, (file) async {
    final String fileUrl = await file.getDownloadURL();
    files.add({
      "url": fileUrl,
    });
  });

  return files;
}

/*Future<void> _getImage() async {
  final ref = FirebaseStorage.instance.ref().child('image.png');
  var url = await ref.getDownloadURL();
  print(url);
  //Image.network(url);
}*/

/*ElevatedButton(
            child: Text('Back To HomeScreen'),
            onPressed: () => {
              FirebaseFirestore.instance
                  .collection(widget.screenTitle)
                  .add({'title': 'data added through app'}),
            }, //Navigator.pop(context)),
          ),*/
