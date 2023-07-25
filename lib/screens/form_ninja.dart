
import 'package:flutter/material.dart';
import 'package:proj_my_ninja_api/models/ninja.dart';

class FormNinja extends StatefulWidget {
  // properti
  late String? operationMode;

  // konstruktor
  FormNinja({
    super.key,
    this.operationMode
  });

  @override
  State<FormNinja> createState() => _FormNinjaState();
}

class _FormNinjaState extends State<FormNinja> {
  // controller(s)
  late String _controllerID = "";
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerRank = TextEditingController();
  bool _controllerIsAvailable = false;
  late int _controllerVersion = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // to hold parameter(s) received
    final ninja = ModalRoute.of(context)!.settings.arguments as Ninja;
    // print("id-nya: ${ninja.id.toString()}");
    if (ninja.id.toString() != "") {
      _controllerID = ninja.id.toString();
      _controllerName.text = ninja.name.toString();
      _controllerRank.text = ninja.rank.toString();
      _controllerIsAvailable = ninja.isAvailable!;
      _controllerVersion = ninja.version!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ninja | Details"),
        elevation: 8.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        physics: const ScrollPhysics(),
        child: Column(
          children: <Widget>[
            // gambar
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/gambars/ninja.png"),
                  fit: BoxFit.fitWidth,
                ),
                border: Border.all(
                  color: const Color(0xFFFCE4EC),
                  width: 0.67,
                ),
              ),
              width: 256,
              height: 256,
              margin: const EdgeInsets.all(8.0),
            ),

            // form
            Form(
              child: Column(
                children: <Widget>[
                  // name of the ninja
                  TextFormField(
                    controller: _controllerName,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      label: Text("Name"),
                      hintText: "Name of the ninja",
                      filled: true,
                    ),
                  ),

                  const SizedBox(
                    height: 8.0,
                  ),

                  // rank of the ninja
                  TextFormField(
                    controller: _controllerRank,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.star),
                      label: Text("Rank"),
                      hintText: "Rank of the ninja",
                      filled: true,
                    ),
                  ),

                  const SizedBox(
                    height: 8.0,
                  ),

                  // is available?
                  /*Row(
                    children: <Widget>[
                      Checkbox(
                        value: _controllerIsAvailable,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _controllerIsAvailable = newValue!;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      const Text("Is available here?"),
                    ],
                  ),*/

                  CheckboxListTile(
                    value: _controllerIsAvailable,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _controllerIsAvailable = newValue!;
                      });
                    },
                    title: const Text("Is available"),
                    subtitle: const Text("Is the hero is available here"),
                    checkColor: Colors.blue,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ButtonBar(
        alignment: MainAxisAlignment.end,
        children: <ElevatedButton>[
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    icon: const Icon(Icons.warning),
                    title: const Text("Perhatian!"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Text>[
                        Text("Anda akan menghapus data ${_controllerName.text}"),
                        const Text("yakin yang Anda lakukan?"),
                      ],
                    ),
                    actions: <TextButton>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Tidak"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Ya"),
                      ),

                    ],
                  );
                },
              );
            },
            child: const Row(
              children: <Widget>[
                Icon(Icons.delete),
                SizedBox(),
                Text("Hapus"),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: <Widget>[
                Icon(Icons.save),
                SizedBox(
                  width: 8.0,
                ),
                Text("Ok"),
              ],
            ),
          ),

        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
