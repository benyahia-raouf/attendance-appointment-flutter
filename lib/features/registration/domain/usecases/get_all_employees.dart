import 'package:attendanceappointment/core/usecase.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:attendanceappointment/features/registration/domain/repositories/employee_repository.dart';

class GetAllEmployees implements UseCase<List<Employee>, NoParams> {
  final EmployeeRepository repository;
  GetAllEmployees(this.repository);

  @override
  Future<List<Employee>> call(NoParams params) => repository.getAllEmployees();
}
