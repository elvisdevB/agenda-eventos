import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navegar_voz/screens/hablar.dart';
import 'package:navegar_voz/util/basedatos_helper.dart';
import 'package:navegar_voz/model/evento.dart';
import 'package:sqflite/sqflite.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'evento_detail.dart';

class EventoLista extends StatefulWidget {
  BaseDatosHelper baseDatosHelper = BaseDatosHelper();
  List<Evento> eventoLista;

  @override
  State<EventoLista> createState() => EventoListaState();
}

class EventoListaState extends State<EventoLista> {
  BaseDatosHelper baseDatosHelper = BaseDatosHelper();
  List<Evento> eventoLista;
  Evento evento;
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (eventoLista == null) {
      eventoLista = List<Evento>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
      ),
      body: getNoteListView(),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(this.eventoLista[position].getNombre),
            subtitle: Text(this.eventoLista[position].getFecha +" "+
                this.eventoLista[position].getHora),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onTap: () {
                _delete(context, eventoLista[position]);
              },
            ),
          ),
        );
      },
    );
  }

  void navigateToDetail(Evento evento) async {
    bool resultado =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EventoDetail(evento);
    }));

    if (resultado == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = baseDatosHelper.iniciarBasedatos();
    dbFuture.then((database) {
      Future<List<Evento>> eventoListFuture = baseDatosHelper.getNoteList();

      eventoListFuture.then((eventoLista) {
        setState(() {
          this.eventoLista = eventoLista;
          this.count = eventoLista.length;
        });
      });
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _delete(BuildContext context, Evento evento) async {
    int result = await baseDatosHelper.eliminarEvento(evento.getId);
    if (result != 0) {
      _showSnackBar(context, 'Evento eliminado con exito');
      updateListView();
    }
  }
}
