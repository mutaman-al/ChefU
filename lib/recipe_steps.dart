// SecondScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myeatsapp/home.dart';
import 'package:myeatsapp/search.dart';
import 'package:myeatsapp/settings.dart';
import 'package:myeatsapp/video.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_test/flutter_test.dart';

class RecipeSteps extends StatefulWidget {
  final String collectionTitle;
  final String recipeTitle;

  // ignore: non_constant_identifier_names
  RecipeSteps(this.collectionTitle, this.recipeTitle);

  @override
  State createState() => _RecipeStepsState();
}

class _RecipeStepsState extends State<RecipeSteps> {
  int index = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipeTitle,
        ),
      ),
      body:
          Container(child: recipes(widget.collectionTitle, widget.recipeTitle)),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
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

Widget recipes(String type, String recipe) {
  CollectionReference ref = FirebaseFirestore.instance.collection(type);
  Future data = getData(ref, recipe);
  //print(data);

  FlutterTts tts = FlutterTts();

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
                                  key: Key("text" + index.toString()),
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
                              icon: Icon(Icons.timer),
                              color: Colors.red,
                            ),
                            IconButton(
                              onPressed: () async {
                                var finder = find.byKey(Key("text" + index.toString()));
                                var text = finder.evaluate().single.widget as Text;
                                await tts.speak(text.data);
                              },
                              icon: Icon(Icons.volume_up),
                              color: Colors.red,
                            ),
                            FutureBuilder(
                              future: getVideo(snapshot.data['Title'] +
                                  '/' +
                                  (index + 1).toString()),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshott) {
                                switch (snapshott.connectionState) {
                                  case ConnectionState.waiting:
                                    return Text('Loading....');
                                  default:
                                    if (snapshott.hasError)
                                      return Text('Error: ${snapshott.error}');
                                    else
                                      return IconButton(
                                        onPressed: () {
                                          print('Card tapped.');
                                          print(snapshott.data);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoScreen(
                                                          snapshott.data)));
                                        },
                                        icon: Icon(Icons.video_library),
                                        color: Colors.red,
                                      );
                                }
                              },
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

Future<String> getVideo(String video) async {
  Reference ref = FirebaseStorage.instance.ref().child(video + ".mp4");
  print(video);
  String url = (await ref.getDownloadURL()).toString();
  print(url);
  return url;
}
