import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/note.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;
  final int userId;
  final VoidCallback onSave;

  const NoteEditScreen({
    super.key,
    this.note,
    required this.userId,
    required this.onSave,
  });

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _categoryController.text = widget.note!.category ?? '';
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        createdAt: widget.note?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        category: _categoryController.text.isEmpty ? null : _categoryController.text,
        userId: widget.userId,
      );

      if (isEditing) {
        await _databaseHelper.updateNote(note);
      } else {
        await _databaseHelper.insertNote(note);
      }

      widget.onSave();
      Navigator.pop(context);
    }
  }

  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      height: 200, // Augmenté la hauteur pour mieux voir l'image
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/images.png',
          fit: BoxFit.cover, 
          errorBuilder: (context, error, stackTrace) {
            // Si l'image n'est pas trouvée, afficher un placeholder
            return Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Image non trouvée',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vérifiez le chemin: assets/images/votre_image.png',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier la note' : 'Nouvelle note'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Votre image en haut
              _buildImageSection(),
              const SizedBox(height: 20),
              
              // Champs de formulaire
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Titre',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Catégorie (optionnel)',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        constraints: const BoxConstraints(
                          minHeight: 200,
                        ),
                        child: TextFormField(
                          controller: _contentController,
                          decoration: const InputDecoration(
                            labelText: 'Contenu',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer le contenu de la note';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Boutons en bas
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          side: BorderSide(color: Colors.grey[400]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Annuler',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveNote,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Enregistrer',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}