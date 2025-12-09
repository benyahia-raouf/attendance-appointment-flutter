import 'dart:io';
import 'dart:convert';
import 'package:attendanceappointment/features/attendance/data/models/attendance_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

abstract class CheckInLocalDataSource {
  Future<void> saveCheckIn(CheckInRecordModel record);
  Future<bool> hasCheckedInToday(String name);
}

class CheckInLocalDataSourceImpl implements CheckInLocalDataSource {
  @override
  Future<void> saveCheckIn(CheckInRecordModel record) async {
    final directory = await getApplicationDocumentsDirectory();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final file = File('${directory.path}/attendance_$today.json');

    List<CheckInRecordModel> records = [];
    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      records = jsonList.map((e) => CheckInRecordModel.fromJson(e)).toList();
    }

    records.add(record);
    await file.writeAsString(
      json.encode(records.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<bool> hasCheckedInToday(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final file = File('${directory.path}/attendance_$today.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      final List<dynamic> jsonList = json.decode(content);
      final records = jsonList
          .map((e) => CheckInRecordModel.fromJson(e))
          .toList();
      return records.any((r) => r.name == name);
    }
    return false;
  }
}
