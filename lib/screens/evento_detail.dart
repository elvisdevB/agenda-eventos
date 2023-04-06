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
  BaseDatosHelper baseDatosHelper = BaseDatosHelper();

  Evento evento;
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController horaController = TextEditingController();

  //Hablar
  FlutterTts flutterTts = FlutterTts();

  //Speech
  bool _isListening = false;
  SpeechToText _speechToText;
  String _text = "";

  EventoDetailState(this.evento);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speechToText = SpeechToText();
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
            ],
          ),
        ),
        floatingActionButton: AvatarGlow(
            endRadius: 80,
            animate: _isListening,
            glowColor: Colors.teal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Diga guardar, o cancelar respectivamente"),
                SizedBox(height: 20),
                FloatingActionButton(
                  onPressed: () {
                    _listen();
                  },
                  child: Icon(
                    _isListening ? Icons.circle : Icons.mic,
                    size: 35,
                  ),
                ),
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _guardar() async {
    moveToLastScreen();

    evento.setFecha = fechaController.text;
    evento.setHora = horaController.text;

    int resultado;

    if (evento.getId != null) {
      resultado = await baseDatosHelper.editarEvento(evento);
    } else {
      resultado = await baseDatosHelper.insertarEvento(evento);
    }

    if (resultado != 0) {
      _showAlertDialog('Estado', 'Evento Guardado con Exito');
    } else {
      _showAlertDialog('Estado', 'Problemas al guardar el Evento');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
          });
        });
      }
    } else {
      setState(() {
        _isListening = false;
        _speechToText.stop();
      });
    }

    if (_isListening == false) {
      if (_text == "guardar") {
        _guardar();
      } else if (_text == "cancelar") {
        moveToLastScreen();
      }
    }
  }
}
