import 'package:cloud_firestore/cloud_firestore.dart';

class Users
{
  String? uid;
  String? name;
  String? photoUrl;
  String? email;

  Users({
    this.uid,
    this.name,
    this.photoUrl,
    this.email,
  });

  Users.fromJson(Map<String, dynamic> json)
  {
    uid = json["uid"];
    name = json["name"];
    photoUrl = json["photoUrl"];
    email = json["email"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["uid"] = this.uid;
    data["name"] = this.name;
    data["photoUrl"] = this.photoUrl;
    data["email"] = this.email;
    return data;
  }
}