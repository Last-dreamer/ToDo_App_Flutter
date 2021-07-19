
// table name
final String tableName = "notes";

// table fields ..
class NotesFields {

  static final List<String> values = [
    id,  title, description, time
  ];

  static final String id = "_id";
  static final String title = "title";
  static final String description = "description";
  static final String time = "time";

}
// model for table
class Note {
  final int? id;

  final String title;
  final String description;
  final DateTime createTime;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.createTime});

  Note copy({
    int? id,
    String? title,
    String? description,
    DateTime? createTime,

  }) => Note(id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          createTime: createTime ?? this.createTime);


  // to convert back from json
  static Note fromJson(Map<String, Object?> json) =>
      Note(id: json[NotesFields.id] as int?,
          title: json[NotesFields.title] as String,
          description: json[NotesFields.description] as String,
          createTime: DateTime.parse(json[NotesFields.time] as String)
      );


  // converting to json
  Map<String, Object?> toJson() =>
      {
        NotesFields.id: id,
        // databse is not supporting boolean so we have to pass the values
        // NotesFields.isImportant: isImportant! ? 1 : 0,
        NotesFields.title: title,
        NotesFields.description: description,
        NotesFields.time: createTime.toIso8601String()
      };

}
