import 'package:attendanceappointment/core/usecase.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:attendanceappointment/features/registration/domain/repositories/employee_repository.dart';

class AddEmployee implements UseCase<void, Employee> {
  final EmployeeRepository repository;
  AddEmployee(this.repository);

  @override
  Future<void> call(Employee employee) => repository.addEmployee(employee);
}
