// lib/features/registration/domain/usecases/delete_person.dart
import 'package:attendanceappointment/core/usecase.dart';
import 'package:attendanceappointment/features/registration/domain/repositories/employee_repository.dart';

class DeleteEmployee implements UseCase<void, String> {
  final EmployeeRepository repository;
  DeleteEmployee(this.repository);

  @override
  Future<void> call(String id) => repository.deleteEmployee(id);
}
