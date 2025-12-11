import 'dart:convert';
import 'dart:io';

import 'package:attendanceappointment/features/attendance/data/models/attendance_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

abstract class HistoryLocalDataSource {
  Future<List<String>> getAvailableDates();
  Future<List<CheckInRecordModel>> getRecordsForDate(String date);
  Future<void> addAbsentRecords(List<String> absentNames);
  Future<String> exportToCSV(String date, List<CheckInRecordModel> records);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  @override
  Future<List<String>> getAvailableDates() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory
        .listSync()
        .where(
          (file) =>
              file.path.contains('attendance_') && file.path.endsWith('.json'),
        )
        .toList();

    final dates =
        files
            .map((file) => file.path.split('attendance_')[1].split('.json')[0])
            .toList()
          ..sort((a, b) => b.compareTo(a));

    return dates;
  }

  @override
  Future<void> addAbsentRecords(List<String> absentNames) async {
    final directory = await getApplicationDocumentsDirectory();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final file = File('${directory.path}/attendance_$today.json');

    List<CheckInRecordModel> records = [];
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      records = jsonList.map((e) => CheckInRecordModel.fromJson(e)).toList();
    }
    for (var name in absentNames) {
      records.add(
        CheckInRecordModel(
          name: name,
          time: '--:--',
          similarity: 0.0,
          timestamp: DateTime.now(),
          status: 'absent',
        ),
      );
    }
    await file.writeAsString(
      json.encode(records.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<String> exportToCSV(
    String date,
    List<CheckInRecordModel> records,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final csvFile = File('${directory.path}/attendance_${date}_export.csv');

    final csvContent = StringBuffer();
    csvContent.writeln('Name,Time,Date,Similarity,Status');

    for (var record in records) {
      csvContent.writeln(
        '${record.name},${record.time},$date,${(record.similarity * 100).toStringAsFixed(1)}%,${record.status}',
      );
    }
    await csvFile.writeAsString(csvContent.toString());
    return csvFile.path;
  }

  @override
  Future<List<CheckInRecordModel>> getRecordsForDate(String date) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/attendance_$date.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      return jsonList.map((e) => CheckInRecordModel.fromJson(e)).toList();
    }
    return [];
  }
}
