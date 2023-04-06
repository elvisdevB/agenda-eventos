import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

FlutterTts flutterTts = FlutterTts();

Future hablar(String frase) async {
  await flutterTts.setLanguage("es-MX");
  await flutterTts.setPitch(1.0);
  await flutterTts.setSpeechRate(0.5);

  await flutterTts.speak(frase);
}
