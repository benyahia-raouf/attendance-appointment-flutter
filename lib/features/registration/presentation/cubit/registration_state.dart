import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';

abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationLoaded extends RegistrationState {
  final List<Employee> employee;
  RegistrationLoaded(this.employee);
}

class RegistrationProcessing extends RegistrationState {}

class RegistrationError extends RegistrationState {
  final String message;
  RegistrationError(this.message);
}

class RegistrationSuccess extends RegistrationState {
  final String message;
  RegistrationSuccess(this.message);
}
