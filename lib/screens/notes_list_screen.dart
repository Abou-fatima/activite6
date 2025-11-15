import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/note.dart';
import 'note_edit_screen.dart';
import 'welcome_screen.dart';

class NotesListScreen extends StatefulWidget {
  final int userId;

  const NotesListScreen({super.key, required this.userId});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await _databaseHelper.getNotesByUser(widget.userId);
    setState(() {
      notes = loadedNotes;
    });
  }

  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          userId: widget.userId,
          onSave: _loadNotes,
        ),
      ),
    );
  }

  void _editNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          note: note,
          userId: widget.userId,
          onSave: _loadNotes,
        ),
      ),
    );
  }

  void _deleteNote(int id) async {
    await _databaseHelper.deleteNote(id);
    _loadNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note supprimée avec succès'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _toggleNoteCompletion(Note note) async {
    note.isCompleted = !note.isCompleted;
    note.updatedAt = DateTime.now();
    await _databaseHelper.updateNote(note);
    _loadNotes();
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer cette note ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteNote(id);
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune note trouvée',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Appuyez sur le bouton + pour créer votre première note',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: note.isCompleted,
                      onChanged: (value) => _toggleNoteCompletion(note),
                    ),
                    title: Text(
                      note.title,
                      style: TextStyle(
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.content.length > 100
                              ? '${note.content.substring(0, 100)}...'
                              : note.content,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Modifié: ${_formatDate(note.updatedAt)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (note.category != null) ...[
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(
                              note.category!,
                              style: const TextStyle(fontSize: 10),
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(note.id!),
                    ),
                    onTap: () => _editNote(note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}