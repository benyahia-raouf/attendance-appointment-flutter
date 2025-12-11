import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';

enum AttendanceFilter { all, presentOnly, late, presentAndLate, absent }

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<String> dates;
  final String? selectedDate;
  final List<CheckInRecord> records;
  final AttendanceFilter filter;

  HistoryLoaded({
    required this.dates,
    this.selectedDate,
    required this.records,
    this.filter = AttendanceFilter.presentAndLate,
  });

  List<CheckInRecord> get filteredRecords {
    switch (filter) {
      case AttendanceFilter.all:
        return records;
      case AttendanceFilter.presentOnly:
        return records.where((record) => record.status == 'present').toList();
      case AttendanceFilter.late:
        return records.where((record) => record.status == 'late').toList();
      case AttendanceFilter.presentAndLate:
        return records
            .where(
              (record) => record.status == 'present' || record.status == 'late',
            )
            .toList();
      case AttendanceFilter.absent:
        return records.where((record) => record.status == 'absent').toList();
    }
  }

  HistoryLoaded copyWith({
    List<String>? dates,
    String? selectedDate,
    List<CheckInRecord>? records,
    AttendanceFilter? filter,
  }) {
    return HistoryLoaded(
      dates: dates ?? this.dates,
      selectedDate: selectedDate ?? this.selectedDate,
      records: records ?? this.records,
      filter: filter ?? this.filter,
    );
  }
}

class HistoryGeneratingReport extends HistoryState {}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}
