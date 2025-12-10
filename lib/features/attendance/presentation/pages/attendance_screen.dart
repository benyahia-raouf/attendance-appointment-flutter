import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:attendanceappointment/features/attendance/presentation/cubit/attendance_cubit.dart';
import 'package:attendanceappointment/features/attendance/presentation/cubit/attendance_state.dart';
import 'dart:io';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInCubit, CheckInState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: const Text(
              'Check-In',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (state is! CheckInSuccess && state is! CheckInFailed)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (state is CheckInScanning) {
                          context.read<CheckInCubit>().stopScanning();
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

                if (state is CheckInSuccess)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Check-In Successful',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: () {
                                context.read<CheckInCubit>().reset();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Check Another Person'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (state is CheckInFailed)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.cancel, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Employee Not Found',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: () {
                                context.read<CheckInCubit>().reset();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (state is CheckInError)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.error, size: 64, color: Colors.orange),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${state.message}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: () {
                                context.read<CheckInCubit>().reset();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
