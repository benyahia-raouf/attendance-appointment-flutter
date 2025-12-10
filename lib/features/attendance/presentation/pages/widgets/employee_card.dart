import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.people,
                size: 34,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('List of registred employees'),
                  Text(
                    'Registred employee',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
