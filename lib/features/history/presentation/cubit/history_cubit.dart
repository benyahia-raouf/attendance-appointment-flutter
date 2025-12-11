import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/history/domain/repositories/history_repository.dart';
import 'package:attendanceappointment/features/history/domain/usecases/get_available_dates.dart';
import 'package:attendanceappointment/features/history/domain/usecases/get_record_for_date.dart';
import 'package:attendanceappointment/features/history/presentation/cubit/history_state.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendanceappointment/core/usecase.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetAvailableDates getAvailableDates;
  final GetRecordsForDate getRecordsForDate;
  final HistoryRepository repository;

  HistoryCubit({
    required this.getAvailableDates,
    required this.getRecordsForDate,
    required this.repository,
  }) : super(HistoryInitial());

  Future<void> loadDates() async {
    emit(HistoryLoading());
    try {
      final dates = await getAvailableDates(NoParams());
      if (dates.isNotEmpty) {
        final records = await getRecordsForDate(dates.first);
        emit(
          HistoryLoaded(
            dates: dates,
            selectedDate: dates.first,
            records: records,
            filter: AttendanceFilter.presentOnly,
          ),
        );
      } else {
        emit(
          HistoryLoaded(
            dates: [],
            records: [],
            filter: AttendanceFilter.presentOnly,
          ),
        );
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> refreshCurrentDate() async {
    final currentState = state;
    if (currentState is HistoryLoaded && currentState.selectedDate != null) {
      try {
        final dates = await getAvailableDates(NoParams());
        final records = await getRecordsForDate(currentState.selectedDate!);
        emit(currentState.copyWith(dates: dates, records: records));
      } catch (e) {}
    }
  }

  Future<void> selectDate(String date) async {
    final currentState = state;
    if (currentState is HistoryLoaded) {
      emit(HistoryLoading());
      try {
        final records = await getRecordsForDate(date);
        emit(currentState.copyWith(selectedDate: date, records: records));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    }
  }

  void setFilter(AttendanceFilter filter) {
    final currentState = state;
    if (currentState is HistoryLoaded) {
      emit(currentState.copyWith(filter: filter));
    }
  }

  Future<void> generateEndOfDayReport(List<Employee> employee) async {
    emit(HistoryGeneratingReport());
    try {
      await repository.generateEndOfDayReport(employee);
      await loadDates();
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<String> exportToCSV(String date, List<CheckInRecord> records) async {
    return await repository.exportToCSV(date, records);
  }
}
