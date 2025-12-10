import 'package:attendanceappointment/features/attendance/presentation/pages/attendance_screen.dart';
import 'package:attendanceappointment/features/registration/presentation/pages/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class NavigationScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const NavigationScreen({super.key, required this.cameras});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  void _selectedscreen(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [const RegistrationScreen(), AttendanceScreen()];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectedscreen,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_add_outlined),
            selectedIcon: Icon(Icons.person_add),
            label: 'Register',
          ),
          NavigationDestination(
            icon: Icon(Icons.face_outlined),
            selectedIcon: Icon(Icons.face),
            label: 'Check-In',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
