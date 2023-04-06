import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navegar_voz/screens/hablar.dart';
import 'package:navegar_voz/screens/speech.dart';
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
  bool isListening = false;
  String textSample = 'Click button to start recording';

  @override
  void initState() {
    super.initState();
    hablar("Pulse el boton de la parte posterior para agregar un evento");
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
      floatingActionButton: AvatarGlow(
        endRadius: 80,
        animate: isListening,
        glowColor: Colors.teal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pruebe decir 'crear evento'"),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () => {toggleRecording(context)},
              child: Icon(
                isListening ? Icons.circle : Icons.mic,
                size: 35,
              ),
            ),
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            subtitle: Text(this.eventoLista[position].getFecha +
                this.eventoLista[position].getHora),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }

  Future toggleRecording(BuildContext context) => Speech.toggleRecording(
      onResult: (String text) => setState(() {
            textSample = text;
          }),
      onListening: (bool isListening) {
        setState(() {
          this.isListening = isListening;
        });
        if (!isListening) {
          if (textSample == "crear evento") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EventoDetail(Evento("", "", ""))));
          }
        }
      });

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
}
