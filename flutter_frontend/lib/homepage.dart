import 'package:flutter/material.dart';
import 'package:flutter_frontend/search.dart';
import 'package:flutter_frontend/user.dart';

class Homepage extends StatelessWidget {
  final User user;
  Homepage({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(201, 30, 30, 90),
        appBar: AppBar(
          title: Center(child: Text('Mein Account')),
          backgroundColor: Color.fromRGBO(201, 30, 30, 100),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1.0),
                      border: Border.all(width: 3),
                    ),
                      child: Image.network(
                        "https://a.espncdn.com/combiner/i?img=/i/headshots/mma/players/full/4292650.png&w=350&h=254",
                        width: 350,
                        height: 350,
                        fit: BoxFit.fitHeight,

                 ))),
                Text('Mein Username: ' + user.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                )),
                Text('ID: ' + user.id,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
                Text('Meine E-Mail: ' + user.email,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                )),
                Text('Konto existiert seit dem ' + user.createdAt.day.toString() + "-" + user.createdAt.month.toString() + "-" + user.createdAt.year.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
          ],
        )));
  }
}
