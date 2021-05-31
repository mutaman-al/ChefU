import 'package:flutter/material.dart';
import 'package:myeatsapp/recipe_list.dart';

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
              ),
            ),
            rowList,
            Padding(
              padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
              child: Text(
                "Subscribed",
                textAlign: TextAlign.left,
              ),
            ),
            rowList
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
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget rowList = Container(
  margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 11.0),
  height: 200.0,
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: <Widget>[
      Container(
        width: 200.0,
        color: Colors.red,
      ),
      Container(
        width: 200.0,
        color: Colors.blue,
      ),
      Container(
        width: 200.0,
        color: Colors.green,
      ),
      Container(
        width: 200.0,
        color: Colors.yellow,
      ),
      Container(
        width: 200.0,
        color: Colors.orange,
      ),
    ],
  ),
);
