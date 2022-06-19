import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/NoteService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var notesServices = context.watch<NoteService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),

        body: notesServices.isLoading
            ? const Center(
          child: CircularProgressIndicator(),)
            :
        RefreshIndicator(
          onRefresh: () async {},
          child: ListView.builder(
            itemCount: notesServices.notes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(notesServices.notes[index].title),
                subtitle: Text(notesServices.notes[index].description),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    notesServices.deleteNote(notesServices.notes[index].id);
                  },
                ),
              );
            },
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Note'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter title',
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      notesServices.addNote(
                        titleController.text,
                        descriptionController.text,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
