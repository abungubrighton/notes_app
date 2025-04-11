import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'note.dart';

// Holds functionality to interact with the database
class NoteDatabase {
  // INITIALIZE - DATABASE
  static late Isar isar; // DEFINE THE ISAR OBJECT
  // this is the object that will be used to interact with the database
  static Future<void> initialize() async {
    // method to initialize the database
    final dir =
        await getApplicationDocumentsDirectory(); // get path to the dir where all data will be saved
    isar = await Isar.open(
      [NoteSchema], // this is the schema for the Note object
      directory:
          dir.path, // this is the path to the dir where all will be saved
    );
  }

  List<Note> currentNotes = []; // simple state to be used by widgets 

  // C R E A T E - a note and save to db
  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    // save the note to the database
    await isar.writeTxn(() async {
      await isar.notes.put(newNote);
    });

    // retrieve the notes from the database
    fetchNotes();
  }

  // R E A D - get all notes from db
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
  }

  // U P D A T E - update a note in db
  Future<void> updateNote(Id id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  // D E L E T E - delete a note from db
  Future<void> deleteNote(Id id) async {
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
      await fetchNotes();
    });
  }
}
