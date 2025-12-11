import 'package:attendanceappointment/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:attendanceappointment/features/attendance/presentation/cubit/attendance_state.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:attendanceappointment/features/registration/presentation/cubit/registration_cubit.dart';
import 'package:attendanceappointment/features/registration/presentation/cubit/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class AttendanceScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const AttendanceScreen({super.key, required this.cameras});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) return;

    final camera = widget.cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      print('Camera error: $e');
    }
  }

  Future<void> _processFrame() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();

      final embedding = await context
          .read<CheckInCubit>()
          .repository
          .extractEmbedding(bytes);
      if (embedding != null) {
        final persons =
            context.read<RegistrationCubit>().state is RegistrationLoaded
            ? (context.read<RegistrationCubit>().state as RegistrationLoaded)
                  .employee
            : <Employee>[];

        await context.read<CheckInCubit>().performCheckIn(embedding, persons);
      }
    } catch (e) {
      print('Process error: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Check-In'), centerTitle: true),
      body: BlocConsumer<CheckInCubit, CheckInState>(
        listener: (context, state) {
          if (state is CheckInError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Camera Preview
                Card(
                  child: Container(
                    height: 450,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _isCameraInitialized
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                CameraPreview(_cameraController!),
                                if (state is CheckInScanning)
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    right: 20,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Scanning...',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (state.similarity != null) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              '${(state.similarity! * 100).toStringAsFixed(1)}%',
                                              style: const TextStyle(
                                                color: Colors.greenAccent,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (state is! CheckInSuccess && state is! CheckInFailed)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (state is CheckInScanning) {
                          context.read<CheckInCubit>().stopScanning();
                        } else {
                          final persons =
                              context.read<RegistrationCubit>().state
                                  is RegistrationLoaded
                              ? (context.read<RegistrationCubit>().state
                                        as RegistrationLoaded)
                                    .employee
                              : <Employee>[];

                          if (persons.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please register people first'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          } else {
                            context.read<CheckInCubit>().startScanning(persons);
                            _processFrame();
                          }
                        }
                      },
                      icon: Icon(
                        state is CheckInScanning
                            ? Icons.stop
                            : Icons.face_retouching_natural,
                      ),
                      label: Text(
                        state is CheckInScanning
                            ? 'Stop Scanning'
                            : 'Start Check-In',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: state is CheckInScanning
                            ? Colors.red
                            : const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                if (state is CheckInSuccess || state is CheckInFailed)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            state is CheckInSuccess
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 64,
                            color: state is CheckInSuccess
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state is CheckInSuccess
                                ? 'Check-In Successful'
                                : 'Person Not Found',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: state is CheckInSuccess
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (state is CheckInSuccess) ...[
                            CircleAvatar(
                              backgroundImage: FileImage(
                                File(state.employee.imagePath),
                              ),
                              radius: 50,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.employee.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.access_time, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Time: ${state.time}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Text(
                                  //     'Match: ${(state.similarity * 100).toStringAsFixed(1)}%',
                                  //     style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                  //   ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: () =>
                                  context.read<CheckInCubit>().reset(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Check Another Person'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
