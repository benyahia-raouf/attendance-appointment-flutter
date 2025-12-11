import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/history/data/datasource/history_local_datasource.dart';
import 'package:attendanceappointment/features/history/domain/repositories/history_repository.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl(this.localDataSource);

  @override
  Future<String> exportToCSV(String date, List<CheckInRecord> records) {
    // TODO: implement exportToCSV
    throw UnimplementedError();
  }

  @override
  Future<void> generateEndOfDayReport(List<Employee> employee) {
    // TODO: implement generateEndOfDayReport
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getAvailableDates() {
    // TODO: implement getAvailableDates
    throw UnimplementedError();
  }

  @override
  Future<List<CheckInRecord>> getRecordsForDate(String date) {
    // TODO: implement getRecordsForDate
    throw UnimplementedError();
  }
}
