

import 'package:flutter_crud_sqlite/database/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class Notes {

  int? id;
  String? title;
  String? desc;
  String? tanggal;

  Notes({
    this.id,
    this.title,
    this.desc,
    this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'desc': desc, 'tanggal': tanggal};
  }

  static Notes fromMap(Map<String, dynamic> map) {
    return Notes(id : map['id'], title : map['title'], desc : map['desc'], tanggal : map['tanggal']);
  }

}
