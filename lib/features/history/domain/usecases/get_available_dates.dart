import 'package:attendanceappointment/core/usecase.dart';
import 'package:attendanceappointment/features/history/domain/repositories/history_repository.dart';

class GetAvailableDates implements UseCase<List<String>, NoParams> {
  final HistoryRepository repository;
  GetAvailableDates(this.repository);

  @override
  Future<List<String>> call(NoParams params) => repository.getAvailableDates();
}
