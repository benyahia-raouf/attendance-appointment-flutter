import 'package:attendanceappointment/core/api_client.dart';
import 'package:attendanceappointment/features/attendance/data/datasource/attendance_local_datasource.dart';
import 'package:attendanceappointment/features/attendance/data/models/attendance_model.dart';
import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';

class CheckInRepositoryImpl implements CheckInRepository {
  final ApiClient apiClient;
  final CheckInLocalDataSource localDataSource;

  CheckInRepositoryImpl(this.apiClient, this.localDataSource);

  @override
  Future<List<double>?> extractEmbedding(dynamic file) {
    return apiClient.extractEmbedding(file);
  }

  @override
  Future<Employee?> findBestMatch(
    List<double> embedding,
    List<Employee> employee,
  ) async {
    final dbEmbeddings = employee.map((p) => p.embedding).toList();
    final result = await apiClient.findBestMatch(embedding, dbEmbeddings);

    if (result['success'] == true && result['match'] == true) {
      return employee[result['best_match_index']];
    }
    return null;
  }

  @override
  Future<void> saveCheckIn(CheckInRecord record) async {
    final model = CheckInRecordModel.fromEntity(record);
    await localDataSource.saveCheckIn(model);
  }

  @override
  Future<bool> hasCheckedInToday(String name) {
    return localDataSource.hasCheckedInToday(name);
  }
}
