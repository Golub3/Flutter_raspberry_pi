import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String personTable = "personTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String descriptionColumn = "descriptionColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class PersonHelper {
  static final PersonHelper _instance = PersonHelper.internal();

  factory PersonHelper() => _instance;

  PersonHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "personsnew.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $personTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $descriptionColumn TEXT,"
          "$phoneColumn TEXT, $imgColumn TEXT)");
    });
  }

  Future<Person> savePerson(Person person) async {
    Database dbPerson = await db;
    person.id = await dbPerson.insert(personTable, person.toMap());
    return person;
  }

  Future<Person> getPerson(int id) async {
    Database dbPerson = await db;
    List<Map> maps = await dbPerson.query(personTable,
        columns: [
          idColumn,
          nameColumn,
          descriptionColumn,
          phoneColumn,
          imgColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Person.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletePerson(int id) async {
    Database dbPerson = await db;
    return await dbPerson
        .delete(personTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updatePerson(Person person) async {
    Database dbPerson = await db;
    return await dbPerson.update(personTable, person.toMap(),
        where: "$idColumn = ?", whereArgs: [person.id]);
  }

  Future<List> getAllPersons() async {
    Database dbPerson = await db;
    List listMap = await dbPerson.rawQuery("SELECT * FROM $personTable");
    List<Person> listPerson = <Person>[];

    for (Map m in listMap) {
      listPerson.add(Person.fromMap(m));
    }

    return listPerson;
  }

  Future<int> getNumber() async {
    Database dbPerson = await db;
    return Sqflite.firstIntValue(
        await dbPerson.rawQuery("SELECT COUNT(*) FROM $personTable"));
  }

  Future close() async {
    Database dbPerson = await db;
    dbPerson.close();
  }
}

class Person {
  int id;
  String name;
  String description;
  String phone;
  String img;

  Person();

  Person.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    description = map[descriptionColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      descriptionColumn: description,
      phoneColumn: phone,
      imgColumn: img
    };

    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Person(id: $id, name: $name, description: $description, phone: $phone, img: $img)";
  }
}
