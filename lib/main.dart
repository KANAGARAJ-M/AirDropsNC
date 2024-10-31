import 'package:air_drops/phase1/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
///PHASE 2
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await Supabase.initialize(
//     url: 'https://vdauwgurmubcnnqhtjnk.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkYXV3Z3VybXViY25ucWh0am5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjk5NDI2NzMsImV4cCI6MjA0NTUxODY3M30._Ow86Tn28BmH6qbxs3vwNlWhDmZS1VRGvDsw4UQcB5Q',
//   );
//   runApp(MyApp());
// }


///PHASE !
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const UpdateCheckerApp());
}