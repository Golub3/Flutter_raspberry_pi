import 'dart:io';
import 'package:contact_list/db/person.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PersonPage extends StatefulWidget {
  final Person person;

  PersonPage({this.person});

  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  Person _editedPerson;

  @override
  void initState() {
    super.initState();

    if (widget.person == null) {
      _editedPerson = Person();
    } else {
      _editedPerson = Person.fromMap(widget.person.toMap());
      _nameController.text = _editedPerson.name;
      _descriptionController.text = _editedPerson.description;
      _phoneController.text = _editedPerson.phone;
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Discard modifications?"),
              content: Text(
                  "Closing the page will result in modifications data loss"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedPerson.name ?? "New Person"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedPerson.name != null && _editedPerson.name.isNotEmpty) {
              Navigator.pop(context, _editedPerson);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedPerson.img != null
                            ? FileImage(File(_editedPerson.img))
                            : AssetImage("images/no_image.png")),
                  ),
                ),
                onTap: () {
                  // ignore: deprecated_member_use
                  ImagePicker.pickImage(
                    source: ImageSource.gallery,
                  ).then((file) {
                    if (file == null) {
                      return;
                    }

                    setState(() {
                      _editedPerson.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (value) {
                  _userEdited = true;
                  setState(() {
                    _editedPerson.name = value.isEmpty ? "New Person" : value;
                  });
                },
                focusNode: _nameFocus,
                controller: _nameController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Description"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedPerson.description = value;
                },
                controller: _descriptionController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (value) {
                  _userEdited = true;
                  _editedPerson.phone = value;
                },
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
