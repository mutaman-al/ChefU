import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myeatsapp/recipe_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myeatsapp/recipe_steps.dart';
import 'package:myeatsapp/search.dart';
import 'package:myeatsapp/settings.dart';


void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  bool toggled = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
          Text(
            'Chef-U',
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 40, color: Colors.white),

          ),
        ),
        body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            navigation(context, this.toggled),
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
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => SettingsScreen()));
                setState(() {
                  if(this.toggled == true){
                    this.toggled = false;
                  }else{
                    this.toggled = true;
                  }
                });
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
              icon: Icon(Icons.airline_seat_flat_angled),
              label: 'Color-Blind Mode',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      ),
    );
  }
}

Widget navigation(BuildContext context, bool colorBlindModeOn) {
  Color col;
  if (colorBlindModeOn == false){
  return Column(
    children: [
      Row(children: [
        buildCard("Daily", context,
            Colors.lightBlueAccent),
        buildCard("Quick", context, Colors.green),
      ]),
      Row(children: [
        buildCard("Medium", context, Colors.yellow),
        buildCard("Long", context, Colors.redAccent),
      ]),
    ],
  );
}
  else if(colorBlindModeOn == true){
    return Column(
      children: [
        Row(children: [
          buildCard("Daily", context,
              Colors.purple),
          buildCard("Quick", context, Colors.purple),
        ]),
        Row(children: [
          buildCard("Medium", context, Colors.purple),
          buildCard("Long", context, Colors.purple),
        ]),
      ],
    );
  }
}


Widget buildCard(text, BuildContext context, Color col) {

  return Center(
    child: Padding(
      padding: EdgeInsets.all(11.0),
      child: Card(
        color: col,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Raleway'),
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
