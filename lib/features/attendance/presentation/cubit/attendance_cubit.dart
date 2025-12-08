import 'package:attendanceappointment/core/attendance_helper.dart';
import 'package:attendanceappointment/features/attendance/domain/entities/attendance_entity.dart';
import 'package:attendanceappointment/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:attendanceappointment/features/attendance/presentation/cubit/attendance_state.dart';
import 'package:attendanceappointment/features/registration/entities/employee_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class CheckInCubit extends Cubit<CheckInState> {
  final CheckInRepository repository;
  Timer? _scanTimer;

  CheckInCubit(this.repository) : super(CheckInInitial());

  void startScanning(List<Employee> employee) {
    emit(CheckInScanning());
    _scanTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => processFrame(employee),
    );
  }

  void stopScanning() {
    _scanTimer?.cancel();
    emit(CheckInInitial());
  }

  Future<void> processFrame(List<Employee> employee) async {}

  Future<void> performCheckIn(
    List<double> embedding,
    List<Employee> employee,
  ) async {
    try {
      final match = await repository.findBestMatch(embedding, employee);

      if (match != null) {
        final hasCheckedIn = await repository.hasCheckedInToday(match.name);

        if (hasCheckedIn) {
          emit(CheckInError('Already checked in today'));
          return;
        }

        final now = DateTime.now();
        final time = DateFormat('HH:mm').format(now);
        final status = CheckInHelper.classifyStatus(now);

        final record = CheckInRecord(
          name: match.name,
          time: time,
          similarity: 0.8,
          timestamp: now,
          status: status,
        );

        await repository.saveCheckIn(record);
        emit(CheckInSuccess(match, time, 0.8, status));
      } else {
        emit(CheckInFailed(0.3));
      }
    } catch (e) {
      emit(CheckInError(e.toString()));
    }
  }

  void reset() {
    emit(CheckInInitial());
  }

  @override
  Future<void> close() {
    _scanTimer?.cancel();
    return super.close();
  }
}
