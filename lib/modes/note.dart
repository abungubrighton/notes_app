import 'package:isar/isar.dart';

part 'note.g.dart';
// This is the model class for the Note object
// It is used to define the schema for the Note object
// and to generate the Isar database code
// The @Collection annotation is used to define the collection name
// run command `dart run build_runner build` to generate the code
@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text; // because will initialize it later

}