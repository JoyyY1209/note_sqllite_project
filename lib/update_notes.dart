import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:noteedge/database/db_helper.dart';
import 'package:noteedge/homepage.dart';
import 'package:noteedge/model/note.dart';
class UpdateNotes extends StatefulWidget {

  final notes;
  const UpdateNotes({super.key,required this.notes});

  @override
  State<UpdateNotes> createState() => _UpdateNotesState();
}

class _UpdateNotesState extends State<UpdateNotes> {

  late DatabaseHelper dbHelper;
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

  final GlobalKey<FormState> noteFormKey = GlobalKey();
  int? id;

  Future updateNotes(int id) async{
  final updateNote=Note(
    title : titleController.text,
    description : descriptionController.text,
  );
  int result = await dbHelper.upadteNote(updateNote.toMap(), id);
  
  if(result!=0)
    {
      Get.snackbar("","",snackPosition : SnackPosition.BOTTOM);
      Navigator.pop(context);
    }
  else
    Get.snackbar("Eror", "Eror in note update",snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DatabaseHelper.instance;
    titleController.text=widget.notes.title;
    descriptionController.text=widget.notes.description;
    id=widget.notes.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Update Notes",
        style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: Form(
          key : noteFormKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Title",
                    prefixIcon: Icon(Icons.note_alt_outlined,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value){
                    if(value==null || value.isEmpty)
                      {
                        return "Please enter note title";
                      }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Description",
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter description";
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                    onPressed: ()async{
                    if(noteFormKey.currentState!.validate())
                      {
                        noteFormKey.currentState!.save();
                        //updatenote
                        updateNotes(id!);
                      }
                    },
                    child: Text("Update Note",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              ],
            ),
          ),),

    );
  }
}
