import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:navegar_voz/model/evento.dart';
import 'package:navegar_voz/screens/evento_detail.dart';
import 'package:navegar_voz/screens/hablar.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:highlight_text/highlight_text.dart';

import 'evento_listar.dart';

class SpeechScreen extends StatefulWidget {
  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
        onTap: () => print('flutter'),
        textStyle:
            const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
  };

  SpeechToText _speechToText;
  bool _isListening = false;
  String _text = "Presione el boton";
  double _confidence = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speechToText = SpeechToText();
    hablar("Precione el boton, y diga el nombre del evento");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(microseconds: 100),
          repeat: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Diga ver eventos, para ver la lista de eventos"),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                onPressed: () {
                  _listen(context);
                },
                child: Icon(_isListening ? Icons.circle : Icons.mic),
              ),
            ],
          )),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen(BuildContext context) async {
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
      if (_text == "ver eventos") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EventoLista()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventoDetail(Evento(_text, "", ""))));
      }
    }
  }
}
