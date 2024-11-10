import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
part 'data.g.dart';

// dart run build_runner build

@HiveType(typeId: 0)
class TaskEntity extends HiveObject {
  int id = -1;
  @HiveField(0)
  String name = '';
  @HiveField(1)
  bool isCompleted = false;
  @HiveField(2)
  Priority priority = Priority.low;
  @HiveField(3)
  String description = '';
  @HiveField(4)
  TimeOfDay tasktime = TimeOfDay.now();
  @HiveField(5)
  DateTime taskdate = DateTime.now();
  @HiveField(6)
  bool taskreminder = false;
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high
}

@HiveType(typeId: 2)
class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 2;

  @override
  TimeOfDay read(BinaryReader reader) {
    final int hour = reader.readInt();
    final int minute = reader.readInt();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }
}
