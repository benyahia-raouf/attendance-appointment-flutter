import 'package:attendanceappointment/core/usecase.dart';
import 'package:attendanceappointment/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:attendanceappointment/features/registration/entities/employee_entity.dart';

class PerformCheckIn implements UseCase<Employee?, List<double>> {
  final CheckInRepository repository;
  PerformCheckIn(this.repository);

  @override
  Future<Employee?> call(List<double> embedding) async {
    return null;
  }
}
