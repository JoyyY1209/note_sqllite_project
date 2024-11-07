import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:noteedge/add_notes.dart';
import 'package:noteedge/database/db_helper.dart';
import 'package:noteedge/model/note.dart';
import 'package:noteedge/update_notes.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  //declare varriables
  late DatabaseHelper dbHelper;
  List<Note> notes= [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //intializing dbHelper
    dbHelper = DatabaseHelper.instance;

    loadAllData();
  }

  Future loadAllData()async{
    final data = await dbHelper.getAllData();

    setState(() {
      //This line converts a list of map entries (database records) into a list of Note objects using the Note.fromMap method, making it easier to work with custom objects in your app.
      //each element is a map, represented by [position]
      notes = data.map((position)=>Note.fromMap(position)).toList();

    });
  }

  Future deleteNotes(int id)async{
    int result = await dbHelper.deleteNote(id);
    if(result!=0) {
      Fluttertoast.showToast(msg: "Note Deleted Succesfully");
      loadAllData();
    }
    else
      Fluttertoast.showToast(msg: "Faild to delete note");
  }

  @override
  Widget build(BuildContext context) {
    int count=0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Note",
        style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: notes.isEmpty
        ? Center(child: Text("No notss available"),)
        : ListView.builder(
          itemCount:notes.length,
          itemBuilder: (context,index){

            Note note = notes[index];    // "Note" ekta user define datatype,jeta "note" ke declare kore list "notes" er each elaement k point kortese

            return Padding(padding: EdgeInsets.all(10),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.indigoAccent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateNotes(notes : note)));
                },
                title: Text(note.title!,style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(note.description!),
                leading: Icon(Icons.note_alt_outlined,size: 40,),
                trailing: IconButton(onPressed: (){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.question,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: 'Delete',
                    desc: 'Want To Delete Note?',
                    buttonsTextStyle: TextStyle(color : Colors.white),
                    showCloseIcon: true,
                    btnOkText: 'Yes',
                    btnOkOnPress: (){

                      deleteNotes(note.id!);
                      Get.back();
                    },
                    btnCancelText: 'No',
                    btnCancelOnPress: (){},

                  ).show();
                },
                    icon: Icon(Icons.delete,size: 40,)),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          tooltip:'Add Note',
          mini: false,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNotes()));
          },
          child: Icon(Icons.add,color: Colors.white,),),
    );
  }
}
