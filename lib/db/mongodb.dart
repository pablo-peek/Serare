import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:serare/db/MongoDBModel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(dotenv.env['MONGO_CONN_URL']!);
    await db.open();
    inspect(db);
    userCollection = db.collection(dotenv.env['USER_COLLECTION']!);
  }

  static Future<void> update(MongoDbModel data) async {
    try {
      var result = await userCollection.findOne({"username": data.username});
      result['AlertDoor'] = data.flag;
      result['historialdate'] = data.fecha;
      var response = await userCollection.save(result);
      inspect(response);
    } catch (e) {
      print(e.toString());
    }
  }
}