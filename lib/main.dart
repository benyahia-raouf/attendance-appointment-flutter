import 'package:attendanceappointment/core/navigation.dart';
import 'package:attendanceappointment/core/api_client.dart';
import 'package:attendanceappointment/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:attendanceappointment/features/history/presentation/cubit/history_cubit.dart';
import 'package:attendanceappointment/features/registration/data/models/employee_model.dart';
import 'package:attendanceappointment/features/registration/presentation/cubit/registration_cubit.dart';
import 'package:attendanceappointment/features/registration/domain/usecases/add_employee.dart';
import 'package:attendanceappointment/features/registration/domain/usecases/delete_employee.dart';
import 'package:attendanceappointment/features/registration/domain/usecases/get_all_employees.dart';
import 'package:attendanceappointment/features/history/domain/usecases/get_available_dates.dart';
import 'package:attendanceappointment/features/history/domain/usecases/get_record_for_date.dart';
import 'package:attendanceappointment/features/registration/data/repositories/employee_repository_impl.dart';
import 'package:attendanceappointment/features/registration/data/datasource/employee_local_datasource.dart';
import 'package:attendanceappointment/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:attendanceappointment/features/attendance/data/datasource/attendance_local_datasource.dart';
import 'package:attendanceappointment/features/history/data/repositories/history_repository_impl.dart';
import 'package:attendanceappointment/features/history/data/datasource/history_local_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeModelAdapter());

  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    final employeeLocalDataSource = EmployeeLocalDataSourceImpl();
    final checkInLocalDataSource = CheckInLocalDataSourceImpl();
    final historyLocalDataSource = HistoryLocalDataSourceImpl();

    final employeeRepository = EmployeeRepositoryImpl(employeeLocalDataSource);
    final apiClient = ApiClient();
    final checkInRepository = CheckInRepositoryImpl(
      apiClient,
      checkInLocalDataSource,
    );
    final historyRepository = HistoryRepositoryImpl(historyLocalDataSource);

    final getAllEmployees = GetAllEmployees(employeeRepository);
    final addEmployee = AddEmployee(employeeRepository);
    final deleteEmployee = DeleteEmployee(employeeRepository);
    final getAvailableDates = GetAvailableDates(historyRepository);
    final getRecordsForDate = GetRecordsForDate(historyRepository);

    final registrationCubit = RegistrationCubit(
      getAllEmployees: getAllEmployees,
      addEmployee: addEmployee,
      deleteEmployee: deleteEmployee,
      apiClient: apiClient,
    );

    final checkInCubit = CheckInCubit(checkInRepository);

    final historyCubit = HistoryCubit(
      getAvailableDates: getAvailableDates,
      getRecordsForDate: getRecordsForDate,
      repository: historyRepository,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => registrationCubit..loadEmployee()),
        BlocProvider(create: (_) => checkInCubit),
        BlocProvider(create: (_) => historyCubit..loadDates()),
      ],
      child: MaterialApp(
        title: 'Face Recognition',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        home: NavigationScreen(cameras: cameras),
      ),
    );
  }
}
