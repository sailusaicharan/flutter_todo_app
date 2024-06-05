import "package:floor/floor.dart";


@Entity()
class NoteEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String? title;
  String? date;

  NoteEntity({this.id, this.title, this.date});


}