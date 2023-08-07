import 'package:flutter/material.dart';
import 'package:proj_my_ninja_api/layanans/layanans.dart';
import 'package:proj_my_ninja_api/layanans/stream_socket.dart';
import 'package:proj_my_ninja_api/models/ninja.dart';
import 'package:proj_my_ninja_api/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:badges/badges.dart' as badges;
/*import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';*/

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  // state management
  late List<Ninja> futureListNinjas;
  late String _refreshMode;
  late String _operationMode;
  late String _ninjaSearched;

  // controller(s)
  final TextEditingController _controllerCari = TextEditingController();

  // koneksi ke ws
  /*final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse("ws://10.0.2.2:4000"),
  );*/

  /*final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse("wss://s9712.sgp1.piesocket.com/v3/1?api_key=nKYjkPApJKEBt6LbAonsI4x4ykAICQzyDBV91ux4&notify_self=1"),
  );*/

  late StreamSocket _streamSocket;
  late Stream<String> _streamNinja;

  // IO.Socket socket = IO.io("http://10.0.2.2:4000");
  IO.Socket socket = IO.io(
    'http://10.0.2.2:4000',
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build()
  );

  void connectAndListen() {
    socket.connect();

    socket.onConnect((_) {
      print('connecting');
      socket.emit('connection', 'hai');
    });

    /* listener untuk hubungan */
    socket.on("hubungan", (data) {
      print("server response: $data");
      _streamSocket.addResponse(data);
    });

    /* listener untuk pesan */
    socket.on("pesan", (data) {
      print("pesan dari server: $data");
      _streamSocket.addResponse(data);
    });

    socket.onDisconnect((_) => print('disconnect'));
  }
  
  void sendingMessage(String stringMessage) {
    socket.emit("pesan", stringMessage);
    _streamSocket.addResponse(stringMessage);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureListNinjas = [];
    _refreshMode = "refreshing";
    _operationMode = "toStart";
    _ninjaSearched = "";

    _streamSocket = StreamSocket();
    connectAndListen();
    setState(() {
      _streamNinja = _streamSocket.getResponse;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _channel.sink.close();
    _streamSocket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // state management
    futureListNinjas = Provider.of<List<Ninja>>(context, listen: true);
    // print(futureListNinjas);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: Text(
          "My Ninja API",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Row(
            children: <Widget>[
              const Text("Refresh di sini.."),
              const SizedBox(
                width: 8.0,
              ),
              IconButton(
                  onPressed: () {
                    // print("refreshing..");
                    Layanan().fetchNinjas().then((value) {
                      setState(() {
                        _operationMode = "toRefresh";
                        _refreshMode = "refreshing";
                        _controllerCari.text = "";

                        // response notified
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Menyegarkan data..")
                          ),
                        );
                      });
                    });
                  },
                  icon: const Icon(Icons.refresh)
              )
            ],
          ),

          StreamBuilder(
            stream: _streamNinja,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              print("data dari snapshot ${snapshot.data.toString()}");
              return badges.Badge(
                badgeContent: Text(
                  /*(snapshot.data.toString() == "1")
                    ? snapshot.data.toString()
                    : ""*/
                  snapshot.data.toString()
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.yellow,
                ),
                position: badges.BadgePosition.topEnd(
                    top: 1,
                    end: 1
                ),
                stackFit: StackFit.loose,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // pencarian
            Card(
              elevation: 8.0,
              margin: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                physics: const ScrollPhysics(),
                child: Form(
                  child: Row(
                    children: <Widget>[
                      // cari textBox
                      Flexible(
                        flex: 6,
                        child: TextFormField(
                          controller: _controllerCari,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: "Cari Ninja di sini..",
                            // filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),

                      Flexible(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            // print("searching..");
                            setState(() {
                              _refreshMode = "searching";
                              _ninjaSearched = _controllerCari.text;
                            });
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),

                      Flexible(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {
                            // clearing
                            // print("clearing..");
                            setState(() {
                              _controllerCari.text = "";
                              _refreshMode = "refreshing";
                            });
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // grid list
            FutureBuilder<List<Ninja>>(
              future: (_refreshMode == "refreshing")
                ? Layanan().fetchNinjas()
                : Layanan().searchNinja(_controllerCari.text),
              initialData: futureListNinjas,
              builder: (BuildContext context, AsyncSnapshot<List<Ninja>> snapshot) {
                if (snapshot.hasData || snapshot.data != null) {
                  futureListNinjas = snapshot.data!.toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    physics: const ScrollPhysics(),
                    child: ListView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(futureListNinjas[index].name.toString()),
                          subtitle: Text(futureListNinjas[index].rank.toString()),
                          trailing: Text("Is available? ${futureListNinjas[index].isAvailable}"),
                          onTap: () {
                            // method untuk fetching
                            Layanan().fetchNinja(futureListNinjas[index].id.toString());

                            Navigator.pushNamed(
                              context,
                              "/formNinja",
                              arguments: Ninja(
                                  id: futureListNinjas[index].id.toString(),
                                  name: futureListNinjas[index].name.toString(),
                                  rank: futureListNinjas[index].rank.toString(),
                                  isAvailable: futureListNinjas[index].isAvailable,
                                  version: futureListNinjas[index].version,
                                  operationMode: "toUpdate"
                              ),
                            ).whenComplete(() {
                              setState(() {
                                _operationMode = "toUpdate";
                                _refreshMode = "refreshing";
                              });

                            });

                          },
                          tileColor: (index.isEven) ? Colors.blueGrey[100] : Colors.transparent,
                        );
                      },
                      itemCount: futureListNinjas.length,
                    ),
                  );
                }

                return const Center(
                  child: Loading(),
                );

              },
            ),

            ButtonBar(
              alignment: MainAxisAlignment.end,
              children: <ElevatedButton>[
                // tambah anggota ninja
                ElevatedButton(
                  onPressed: () {
                    // proses penyimpanan data
                    Navigator.pushNamed(
                      context,
                      "/formNinja",
                      arguments: Ninja(
                          id: "",
                          name: "",
                          rank: "",
                          isAvailable: false,
                          version: 0,
                          operationMode: "toSave"
                      ),
                    ).whenComplete(() {
                      // sending message to ws
                      sendingMessage("add");

                      // to refresh the grid
                      setState(() {
                        _operationMode = "toSave";
                        _refreshMode = "refreshing";
                        _streamNinja = _streamSocket.getResponse;
                      });
                    });
                  },
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.add),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text("Tambah anggota ninja"),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(Icons.person),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

