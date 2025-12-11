import 'package:attendanceappointment/features/registration/data/datasource/employee_local_datasource.dart';
import 'package:attendanceappointment/features/registration/data/models/employee_model.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:attendanceappointment/features/registration/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource localDataSource;

  EmployeeRepositoryImpl(this.localDataSource);

  @override
  Future<void> addEmployee(Employee employee) async {
    final model = EmployeeModel.fromEntity(employee);
    await localDataSource.addEmployee(model);
  }

  @override
  Future<void> deleteEmployee(String id) async {
    await localDataSource.deleteEmployee(id);
  }

  @override
  Future<List<Employee>> getAllEmployees() async {
    final models = await localDataSource.getAllEmployees();
    return models.map((m) => m.toEntity()).toList();
  }
}
