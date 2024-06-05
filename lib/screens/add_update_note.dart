import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:floor_database_todo_application/database/database.dart';
import 'package:floor_database_todo_application/database/note_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddUpdateNote extends StatefulWidget {
  final AppDatabase database;
  final Function updateData;
  final NoteEntity? noteEntity;
  const AddUpdateNote(
      {super.key,
      required this.database,
      required this.updateData,
      this.noteEntity});

  @override
  State<AddUpdateNote> createState() => _AddUpdateNoteState();
}

class _AddUpdateNoteState extends State<AddUpdateNote> {
  TextEditingController title_controller = TextEditingController();
  TextEditingController date_controller = TextEditingController();

  var key = GlobalKey<FormState>();


  @override
  void initState() {
    setState(() {
     title_controller.text=widget.noteEntity!= null ? widget.noteEntity!.title! : "";
      date_controller.text=widget.noteEntity!= null ? widget.noteEntity!.date! : " ";
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteEntity == null ? "Add Note" : 'Update Note'),
      ),
      body: SafeArea(
          child: Form(
              key: key,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: title_controller,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return "Please Enter Title";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Type a Title",
                          label: Text("Title"),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextFormField(
                      controller: date_controller,
                      validator: (v) {
                        return v!.isEmpty ? "Please Select Data" : null;
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          label: const Text("Date"),
                          hintText: " Date",
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2)),
                          suffix: InkWell(
                            child: const Icon(Icons.date_range),
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2034),
                                      initialDate: DateTime.now(),
                                      cancelText: "Cancel",
                                      confirmText: "OK",
                                      helpText: "Please Select Date")
                                  .then((value) {
                                if (value != null) {
                                  date_controller.text =
                                      DateFormat("yyyy/MM/dd").format(value);
                                }
                              });
                            },
                          )),
                    ),
                  ),
                  // Make Buttons
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      save();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.white),
                      child: Center(
                        child: Text("Save"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  widget.noteEntity == null
                      ? SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            delete();
                          },
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(0),
                                color: Colors.white),
                            child: Center(
                              child: Text("Delete"),
                            ),
                          ),
                        ),
                ],
              ))),
    );
  }

  // add / update Funtion
  void save() async {
    // check all filed
    if (key.currentState!.validate()) {
      if (widget.noteEntity == null) {
        // add new Note
        NoteEntity note = NoteEntity(
            title: title_controller.text, date: date_controller.text);
        await widget.database.mainDao.InsertNote(note);
        // showing message after adding
        final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
                title: "Success",
                message: "Your Note Added",
                contentType: ContentType.success),
                );
                ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);
                // close current screen
                Navigator.pop(context);
                // updating notes list
                widget.updateData();
      } else {
        //update Current
        NoteEntity note=NoteEntity(id: widget.noteEntity!.id,
        title: title_controller.text,date: date_controller.text);
        await widget.database.mainDao.updateNote(note);
        // showing message after adding
        final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
                title: "Success",
                message: "Your Note Updated",
                contentType: ContentType.success),
                );
                ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);
                // close current screen
                Navigator.pop(context);
                // updating notes list
                widget.updateData();
      }
    }
  }

// delete Function
void delete()async{
  await widget.database.mainDao.deleteNote(widget.noteEntity!);
  // showing snackbar
  final snackbar=SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    behavior: SnackBarBehavior.floating,
    content: AwesomeSnackbarContent(
      title: "Delete",
      message: "Note Deleted",
      contentType: ContentType.warning,
    ));

    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackbar);
    Navigator.pop(context);
    widget.updateData();
}


  
}
