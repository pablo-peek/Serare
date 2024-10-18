import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:serare/eventos.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  int tiempo = 1;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;
  var usuarioController = new TextEditingController();
  var contraController = new TextEditingController();




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#07c18b"),
        body: ProgressHUD(
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),
        ),
      ),
    );
  }
  Widget _loginUI(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container( 
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 1.7,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                ]
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "imagenes/Logo.jpeg",
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            )
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              bottom: 30,
              top: 50,
            ),
            child: Text(
              "Login", 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextField(
                controller: usuarioController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  iconColor: HexColor("122A40"),
                  labelText: "Usuario",
                  floatingLabelStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    debugLabel: AutofillHints.middleName,
                    textBaseline: TextBaseline.alphabetic,
                    height: BorderSide.strokeAlignCenter,
                    letterSpacing: 2,
                    color: HexColor("122A40"),
                    fontWeight: FontWeight.bold,
                    inherit: false,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),          
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextField(
                controller: contraController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    }, icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
                  ),
                  iconColor: HexColor("122A40"),
                  labelText: "Contraseña",
                  floatingLabelStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    debugLabel: AutofillHints.middleName,
                    textBaseline: TextBaseline.alphabetic,
                    height: BorderSide.strokeAlignCenter,
                    letterSpacing: 2,
                    color: HexColor("122A40"),
                    fontWeight: FontWeight.bold,
                    inherit: false,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right:25, top: 10), 
              child: RichText(
                text:  TextSpan(
                  style: const TextStyle(
                    color:Colors.grey,
                    fontSize: 14.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Olvidaste la Contraseña?',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        .. onTap = () {
                          print("Olvides Contraseña");
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    find(usuarioController.text, contraController.text);
                  },
                  style: const ButtonStyle(
                    animationDuration: Duration(seconds: 1)
                  ), 
                  child: const Text("Login"),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
            "OR",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
           Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right:25, top: 10), 
              child: RichText(
                text:  TextSpan(
                  style: const TextStyle(
                    color:Colors.grey,
                    fontSize: 14.0,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: "No tienes cuenta?"),
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        .. onTap = () {
                          Navigator.pushNamed(context, "/register");
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void esperar(String usuario){
  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  setState(() {
    tiempo--;
    if(tiempo == 0){
      Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context){
          return Eventos(usuario);
      }
      ));
    }
  });
});
}

void _clearAll(){
  usuarioController.clear();
  contraController.clear();
}

Future<void> find(String usuario, String contra) async {
  String password = contra;
  String encryptedPassword = encryptPassword(password);
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
      "collection": "users",
      "filter": {
        "username": usuario,
        "password": encryptedPassword
      }
  });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    try {
      if (response.statusCode == 200) {
        await response.stream.bytesToString().then((value) async {
          dynamic valor = await json.decode(value);
          // print(valor);
          if(value.length > 20){
            String usuarioJSON = valor["document"]["username"];
            String contraJSON = valor["document"]["password"];
            String contaController = encryptPassword(contraController.text);
            if(usuarioController.text == usuarioJSON && contaController == encryptedPassword){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Iniciando Sesion en la cuenta de $usuario")));
              _clearAll();
              esperar(usuarioJSON);
          }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuario o Contraseña incorrectos")));
          }
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      throw e;
    }
  }
  String encryptPassword(String password) {
  var bytes = utf8.encode(password); // convierte la contraseña en una lista de bytes
  var hash = sha256.convert(bytes); // cifra los bytes utilizando el algoritmo SHA-256
  return hash.toString(); // devuelve la versión cifrada como una cadena de texto
}
  
}