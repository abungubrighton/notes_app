import 'package:flutter/material.dart';
import 'package:notes_app/modes/note_database.dart';
import 'package:notes_app/pages/notes_page.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the database
  await NoteDatabase.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDatabase(), // injects the state into the widget tree
      child: const NotesApp(),
    )
  );
}
class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesPage(),
    );
  }
}