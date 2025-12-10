import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:hive/hive.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class EmployeeModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String imagePath;

  @HiveField(3)
  late List<double> embedding;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.embedding,
  });

  Employee toEntity() =>
      Employee(id: id, name: name, imagePath: imagePath, embedding: embedding);

  factory EmployeeModel.fromEntity(Employee employee) => EmployeeModel(
    id: employee.id,
    name: employee.name,
    imagePath: employee.imagePath,
    embedding: employee.embedding,
  );
}
