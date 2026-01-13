import 'package:flutter/material.dart';
List<String> notes = [];

class SavedNotesScreen extends StatelessWidget {
  const SavedNotesScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Notes"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: notes.length,
        itemBuilder: (context, index){
          return Card(
            child: ListTile(
              title: Text(notes[index]),
            ),
          );
        },
      ),
    );
  }
}