import 'package:flutter/material.dart';
import 'package:proj_my_ninja_api/layanans/layanans.dart';
import 'package:proj_my_ninja_api/models/ninja.dart';
import 'package:proj_my_ninja_api/screens/beranda.dart';
import 'package:provider/provider.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/web_socket_channel.dart';

class Wrapper extends StatefulWidget {
  // final WebSocketChannel channel;

  // konstruktor
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  /*final _channel = WebSocketChannel.connect(
    Uri.parse("wss://echo.websocket.events"),
  );*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Dart client
    /*IO.Socket socket = IO.io('http://10.0.2.2:4000');
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));*/
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Ninja>>.value(
      value: Layanan().fetchNinjas(),
      initialData: const <Ninja>[],
      catchError: (BuildContext context, Object? listNinja) {
        return [];
      },
      child: const Beranda(),
      updateShouldNotify: (previous, current) {
        bool shouldNotify = (current != previous);
        return shouldNotify;
      },

    );
  }
}
