import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noteedge/database/db_helper.dart';
import 'package:noteedge/homepage.dart';
import 'package:noteedge/model/note.dart';
class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

  late DatabaseHelper dbHelper;
  var textController = TextEditingController();
  var descriptionController = TextEditingController();

  final GlobalKey<FormState> noteFormKey = GlobalKey();

  Future addNotes() async{
    final newNote = Note(
      title : textController.text,
      description : descriptionController.text,
    );
    int result = await dbHelper.insertData(newNote.toMap());

    if(result!=0)
      {
        Get.snackbar("Success","Note Added",snackPosition : SnackPosition.BOTTOM);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
      }
    else
      Get.snackbar("Eror", "Eror in adding notes",snackPosition: SnackPosition.BOTTOM);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DatabaseHelper.instance;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Add Note",style: TextStyle(color: Colors.white),),
      ),
      body: Form(
          key: noteFormKey,

          child: SingleChildScrollView(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                TextFormField(
                  controller: textController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Title',
                    prefixIcon: Icon(Icons.note_alt_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
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
                    labelText: 'Description',
                    hintText: 'Description',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  validator: (String? value){
                    if(value==null || value.isEmpty)
                      {return "Please enter description";}
                    return null;
                  },
                ),

                SizedBox(height: 10,),

                ElevatedButton(
                    style : ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: ()async{
                      if(noteFormKey.currentState!.validate())
                        {
                          noteFormKey.currentState!.save();
                          addNotes();
                        }

                    },
                    child: Text("Save Note",
                    style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold),),),

              ],
            ),

          )),
    );
  }
}
