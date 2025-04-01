class ClimbingRoute {
  final String name;
  final String grade;
  final List<int> holds;

  ClimbingRoute({
    required this.name,
    required this.grade,
    required this.holds,
  });

  // Para guardar como JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'grade': grade,
        'holds': holds,
      };

  // Para leer desde JSON
  factory ClimbingRoute.fromJson(Map<String, dynamic> json) {
    return ClimbingRoute(
      name: json['name'],
      grade: json['grade'],
      holds: List<int>.from(json['holds']),
    );
  }
}