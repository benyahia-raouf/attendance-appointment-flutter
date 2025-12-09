import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';

abstract class CheckInState {}

class CheckInInitial extends CheckInState {}

class CheckInScanning extends CheckInState {
  final double? similarity;
  CheckInScanning({this.similarity});
}

class CheckInSuccess extends CheckInState {
  final Employee employee;
  final String time;
  final double similarity;
  final String status;

  CheckInSuccess(this.employee, this.time, this.similarity, this.status);
}

class CheckInFailed extends CheckInState {
  final double similarity;
  CheckInFailed(this.similarity);
}

class CheckInError extends CheckInState {
  final String message;
  CheckInError(this.message);
}
