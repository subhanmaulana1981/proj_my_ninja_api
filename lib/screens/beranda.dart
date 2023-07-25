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
  late Future<List<Ninja>> futureListNinjas;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    Layanan().fetchNinjas();
                  },
                  icon: const Icon(Icons.refresh)
              )
            ],
          ),

        ],
      ),
      body: Consumer<Iterable<Ninja>>(
        builder: (BuildContext context, ninja, child) {
          final ninja = context.watch<Iterable<Ninja>>();
          if (ninja.isEmpty) {
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
                List<Ninja> listNinja = ninja.toList();
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(listNinja[index].name.toString()),
                  subtitle: Text(listNinja[index].rank.toString()),
                  trailing: Text("Is available? ${listNinja[index].isAvailable}"),
                  onTap: () {
                    // method untuk fetching
                    Layanan().fetchNinja(listNinja[index].id.toString());

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: const Icon(Icons.info),
                          title: const Text("Informasi"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Text>[
                              Text("id: ${listNinja[index].id.toString()}"),
                              Text("nama: ${listNinja[index].name.toString()}"),
                              Text("rank: ${listNinja[index].rank.toString()}"),
                              Text("available: ${listNinja[index].isAvailable}"),
                              Text("version: ${listNinja[index].version.toString()}"),
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
                          id: listNinja[index].id.toString(),
                          name: listNinja[index].name.toString(),
                          rank: listNinja[index].rank.toString(),
                          isAvailable: listNinja[index].isAvailable,
                          version: listNinja[index].version
                      ),
                    );

                  },
                  tileColor: (index.isEven) ? Colors.blueGrey[100] : Colors.transparent,
                );
              },
              itemCount: ninja.length,
            ),
          );
        },
        child: null,
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
                  version: 0
                ),
              );
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
