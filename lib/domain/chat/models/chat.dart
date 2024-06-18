import 'package:hive/hive.dart';
import 'package:neartalk/domain/chat/models/message.dart';

part 'chat.g.dart';

// TODO(me): Remove this global variable
Map<int, ({String deviceId, String uri})> filesToUpload = {};

@HiveType(typeId: 1)
class Chat extends HiveObject {
  Chat({
    required this.id,
    required this.endpointId,
    required this.name,
    required this.messages,
    required this.paths,
    this.avatarPath,
  });
  factory Chat.empty() =>
      Chat(id: '', endpointId: '', name: '', messages: [], paths: []);
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String endpointId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final List<Message> messages;

  @HiveField(4)
  final String? avatarPath;

  @HiveField(5)
  final DateTime createdAt = DateTime.now();

  @HiveField(6)
  final List<String> paths;

  Chat copyWith({
    String? id,
    String? endpointId,
    String? name,
    List<Message>? messages,
    String? avatarPath,
    List<String>? paths,
  }) {
    return Chat(
      id: id ?? this.id,
      endpointId: endpointId ?? this.endpointId,
      name: name ?? this.name,
      messages: messages ?? this.messages,
      avatarPath: avatarPath ?? this.avatarPath,
      paths: paths ?? this.paths,
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, endpointId: $endpointId, name: $name, messages: $messages, avatarPath: $avatarPath, createdAt: $createdAt, paths: $paths)';
  }
}
