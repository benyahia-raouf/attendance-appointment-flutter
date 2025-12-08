class CheckInHelper {
  static const int lateBarHour = 8;
  static const int lateBarMinute = 00;

  static String classifyStatus(DateTime checkInTime) {
    final cutoffTime = DateTime(
      checkInTime.year,
      checkInTime.month,
      checkInTime.day,
      lateBarHour,
      lateBarMinute,
    );

    return checkInTime.isAfter(cutoffTime) ? 'late' : 'present';
  }

  static String determineStatusFromTimeString(String timeString) {
    final now = DateTime.now();
    return classifyStatus(now);
  }
}
