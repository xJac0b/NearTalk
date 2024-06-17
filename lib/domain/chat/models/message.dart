import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  Message({
    required this.id,
    required this.me,
    required this.text,
    required this.timestamp,
    this.sent = true,
    this.path,
  });
  @HiveField(0)
  final String id;

  @HiveField(1)
  final bool me;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool sent;

  @HiveField(5)
  final String? path;
}
