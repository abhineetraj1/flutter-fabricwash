import 'dart:math';
import 'package:fabricwash/service.dart';
import 'package:fabricwash/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

signin(phone,password) async {
  try {
    var db = Db(mongoDB);
    await db.open();
    var collection = db.collection("users");
    var data = await collection.findOne({"phone": phone, "password": password});
    if (data != null) {
      await save_account_details(data["name"], data["phone"], data["password"]);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
signup(name, phone, password) async{
  try {
    var db = Db(mongoDB);
    await db.open();
    var collection = db.collection("users");
    var data = await collection.findOne({"phone": phone});
    if (data == null) {
      await collection.insert({"name": name, "phone": phone, "password": password});
      save_account_details(name, phone, password);
      return true;
    } else {
      return false;
    }} catch (e) {
      return false;
    }
}
save_account_details(name, phone, password) async {
  var storage = new FlutterSecureStorage();
  accountData = {"name": name, "phone": phone, "password": password};
  await storage.write(key: "name", value: name);
  await storage.write(key: "phone", value: phone);
  await storage.write(key: "password", value: password);
}
verify_account_details() async {
  var storage = new FlutterSecureStorage();
  var name = await storage.read(key: "name");
  var phone = await storage.read(key: "phone");
  var password = await storage.read(key: "password");
  if (name != null && phone != null && password != null) {
    if (await signin(phone, password)) {
      accountData = {"name": name, "phone": phone, "password": password};
      return true;
    }
  }
  delete_account_details();
  return false;
}
delete_account_details() async {
  var storage = new FlutterSecureStorage();
  await storage.delete(key: "name");
  await storage.delete(key: "phone");
  await storage.delete(key: "password");
  accountData = null;
}
get_account_details() async {
  var storage = new FlutterSecureStorage();
  var name = await storage.read(key: "name");
  var phone = await storage.read(key: "phone");
  var password = await storage.read(key: "password");
  if (name != null && phone != null && password != null) {
    accountData = {"name": name, "phone": phone, "password": password};
    return true;
  }
  accountData = null;
  return false;
}
place_order() async{
  try {
    var db = Db(mongoDB);
    await db.open();
    var collection = db.collection("orders");
    var location = await determinePosition();
    if (location == false) return false;
    await collection.insert({
      "name": accountData["name"],
      "phone": accountData["phone"],
      "total": bill(),
      "bill": billInfo,
      "location": location,
      "datetime": DateTime.now().toString(),
      "status": "pending",
      "otp": Random().nextInt(9999).toString(),
    });
    return true;
  } catch (e) {
    print("object $e");
    return false;
  }
}
get_order() async {
  try {
    var db = Db(mongoDB);
    await db.open();
    var collection = db.collection("orders");
    var data = await collection.find({"phone": accountData["phone"]}).toList();
    return data;
  } catch (e) {
    return false;
  }
}
cancel_order(_id) async {
  try {
    var db = Db(mongoDB);
    await db.open();
    var collection = await db.collection("orders");
    await collection.updateOne({"_id": _id}, {"\$set": {"status": "cancelled"}});
    return true;
  } catch (e) {
    print("Error: $e");
    return false;
  }
}
update_account_details(key, newvalue) async {
  try {
    var db = Db(mongoDB);
    await db.open();
    var collection = db.collection("users");
    var orders = db.collection("orders");
    if (key == "phone") {
      var data = await collection.findOne({"phone": newvalue});
      if (data != null) return false;
      await orders.update({"phone": accountData["phone"]}, {"\$set": {key: newvalue}});
      await collection.update({"phone":accountData["phone"]}, {"\$set": {key: newvalue}});
      return true;
    } else {
      await collection.update({key: accountData[key],"phone":accountData["phone"]}, {"\$set": {key: newvalue}});
    }
    accountData[key] = newvalue;
    var storage = new FlutterSecureStorage();
    await storage.write(key: key, value: newvalue);
    return true;
  } catch (e) {
    return false;
  }
}
get_order_details() async {
  try {
    var db = Db(mongoDB);
    await db.open();
    var collection = db.collection("orders");
    orders = await collection.find(where.eq("phone", accountData["phone"])).toList();
  } catch (_) {
  }
}