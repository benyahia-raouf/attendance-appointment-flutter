import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/registration/entities/employee_entity.dart';

abstract class CheckInRepository {
  Future<List<double>?> extractEmbedding(dynamic file);
  Future<Employee?> findBestMatch(
    List<double> embedding,
    List<Employee> employee,
  );
  Future<void> saveCheckIn(CheckInRecord record);
  Future<bool> hasCheckedInToday(String name);
}
