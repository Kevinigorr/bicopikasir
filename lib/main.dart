// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'menu_screen.dart'; // import halaman menu
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://nfafmiaxogrxxwjuyqfs.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mYWZtaWF4b2dyeHh3anV5cWZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAyNTIzMDcsImV4cCI6MjA1NTgyODMwN30.tsapVtnxkicRa-eTQLhKTBQtm7H9U1pfwBBdGdqryW0',
//   );
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MenuScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nfafmiaxogrxxwjuyqfs.supabase.co',   // ganti
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mYWZtaWF4b2dyeHh3anV5cWZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAyNTIzMDcsImV4cCI6MjA1NTgyODMwN30.tsapVtnxkicRa-eTQLhKTBQtm7H9U1pfwBBdGdqryW0', // ganti
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tes Menu',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}
