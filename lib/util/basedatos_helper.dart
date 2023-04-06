import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:navegar_voz/model/evento.dart';

class BaseDatosHelper {
  static BaseDatosHelper _baseDatosHelper;
  static Database _database;

  String eventoTable = 'evento';
  String colId = 'id';
  String colNombre = 'nombre';
  String colFecha = 'fecha';
  String colHora = 'hora';

  BaseDatosHelper._crearInstancia();

  factory BaseDatosHelper() {
    if (_baseDatosHelper == null) {
      _baseDatosHelper = BaseDatosHelper._crearInstancia();
    }

    return _baseDatosHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await iniciarBasedatos();
    }

    return _database;
  }

  Future<Database> iniciarBasedatos() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'evento.db';

    var eventoBasedatos =
        await openDatabase(path, version: 1, onCreate: _createDB);

    return eventoBasedatos;
  }

  void _createDB(Database db, int nerVersion) async {
    await db.execute(
        "CREATE TABLE $eventoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNombre TEXT, $colFecha TEXT, $colHora TEXT)");
  }

  Future<List<Map<String, dynamic>>> getNotMapList() async {
    Database db = await this.database;

    var resultado = await db.query(eventoTable);

    return resultado;
  }

  //Insertar en la base de datos
  Future<int> insertarEvento(Evento evento) async {
    Database db = await this.database;
    var resultado = await db.insert(eventoTable, evento.toMap());

    return resultado;
  }

  //Editar Operacion
  Future<int> editarEvento(Evento evento) async {
    var db = await this.database;
    var resultado = await db.update(eventoTable, evento.toMap(),
        where: '$colId = ?', whereArgs: [evento.getId]);

    return resultado;
  }

  //Operacion eliminar
  Future<int> eliminarEvento(int id) async {
    var db = await this.database;
    int resultado =
        await db.rawDelete('DELETE FROM $eventoTable WHERE $colId=$id');

    return resultado;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $eventoTable');

    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  //Obtener la lista de Mapa
  Future<List<Evento>> getNoteList() async {
    var noteMapList = await getNotMapList();
    int count = noteMapList.length;

    List<Evento> noteList = List<Evento>();
    for (int i = 0; i < count; i++) {
      noteList.add(Evento.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
