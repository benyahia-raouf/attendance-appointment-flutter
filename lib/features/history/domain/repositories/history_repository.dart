import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';

abstract class HistoryRepository {
  Future<List<String>> getAvailableDates();
  Future<List<CheckInRecord>> getRecordsForDate(String date);
  Future<void> generateEndOfDayReport(List<Employee> employee);
  Future<String> exportToCSV(String date, List<CheckInRecord> records);
}
