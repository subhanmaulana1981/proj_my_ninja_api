import 'package:flutter/material.dart';
import 'package:proj_my_ninja_api/layanans/layanans.dart';
import 'package:proj_my_ninja_api/models/ninja.dart';
import 'package:proj_my_ninja_api/widgets/loading.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refreshMode = "refreshing";
    _operationMode = "toStart";
    _ninjaSearched = "";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // state management
    futureListNinjas = Provider.of<List<Ninja>>(context, listen: true);

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
                    print("refreshing..");
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

        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
                      flex: 4,
                      child: TextFormField(
                        controller: _controllerCari,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: "Cari Ninja di sini..",
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),

                    // cari tombol
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          print("searching..");
                          setState(() {
                            _refreshMode = "searching";
                            _ninjaSearched = _controllerCari.text;
                          });
                        },
                        child: const Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),

                    // clear tombol
                    Flexible(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          // clearing
                          print("clearing..");
                          setState(() {
                            _controllerCari.text = "";
                            _refreshMode = "refreshing";
                          });
                        },
                        child: const Icon(Icons.clear),
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
              print("building..");
              // print("datanya: ${snapshot.data!.toList()}");
              futureListNinjas = snapshot.data!.toList();
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Loading(),
                );
              }
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

                        /*showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: const Icon(Icons.info),
                          title: const Text("Informasi"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Text>[
                              Text("id: ${futureListNinjas[index].id.toString()}"),
                              Text("nama: ${futureListNinjas[index].name.toString()}"),
                              Text("rank: ${futureListNinjas[index].rank.toString()}"),
                              Text("available: ${futureListNinjas[index].isAvailable}"),
                              Text("version: ${futureListNinjas[index].version.toString()}"),
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(8.0),
                          actions: <TextButton>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Ok"),
                            ),
                          ],
                          actionsAlignment: MainAxisAlignment.center,
                        );
                      },
                    );*/

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
            },
          ),

          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: <ElevatedButton>[
              ElevatedButton(
                onPressed: () {
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
                    // to refresh the grid
                    setState(() {
                      _operationMode = "toSave";
                      _refreshMode = "refreshing";
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
      resizeToAvoidBottomInset: false,
    );
  }
}
