

// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
    MongoDbModel({
        required this.username,
        required this.flag,
        required this.fecha,
    });

    String username;
    String flag;
    String fecha;

    factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        username: json["username"],
        flag: json["flag"],
        fecha: json["fecha"]
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "PuertaAbierta": flag,
        "Fecha":fecha,
    };
}