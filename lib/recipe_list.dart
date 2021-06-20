// SecondScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myeatsapp/home.dart';
import 'package:myeatsapp/recipe_steps.dart';
import 'package:myeatsapp/search.dart';

class RecipeList extends StatefulWidget {
  final String screenTitle;
  // ignore: non_constant_identifier_names
  RecipeList(this.screenTitle, {Key, key}) : super(key: key);

  @override
  State createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  int index = 0;
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
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
          switch (index) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
              break;
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
              break;
            case 2:
              Navigator.of(context).pushNamed('/history');
              break;
          }
        },
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
  Future data = getDataCollection(ref);

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
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${snapshot.data[index]['Title']}\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(
                                      '\n${snapshot.data[index]['Description']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
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
                                    return Align(
                                      child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Image.network(
                                            snapshot.data,
                                            height: 200,
                                            width: 400,
                                            fit: BoxFit.cover,
                                          )),
                                      alignment: Alignment.center,
                                    );
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

Future<List> getDataCollection(CollectionReference ref) async {
  QuerySnapshot querySnapshot = await ref.get();

  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

  return allData;
}

Future<String> getImage(String image) async {
  //print(image);
  Reference ref = FirebaseStorage.instance.ref().child(image);
  String url = (await ref.getDownloadURL()).toString();
  //print(url);
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
