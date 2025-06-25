// lib/models/saving_goal.dart

class SavingGoal {
  String id;
  String name;
  double targetAmount;
  int durationMonths;
  double savedAmount;
  DateTime startDate;
  DateTime endDate;

  SavingGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.durationMonths,
    this.savedAmount = 0.0,
    required this.startDate,
    required this.endDate,
  });

  // Calculate daily saving target
  double get dailyTarget {
    final remainingAmount = targetAmount - savedAmount;
    final remainingDays = endDate.difference(DateTime.now()).inDays;
    return remainingDays > 0 ? remainingAmount / remainingDays : 0.0;
  }

  // Calculate weekly saving target
  double get weeklyTarget {
    return dailyTarget * 7;
  }

  // Calculate progress percentage
  double get progressPercentage {
    if (targetAmount == 0) return 0.0;
    return (savedAmount / targetAmount).clamp(0.0, 1.0); // Ensure it's between 0 and 1
  }
}
