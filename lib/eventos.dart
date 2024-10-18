
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:serare/app.dart';
import 'package:serare/db/MongoDBModel.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:serare/db/mongodb.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';



class Eventos extends StatefulWidget {
  //const Eventos({Key? key}) : super(key: key);

  String user;
  Eventos(this.user, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventosState createState() => _EventosState();
}

class _EventosState extends State<Eventos> {
  Timer? timer, cerrarsesion;
  bool _ledOn = false, colorb = false;
  int tiempo = 1, cerrar = 1;
  String flag = "--", fecha = "";
  String door = '--';
// ws://192.168.195.9:81/

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("07c18b"),
        automaticallyImplyLeading: false,
        title: Text('Bienvenido ${widget.user}'),
        actions: [
          Padding(
            padding: 
            const EdgeInsets.only(right: 50),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: colorb ? const Color.fromARGB(255, 8, 7, 5): Colors.white,
                ), 
                onPressed: () { 
                  setState(() {
                    colorb = !colorb;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cerrando Sesión...")));
                  close();
                 },)
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              fecha, 
              style: const TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 100, height: 100),
          Center(
            child: GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: HexColor("#07c18b"),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              flag = "True";
                              door = 'cerrar';
                              find();
                              updatedoor();
                              updatefecha();
                              //updateflag(widget.user, flag, fecha);
                            });
                            _toggledoor();
                          },
                          icon: const Icon(
                            color: Color.fromARGB(255, 24, 23, 23),
                            Icons.door_back_door_outlined)
                        )
                      ),
                      const Text("Abrir la Puerta"),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: HexColor("#07c18b"),
                        child: IconButton(
                          onPressed: (){
                            setState(() {
                              flag = "False";
                              door = 'abrir';
                              find();
                              updatedoor();
                              updatefecha();
                              //updateflag(widget.user, flag, fecha);
                            });
                            _toggledoor();
                          }, 
                          icon: const Icon(
                            color: Color.fromARGB(255, 24, 23, 23),
                            Icons.door_back_door_outlined
                          ),
                        )
                      ),
                      const Text("Cerrar la Puerta"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          ],
        ),
      backgroundColor: Colors.white,
    );
  }

  void _toggledoor() {
    try {
      final channel = IOWebSocketChannel.connect('ws://192.168.104.9:81/');
      channel.sink.add(door);
    } on TimeoutException catch (_) {
      throw("Tiempo de espera alcanzado");
    } on SocketException {
      throw ("Falla del servidor del ESP32");
    }
  }

  Future<void> updatefecha() async{
    var headers = {
		'Content-Type': 'application/json',
		'Access-Control-Request-Headers': '*',
		'api-key': '641e59e6f3889c6b9f195330'
    };
var request = http.Request('POST', Uri.parse('https://data.mongodb-api.com/app/data-oaeeq/endpoint/data/v1/action/updateOne'));
request.body = json.encode({
  "dataSource": "Integrador",
  "database": "Usuarios",
  "collection": "users",
  "filter": {
    "username": widget.user
  },
  "update": {
    "\$set": {
      "historialdate": fecha
    }
  }
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
		print(await response.stream.bytesToString());
}
else {
		print(response.reasonPhrase);
}

  }

  Future<void> updatedoor() async {
    var headers = {
		'Content-Type': 'application/json',
		'Access-Control-Request-Headers': '*',
		'api-key': '641e59e6f3889c6b9f195330'
    };
var request = http.Request('POST', Uri.parse('https://data.mongodb-api.com/app/data-oaeeq/endpoint/data/v1/action/updateOne'));
request.body = json.encode({
  "dataSource": "Integrador",
  "database": "Usuarios",
  "collection": "users",
  "filter": {
    "username": widget.user
  },
  "update": {
    "\$set": {
      "AlertDoor": flag
    }
  }
});
request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
		print(await response.stream.bytesToString());
}
else {
		print(response.reasonPhrase);
}

  }

  Future<void> find() async {
  var headers = {
		'Content-Type': 'application/json',
		'Access-Control-Request-Headers': '*',
		'api-key': '641e59e6f3889c6b9f195330',
		'Accept': 'application/json'
  };
  var request = http.Request('POST', Uri.parse('https://data.mongodb-api.com/app/data-oaeeq/endpoint/data/v1/action/findOne'));
    request.body = json.encode({
      "dataSource": "Integrador",
      "database": "Usuarios",
      "collection": "historials",
      "filter": {
        "__v" : 0
      }
  });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    try {
      if (response.statusCode == 200) {
        await response.stream.bytesToString().then((value) async {
          dynamic valor = await json.decode(value);
          fecha = valor["document"]["data"];
          print(fecha);
          return fecha;
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateflag(String nombre, String bandera, String fechaActual) async {
    final updateData = MongoDbModel(username: nombre, flag: bandera, fecha: fechaActual);
    await MongoDatabase.update(updateData).whenComplete(() => null);
  }

  void close() {
  cerrarsesion = Timer.periodic(
    const Duration(seconds: 1),
    (cerrarsesion) {
      setState(() {
        cerrar--;
        if (cerrar == 0) {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const App()));  
        }
      });
    });
  }

}

