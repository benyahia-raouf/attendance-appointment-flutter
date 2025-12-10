import 'package:attendanceappointment/features/registration/data/models/employee_model.dart';
import 'package:hive/hive.dart';

abstract class EmployeeLocalDataSource {
  Future<List<EmployeeModel>> getAllEmployees();
  Future<void> addEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(String id);
}

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  static const String boxName = 'persons';

  @override
  Future<List<EmployeeModel>> getAllEmployees() async {
    final box = await Hive.openBox<EmployeeModel>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> addEmployee(EmployeeModel employee) async {
    final box = await Hive.openBox<EmployeeModel>(boxName);
    await box.put(employee.id, employee);
  }

  @override
  Future<void> deleteEmployee(String id) async {
    final box = await Hive.openBox<EmployeeModel>(boxName);
    await box.delete(id);
  }
}
