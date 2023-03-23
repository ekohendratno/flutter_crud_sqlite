import 'package:flutter/material.dart';
import 'package:flutter_crud_sqlite/database/DatabaseHelper.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'dart:async';

import 'package:flutter_crud_sqlite/models/Notes.dart';

class ListControllerState extends StatefulWidget {
  @override
  _ListControllerScreenState createState() => _ListControllerScreenState();
}

class _OpenForm extends StatefulWidget {
  final Notes? note;

  const _OpenForm({super.key, this.note});

  @override
  State<_OpenForm> createState() => _OpenFormState();
}

class _OpenFormState extends State<_OpenForm> {
  DatabaseHelper db = DatabaseHelper();

  TextEditingController? title;
  TextEditingController? desc;

  Future<void> _simpan() async {
    if (widget.note != null) {
      await db.updateNotes(Notes.fromMap(
          {'id': widget.note!.id, 'title': title!.text, 'desc': desc!.text}));

      Navigator.pop(context, 'update');
    } else {
      await db.saveNotes(Notes(title: title!.text, desc: desc!.text));

      Navigator.pop(context, 'save');
    }
  }

  @override
  void initState() {
    title = TextEditingController(
        text: widget.note == null ? '' : widget.note!.title);
    desc = TextEditingController(
        text: widget.note == null ? '' : widget.note!.desc);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 20),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  child: Text("Title"),
                  padding: EdgeInsets.only(left: 24, right: 24))),
          TextFormField(
            controller: title,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 24, bottom: 8, top: 8, right: 24),
                hintText: "Masukkan title"),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  child: Text("Desc"),
                  padding: EdgeInsets.only(left: 24, right: 24))),
          TextFormField(
            controller: desc,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 24, bottom: 8, top: 8, right: 24),
                hintText: "Masukkan deskripsi"),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 24, bottom: 8, top: 8, right: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color(0xFF4CAF50),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                _simpan();
              },
              child: const Text(
                'Simpan',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, bottom: 8, top: 8, right: 24),
            child: ElevatedButton(
              child: const Text(
                'Batal',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color(0xFFFFFFFF),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}







class _ListControllerScreenState extends State<ListControllerState> {
  List<Notes> listNotes = [];
  DatabaseHelper db = DatabaseHelper();

  Future<void> _openFormEdit(BuildContext context, Notes note) async {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return _OpenForm(
          note: note,
        );
      },
    ).whenComplete(() {
      _init();
    });


  }

  Future<void> _openFormCreate(BuildContext context) async {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return _OpenForm();
      },
    ).whenComplete(() {
      _init();
    });

  }

  Future<void> _deleteNotes(Notes note, int position) async {
    await db.deleteNotes(note.id!);
    setState(() {
      listNotes.removeAt(position);
    });
  }

  Future<void> _init() async {
    var list = await db.getAllNotes();

    setState(() {
      listNotes.clear();

      for (var note in list!) {
        listNotes.add(Notes.fromMap(note));
      }
    });
  }

  @override
  void initState() {
    _init();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
          itemCount: listNotes.length,
          itemBuilder: (context, index) {
            Notes note = listNotes[index];
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
              child: Card(
                elevation: 3,
                color: Colors.white,
                child: ListTile(
                  title: Text('${note.title}'),
                  subtitle: Text('${note.desc}'),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(
                      children: [
                        // button edit
                        IconButton(
                            onPressed: () {
                              _openFormEdit(context, note);
                            },
                            icon: Icon(Icons.edit, color: Colors.green,)),
                        // button hapus
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red,),
                          onPressed: () {

                            AlertDialog hapus = AlertDialog(
                              title: Text("Information"),
                              content: Container(
                                height: 100,
                                child: Column(
                                  children: [
                                    Text(
                                        "Yakin ingin Menghapus Data ${note.title}")
                                  ],
                                ),
                              ),

                              actions: [
                                TextButton(
                                    onPressed: () {
                                      _deleteNotes(note, index);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Ya")),
                                TextButton(
                                  child: Text('Tidak'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                            showDialog(
                                context: context, builder: (context) => hapus);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _openFormCreate(context);
        },
      ),
    );
  }
}
