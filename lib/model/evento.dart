class Evento {
  int _id;
  String _nombre;
  String _fecha;
  String _hora;

  Evento(this._nombre, this._fecha, this._hora);

  Evento.withId(this._id, this._nombre, this._fecha, this._hora);

  int get getId => _id;
  String get getNombre => _nombre;
  String get getFecha => _fecha;
  String get getHora => _hora;

  set setNombre(String newEvento) {
    this._nombre = newEvento;
  }

  set setFecha(String newDate) {
    this._fecha = newDate;
  }

  set setHora(String newHora) {
    this._hora = newHora;
  }

  //Convertir a un objeto Map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (getId != null) {
      map['id'] = _id;
    }
    map['nombre'] = _nombre;
    map['fecha'] = _fecha;
    map['hora'] = _hora;

    return map;
  }

  //Extraer el objeto map
  Evento.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nombre = map['nombre'];
    this._fecha = map['fecha'];
    this._hora = map['hora'];
  }
}
