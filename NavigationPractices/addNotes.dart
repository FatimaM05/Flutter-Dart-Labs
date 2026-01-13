import 'package:flutter/material.dart';
import 'saveNotes.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  final TextEditingController _noteController = TextEditingController();

  void addNotes(){
    if(_noteController.text.isNotEmpty){
      notes.add(_noteController.text);
      _noteController.clear();
    }
  }

  void _goHome() {
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: "Enter your note here",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                onPressed: addNotes,
                child: const Text("Save"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _goHome,
                child: const Text("Home"),
              ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
