import 'dart:async';

class StreamSocket {
  // properti(es)
  final _streamController = StreamController<String>();

  // method(s)
  void addResponse(String stringMessage) {
    return _streamController.sink.add(stringMessage);
  }

  Stream<String> get getResponse {
    try {
      return _streamController.stream;

    } catch(err) {
      throw Exception(err);
    }
  }

  void dispose() {
    _streamController.close();
  }
}