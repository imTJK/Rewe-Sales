import 'package:flutter/material.dart';
import 'package:flutter_frontend/products.dart';

class DropdownMenu extends StatefulWidget {
  final String category;
  DropdownMenu({this.category});

  @override
  _DropdownMenuState createState() => _DropdownMenuState(category: category);
}

class _DropdownMenuState extends State<StatefulWidget> {
  List<String> categories = ['Nahrungsmittel', 'Kappa', 'Rügenwalder Mühle'];
  String category;

  _DropdownMenuState({this.category});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: category,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          category = newValue.toLowerCase();
        });
        showSearch(context: context, delegate: DataSearch(category: category));
      },
      items: this.categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<String> list = List.generate(30, (index) => "Text $index");
  List recentList = [];
  Product selectedResult;
  String selectedCategory;
  String category;
  DataSearch({this.category});

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
      DropdownMenu(category: category),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(201, 30, 30, 1),
        body: FutureBuilder(
          future: fetchProduct(
              {"name": query, "plz": "28213", "category": category}, 30, 0),
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return GestureDetector(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                          child: ListTile(
                              title: Text(snapshot.data[index].name),
                              leading:
                                  Image.network(snapshot.data[index].imgSrc),
                              onTap: () {
                                if (!recentList
                                    .contains(snapshot.data[index])) {
                                  recentList.add(snapshot.data[index]);
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                        product: snapshot.data[index]),
                                  ),
                                );
                              }),
                          shadowColor: Colors.black);
                    }),
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                });
          },
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(201, 30, 30, 1),
        body: FutureBuilder(
          future: fetchProduct(
              {"name": query, "plz": "28213", "category": category}, 10, 0),
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return GestureDetector(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                          child: ListTile(
                              title: Text(snapshot.data[index].name),
                              onTap: () {
                                if (!recentList
                                    .contains(snapshot.data[index])) {
                                  recentList.add(snapshot.data[index]);
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                        product: snapshot.data[index]),
                                  ),
                                );
                              }),
                          shadowColor: Colors.black);
                    }),
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                });
          },
        ));
  }
}
