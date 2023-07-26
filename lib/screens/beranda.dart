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
  late List<Ninja> futureListNinjas;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    futureListNinjas = Provider.of<List<Ninja>>(context, listen: true);
    String operationMode = "simpan";
    // print("build atas");

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
                    print("refresh..");
                    Layanan().fetchNinjas().then((value) {
                      setState(() {
                        futureListNinjas = value;
                      });
                    });
                  },
                  icon: const Icon(Icons.refresh)
              )
            ],
          ),

        ],
      ),
      body: FutureBuilder<List<Ninja>>(
        future: Layanan().fetchNinjas(),
        initialData: futureListNinjas,
        builder: (BuildContext context, AsyncSnapshot<List<Ninja>> snapshot) {
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

                    showDialog(
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
                    );

                    Navigator.pushNamed(
                      context,
                      "/formNinja",
                      arguments: Ninja(
                        id: futureListNinjas[index].id.toString(),
                        name: futureListNinjas[index].name.toString(),
                        rank: futureListNinjas[index].rank.toString(),
                        isAvailable: futureListNinjas[index].isAvailable,
                        version: futureListNinjas[index].version,
                        operationMode: "ubah"
                      ),
                    ).whenComplete(() {
                      Layanan().fetchNinjas().then((value) {
                        print("update..");
                        setState(() {
                          futureListNinjas = value;
                          operationMode = "ubah";
                        });
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
      floatingActionButton: ButtonBar(
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
                  operationMode: "simpan"
                ),
              ).whenComplete(() {
                // to refresh the grid
                Layanan().fetchNinjas().then((value) {
                  print("simpan..");
                  setState(() {
                    futureListNinjas = value;
                    operationMode = "simpan";
                  });
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
    );
  }
}
