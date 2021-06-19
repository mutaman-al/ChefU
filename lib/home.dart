import 'package:flutter/material.dart';
import 'package:myeatsapp/recipe_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myeatsapp/recipe_steps.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ChefU'),
        ),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            navigation(context),
            Padding(
              padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
              child: Text(
                "Discovery",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            rowList("Medium"),
            Padding(
              padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
              child: Text(
                "Subscribed",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            rowList("Daily")
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
      ),
    );
  }
}

Widget navigation(BuildContext context) {
  return Column(
    children: [
      Row(children: [
        buildCard("Daily", context),
        buildCard("Quick", context),
      ]),
      Row(children: [
        buildCard("Medium", context),
        buildCard("Long", context),
      ]),
    ],
  );
}

Widget buildCard(text, BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.all(11.0),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.');
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RecipeList(text)));
          },
          child: SizedBox(
            width: 165,
            height: 100,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget rowList(String type) {
  CollectionReference ref = FirebaseFirestore.instance.collection(type);
  Future data = getDataCollection(ref);
  return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 11.0),
      height: 220.0,
      child: FutureBuilder(
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
                    scrollDirection: Axis.horizontal,
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
                                      builder: (context) => RecipeSteps(type,
                                          '${snapshot.data[index]['Title']}')));
                            },
                            child: Column(children: [
                              Text(
                                snapshot.data[index]['Title'],
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                                height: 170,
                                                width: 200,
                                                fit: BoxFit.cover,
                                              )),
                                          alignment: Alignment.center,
                                        );
                                  }
                                },
                              ),
                            ])),
                      );
                    });
          }
        },
      ));
}
