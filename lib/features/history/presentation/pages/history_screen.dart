import 'dart:io';
import 'package:attendanceappointment/features/history/presentation/cubit/history_cubit.dart';
import 'package:attendanceappointment/features/history/presentation/cubit/history_state.dart';
import 'package:attendanceappointment/features/registration/domain/entities/employee_entity.dart';
import 'package:attendanceappointment/features/registration/presentation/cubit/registration_cubit.dart';
import 'package:attendanceappointment/features/registration/presentation/cubit/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  String _formatDate(String date) {
    final dt = DateTime.parse(date);
    return DateFormat('EEEE, MMMM d, yyyy').format(dt);
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    AttendanceFilter filter,
    AttendanceFilter currentFilter,
  ) {
    final isSelected = filter == currentFilter;

    Color getColor() {
      switch (filter) {
        case AttendanceFilter.all:
          return const Color(0xFF2196F3);
        case AttendanceFilter.presentOnly:
          return const Color(0xFF4CAF50);
        case AttendanceFilter.late:
          return Colors.orange;
        case AttendanceFilter.presentAndLate:
          return const Color(0xFF00BCD4);
        case AttendanceFilter.absent:
          return Colors.red;
      }
    }

    String getLabel() {
      switch (filter) {
        case AttendanceFilter.all:
          return 'All';
        case AttendanceFilter.presentOnly:
          return 'On Time';
        case AttendanceFilter.late:
          return 'Late';
        case AttendanceFilter.presentAndLate:
          return 'Present + Late';
        case AttendanceFilter.absent:
          return 'Absent';
      }
    }

    final color = getColor();

    return FilterChip(
      selected: isSelected,
      label: Text(getLabel()),
      onSelected: (_) => context.read<HistoryCubit>().setFilter(filter),
      backgroundColor: Colors.white,
      selectedColor: color.withAlpha(51),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? color : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Employee? _findPersonByName(List<Employee> persons, String name) {
    try {
      return persons.firstWhere(
        (person) => person.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildProfileImage(String? imagePath, Color statusColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: statusColor.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withAlpha(77), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: imagePath != null && File(imagePath).existsSync()
            ? Image.file(
                File(imagePath),
                fit: BoxFit.cover,
                cacheHeight: 100,
                cacheWidth: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, color: statusColor, size: 28);
                },
              )
            : Icon(Icons.person, color: statusColor, size: 28),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Attendance History'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HistoryCubit>().refreshCurrentDate(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading || state is HistoryGeneratingReport) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HistoryLoaded) {
            if (state.dates.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text(
                      'No attendance records yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            final presentCount = state.records
                .where((r) => r.status == 'present')
                .length;
            final absentCount = state.records
                .where((r) => r.status == 'absent')
                .length;
            final lateCount = state.records
                .where((r) => r.status == 'late')
                .length;
            final attendanceRate = state.records.isEmpty
                ? 0
                : (presentCount / state.records.length * 100).toStringAsFixed(
                    0,
                  );

            final filteredRecords = state.filteredRecords;

            final persons =
                context.read<RegistrationCubit>().state is RegistrationLoaded
                ? (context.read<RegistrationCubit>().state
                          as RegistrationLoaded)
                      .employee
                : <Employee>[];

            return Column(
              children: [
                Container(
                  color: Colors.grey.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Selector
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  value: state.selectedDate,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.calendar_today,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: state.dates.map((date) {
                                    return DropdownMenuItem(
                                      value: date,
                                      child: Text(_formatDate(date)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      context.read<HistoryCubit>().selectDate(
                                        value,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Filter Chips
                        Row(
                          children: [
                            Text(
                              'Filter:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildFilterChip(
                                      context,
                                      AttendanceFilter.presentAndLate,
                                      state.filter,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildFilterChip(
                                      context,
                                      AttendanceFilter.presentOnly,
                                      state.filter,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildFilterChip(
                                      context,
                                      AttendanceFilter.late,
                                      state.filter,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildFilterChip(
                                      context,
                                      AttendanceFilter.absent,
                                      state.filter,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildFilterChip(
                                      context,
                                      AttendanceFilter.all,
                                      state.filter,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Check-in Records (${filteredRecords.length})',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: filteredRecords.isEmpty
                      ? Center(
                          child: Card(
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Text(
                                state.records.isEmpty
                                    ? 'No check-ins for this date'
                                    : 'No ${state.filter.name} records',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredRecords.length,
                          itemBuilder: (context, index) {
                            final record = filteredRecords[index];

                            Color getStatusColor() {
                              switch (record.status) {
                                case 'present':
                                  return Colors.green;
                                case 'absent':
                                  return Colors.red;
                                case 'late':
                                  return Colors.orange;
                                default:
                                  return Colors.grey;
                              }
                            }

                            String getStatusLabel() {
                              return record.status[0].toUpperCase() +
                                  record.status.substring(1);
                            }

                            final statusColor = getStatusColor();
                            final person = _findPersonByName(
                              persons,
                              record.name,
                            );

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: _buildProfileImage(
                                  person?.imagePath,
                                  statusColor,
                                ),
                                title: Text(
                                  record.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(record.time),
                                    // Text('Match: ${(record.similarity * 100).toStringAsFixed(1)}%',
                                    //     style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: statusColor),
                                  ),
                                  child: Text(
                                    getStatusLabel(),
                                    style: TextStyle(
                                      color:
                                          statusColor.computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                Container(
                  color: Colors.grey.shade50,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Export Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: state.records.isEmpty
                              ? null
                              : () async {
                                  final persons =
                                      context.read<RegistrationCubit>().state
                                          is RegistrationLoaded
                                      ? (context.read<RegistrationCubit>().state
                                                as RegistrationLoaded)
                                            .employee
                                      : <Employee>[];

                                  await context
                                      .read<HistoryCubit>()
                                      .generateEndOfDayReport(persons);

                                  final path = await context
                                      .read<HistoryCubit>()
                                      .exportToCSV(
                                        state.selectedDate!,
                                        state.records,
                                      );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Report exported to: $path',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.download),
                          label: const Text('Export Report to CSV'),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
