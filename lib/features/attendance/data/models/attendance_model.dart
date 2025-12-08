import '../../domain/entities/attendance_entity.dart';

class CheckInRecordModel {
  final String name;
  final String time;
  final double similarity;
  final DateTime timestamp;
  final String status;

  CheckInRecordModel({
    required this.name,
    required this.time,
    required this.similarity,
    required this.timestamp,
    this.status = 'present',
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'time': time,
    'similarity': similarity,
    'timestamp': timestamp.toIso8601String(),
    'status': status,
  };

  factory CheckInRecordModel.fromJson(Map<String, dynamic> json) =>
      CheckInRecordModel(
        name: json['name'],
        time: json['time'],
        similarity: json['similarity'],
        timestamp: DateTime.parse(json['timestamp']),
        status: json['status'] ?? 'present',
      );

  CheckInRecord toEntity() => CheckInRecord(
    name: name,
    time: time,
    similarity: similarity,
    timestamp: timestamp,
    status: status,
  );

  factory CheckInRecordModel.fromEntity(CheckInRecord record) =>
      CheckInRecordModel(
        name: record.name,
        time: record.time,
        similarity: record.similarity,
        timestamp: record.timestamp,
        status: record.status,
      );
}
