import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/chat.dart';

class ChatDatabaseInterface {
  static final ChatDatabaseInterface instance = ChatDatabaseInterface._internal();

  static Database? _database;
  ChatDatabaseInterface._internal();

  static const String databaseName = 'chat.db';

  static const int versionNumber = 3;

  static const String tableName = 'Chat';
  static const String colId = 'id';
  static const String colMessage = 'message';
  static const String colIsMe = 'isMe';
  static const String colConversationId = 'conversationId';
  static const String colSentAt = 'sentAt';

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    String path = join(await getDatabasesPath(), databaseName);
    // When the database is first created, create a table to store Notes.
    var db = await openDatabase(
      path,
      version: versionNumber,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colMessage TEXT NOT NULL,
        $colIsMe INTEGER NOT NULL,
        $colConversationId TEXT,
        $colSentAt TEXT NOT NULL
      )
    ''');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('''
        DROP TABLE IF EXISTS $tableName
      ''');
      await _onCreate(db, newVersion);
    }
  }

  Future<List<Chat>> get chats async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return maps.map((e) => Chat.fromMap(e)).toList();
  }

  Future<List<Chat>> chatsByConversation(String conversationId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: '$colConversationId = ?',
      whereArgs: [conversationId],
    );

    return maps.map((e) => Chat.fromMap(e)).toList();
  }

  Future<int> insertChat(Chat chat) async {
    final Database db = await database;
    return await db.insert(
      tableName,
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateChat(Chat chat) async {
    final Database db = await database;
    return await db.update(
      tableName,
      chat.toMap(),
      where: '$colId = ?',
      whereArgs: [chat.id],
    );
  }

  Future<int> deleteChat(int id) async {
    final Database db = await database;
    return await db.delete(
      tableName,
      where: '$colId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteChatsByConversation(String conversationId) async {
    final Database db = await database;
    return await db.delete(
      tableName,
      where: '$colConversationId = ?',
      whereArgs: [conversationId],
    );
  }
}