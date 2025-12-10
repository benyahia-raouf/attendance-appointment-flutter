import 'package:attendanceappointment/core/api_client.dart';
import 'package:attendanceappointment/core/usecase.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:attendanceappointment/features/registration/domain/usecases/add_employee.dart';
import 'package:attendanceappointment/features/registration/domain/usecases/delete_employee.dart';
import 'package:attendanceappointment/features/registration/domain/usecases/get_all_employees.dart';
import 'package:attendanceappointment/features/registration/presentation/cubit/registration_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final GetAllEmployees getAllEmployees;
  final AddEmployee addEmployee;
  final DeleteEmployee deleteEmployee;
  final ApiClient apiClient;

  RegistrationCubit({
    required this.getAllEmployees,
    required this.addEmployee,
    required this.deleteEmployee,
    required this.apiClient,
  }) : super(RegistrationInitial());

  Future<void> loadEmployee() async {
    emit(RegistrationLoading());
    try {
      final employee = await getAllEmployees(NoParams());
      ;
      ;
      emit(RegistrationLoaded(employee));
    } catch (e) {
      emit(RegistrationError(e.toString()));
    }
  }

  Future<void> registerEmployee(String name, String imagePath) async {
    emit(RegistrationProcessing());
    try {
      final embedding = await apiClient.extractEmbedding(imagePath);

      if (embedding == null) {
        emit(RegistrationError('there is No face detected'));
        await loadEmployee();
        return;
      }

      final employee = Employee(
        id: const Uuid().v4(),
        name: name,
        imagePath: imagePath,
        embedding: embedding,
      );

      await addEmployee(employee);
      emit(RegistrationSuccess('$name registered successfully'));
      await loadEmployee();
    } catch (e) {
      emit(RegistrationError(e.toString()));
      await loadEmployee();
    }
  }

  Future<void> removePerson(String id) async {
    try {
      await deleteEmployee(id);
      await loadEmployee();
    } catch (e) {
      emit(RegistrationError(e.toString()));
    }
  }
}
