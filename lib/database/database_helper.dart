import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        category TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        userId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> validateUser(String username, String password) async {
    final user = await getUserByUsername(username);
    return user != null && user.password == password;
  }

  // Méthodes pour les notes
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotesByUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
    );
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}