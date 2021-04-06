import 'dart:io';
import 'package:contact_list/db/person.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../personPage.dart';

enum OrderOptions { orderaz, orderza }

class PeopleTab extends StatefulWidget {
  @override
  _PeopleTabState createState() => _PeopleTabState();
}

class _PeopleTabState extends State<PeopleTab> {
  PersonHelper db = PersonHelper();

  List<Person> persons = <Person>[];

  @override
  void initState() {
    super.initState();

    _getAllPersons();
  }

  void _getAllPersons() {
    db.getAllPersons().then((list) {
      setState(() {
        persons = list;
      });
    });
  }

  Widget _personCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: persons[index].img != null
                          ? FileImage(File(persons[index].img))
                          : AssetImage("images/no_image.png")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      persons[index].name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    Text(
                      persons[index].description ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      persons[index].phone ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        child: Text(
                          "Call",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          launch("tel:${persons[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showPersonPage(person: persons[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          db.deletePerson(persons[index].id);
                          setState(() {
                            persons.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _showPersonPage({Person person}) async {
    final recPerson = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PersonPage(person: person)));

    if (recPerson != null) {
      if (person != null) {
        await db.updatePerson(recPerson);
        _getAllPersons();
      } else {
        await db.savePerson(recPerson);
      }
      _getAllPersons();
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        persons.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        persons.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persons"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Z-A"),
                value: OrderOptions.orderza,
              )
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPersonPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: persons.length,
          itemBuilder: (context, index) {
            return _personCard(context, index);
          }),
    );
  }
}
