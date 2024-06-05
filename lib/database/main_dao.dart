import 'package:floor/floor.dart';
import 'package:floor_database_todo_application/database/note_entity.dart';


@dao
abstract class MainDao{

  @Query("SELECT * FROM NoteEntity")
  Future<List<NoteEntity>>  getAllNotes();

  @insert
  Future<void> InsertNote(NoteEntity note_entity);

   @update
  Future<void> updateNote(NoteEntity note_entity);

   @delete
  Future<void> deleteNote(NoteEntity note_entity);

}