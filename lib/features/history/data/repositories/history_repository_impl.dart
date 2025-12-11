import 'package:attendanceappointment/features/attendance/data/models/attendance_model.dart';
import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/history/data/datasource/history_local_datasource.dart';
import 'package:attendanceappointment/features/history/domain/repositories/history_repository.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl(this.localDataSource);

  @override
  Future<String> exportToCSV(String date, List<CheckInRecord> records) async {
    final models = records
        .map((record) => CheckInRecordModel.fromEntity(record))
        .toList();
    return await localDataSource.exportToCSV(date, models);
  }

  @override
  Future<void> generateEndOfDayReport(List<Employee> employee) {
    // TODO: implement generateEndOfDayReport
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getAvailableDates() {
    return localDataSource.getAvailableDates();
  }

  @override
  Future<List<CheckInRecord>> getRecordsForDate(String date) async {
    final models = await localDataSource.getRecordsForDate(date);
    return models.map((m) => m.toEntity()).toList();
  }
}
