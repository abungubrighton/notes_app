import 'package:flutter/material.dart';
import 'package:notes_app/modes/note.dart';
import 'package:notes_app/modes/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // crud ui functions
  // create note
  final textController = TextEditingController();
  void addNote() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Enter note text'),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  context.read<NoteDatabase>().addNote(textController.text);
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  // read notes method
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update note
  void updateNotes(Note notes) {
    // pre-fill the text field with the current note text
    textController.text = notes.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Note'),
        content:TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton( 
            child: const Text('Update'),
            onPressed: (){
              // update the note in the database
              context.read<NoteDatabase>().updateNote(
                notes.id,
                textController.text,
              );
              textController.clear();
              Navigator.pop(context);
            },
          )
        ]),
    );
  }

  // delete note
  void deleteNote(int id){
    context.read<NoteDatabase>().deleteNote(id);
    // show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted'),
        duration: Duration(seconds: 1),
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    // fetch notes from the database
    WidgetsBinding.instance.addPostFrameCallback((_) {
      readNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    // access the database
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNote(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          final note = currentNotes[index];
          return ListTile(
            title: Text(note.text),
            trailing: IntrinsicWidth(
              child: Row(
                children: [
                  // edit button
                  IconButton(icon: Icon(Icons.edit),
                  onPressed:()=> updateNotes(note), // update button,
                  ),
                  // delete button
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteNote(note.id), // delete button
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
