import 'package:attendanceappointment/core/usecase.dart';
import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/history/domain/repositories/history_repository.dart';

class GetRecordsForDate implements UseCase<List<CheckInRecord>, String> {
  final HistoryRepository repository;
  GetRecordsForDate(this.repository);

  @override
  Future<List<CheckInRecord>> call(String date) =>
      repository.getRecordsForDate(date);
}
