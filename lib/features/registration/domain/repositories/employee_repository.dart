import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getAllEmployees();
  Future<void> addEmployee(Employee employee);
  Future<void> deleteEmployee(String id);
}
