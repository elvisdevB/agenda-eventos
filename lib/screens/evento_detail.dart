import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:navegar_voz/model/evento.dart';
import 'package:navegar_voz/util/basedatos_helper.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'hablar.dart';

class EventoDetail extends StatefulWidget {
  final Evento evento;

  EventoDetail(this.evento);

  @override
  State<EventoDetail> createState() {
    return EventoDetailState(this.evento);
  }
}

class EventoDetailState extends State<EventoDetail> {
  Evento evento;
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController horaController = TextEditingController();

  //Hablar
  FlutterTts flutterTts = FlutterTts();

  EventoDetailState(this.evento);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hablar("Por favor seleccione, la fecha y la hora");
  }

  @override
  Widget build(BuildContext context) {
    nombreController.text = evento.getNombre;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Crear Evento'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: nombreController,
                  onChanged: (value) {
                    debugPrint('Escriba un nombre del Evento');
                  },
                  decoration: InputDecoration(
                      labelText: 'Nombre del Evento',
                      icon: Icon(Icons.emoji_events),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),

              // Fecha
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: fechaController,
                  onTap: () async {
                    DateTime pickedData = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickedData != null) {
                      String formatoFecha = DateFormat.yMd().format(pickedData);

                      setState(() {
                        fechaController.text = formatoFecha.toString();
                      });
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Seleccione la Fecha',
                      icon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),

              // Hora
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: horaController,
                  onTap: () async {
                    TimeOfDay pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      String formatoHora =
                          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';

                      setState(() {
                        horaController.text = formatoHora.toString();
                      });
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Seleccione la Hora',
                      icon: Icon(Icons.timelapse),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),

              //Buttons
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Guardar'),
                        onPressed: () {
                          hablar("Hola mundo");
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          moveToLastScreen();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
