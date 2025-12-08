class CheckInRecord {
  final String name;
  final String time;
  final double similarity;
  final DateTime timestamp;
  final String status;

  CheckInRecord({
    required this.name,
    required this.time,
    required this.similarity,
    required this.timestamp,
    this.status = 'present',
  });
}
