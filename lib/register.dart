import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mailjet/mailjet.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'home.dart';
import 'package:crypto/crypto.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var usuarioController = new TextEditingController();
  var correoController = new TextEditingController();
  var contraController = new TextEditingController();
  Timer? timer1;
  int tiempo1 = 1;
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#07c18b"),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _registerUI(context),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }
  Widget _registerUI(BuildContext context){
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
              top: 20,
            ),
            child: Text(
              "Registrarte", 
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextField(
                controller: correoController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.mail),
                  iconColor: HexColor("122A40"),
                  labelText: "Correo",
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
                text:  const TextSpan(
                  style:  TextStyle(
                    color:Colors.grey,
                    fontSize: 14.0,
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
                text: const TextSpan(
                  style: TextStyle(
                    color:Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    if(usuarioController.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ingresa un usuario")));
                    }
                    else if(correoController.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ingresa un correo")));
                    }
                    else if(contraController.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ingresa password")));
                    }
                    else{
                      api_insert(usuarioController.text, correoController.text, contraController.text);
                    }
                  }, 
                  child: const Text("Register"),
                  style: const ButtonStyle(
                    animationDuration: Duration(seconds: 1)
                  ),
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
            height: 10,
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
                    const TextSpan(text: "Ya tengo cuenta "),
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        .. onTap = () {
                          Navigator.pushNamed(context, "/");
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


void api_insert(String usuario, String correo, String contra) async{
  String password = contra;
  String encryptedPassword = encryptPassword(contra);
  print(encryptedPassword);
  var headers = {
    'Content-Type': 'application/json',
    'Access-Control-Request-Headers': '*',
    'api-key': '641e59e6f3889c6b9f195330'
  };
  var request = http.Request('POST', Uri.parse('https://data.mongodb-api.com/app/data-oaeeq/endpoint/data/v1/action/insertOne?641e59e6f3889c6b9f195330=ApiPostLogin'));
  request.body = json.encode({
    "dataSource": "Integrador",
    "database": "Usuarios",
    "collection": "users",
    "document": {
      "username": usuario,
      "email": correo,
      "password": encryptedPassword
    }
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  String? razon;

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    //print(response.reasonPhrase);
    razon = await response.reasonPhrase.toString();
    print(razon);
    if(razon == "Created"){
      apiemail(usuario);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Usuario registrado correctamente")));
      esperar();
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Esta cuenta ya esta creada")));
    }
  }
}

  String encryptPassword(String password) {
  var bytes = utf8.encode(password); // convierte la contraseña en una lista de bytes
  var hash = sha256.convert(bytes); // cifra los bytes utilizando el algoritmo SHA-256
  return hash.toString(); // devuelve la versión cifrada como una cadena de texto
}
void _clearAll(){
  usuarioController.text = "";
  correoController.text = "";
  contraController.text = "";
}

Future<void> apiemail(String user) async {
  MailJet mailJet = MailJet(
  apiKey: "449bd2f09c7a8f7f1320acac56164f5a",
  secretKey: "1ac37912f4bfd5a51852282bdd60235a",
);
await mailJet.sendEmail(
  subject: "Registrado correctamente Serare", 
  sender: Sender(
    email: "pablo72h@proton.me", 
    name: "Serare",
  ), 
  reciepients: [
    Recipient(
      email: correoController.text,
      name: usuarioController.text,
    ),
  ], 
  htmlEmail: "<h3> Te has registrado correctamente $user Bienvenido a <a href='https://www.mailjet.com/'>Serare</a>!</h3><br /> La mejor empresa de seguridad en Chihuahua",
  Attachments: [
    File("./imagenes/Logo.jpeg")
  ],
);
}
void esperar(){
  timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
  setState(() {
    tiempo1--;
    if(tiempo1 == 0){
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  });
});
}
}