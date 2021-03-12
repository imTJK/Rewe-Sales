import 'package:flutter/material.dart';
import 'package:flutter_frontend/products.dart';

class DataSearch extends SearchDelegate<String> {
  final List<String> list = List.generate(10, (index) => "Text $index");
  List recentList = [];
  Product selectedResult;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
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
    return Container(
      child: Center(
        child: ListTile(
          title: Text("Wack"),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(201, 30, 30, 1),
        body: FutureBuilder(
          future: fetchProduct(
              {"name": query, "plz": "28213", "category": "nahrungsmittel"},
              10,
              0),
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
