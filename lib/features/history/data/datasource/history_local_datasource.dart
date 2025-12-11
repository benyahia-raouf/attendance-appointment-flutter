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
