class ClimbingRoute {
  final String name;
  final String grade;
  final List<int> holds;
  final bool done; // 👈 nuevo campo

  ClimbingRoute({
    required this.name,
    required this.grade,
    required this.holds,
    this.done = false, // por defecto, no hecho
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'grade': grade,
        'holds': holds,
        'done': done,
      };

  factory ClimbingRoute.fromJson(Map<String, dynamic> json) => ClimbingRoute(
        name: json['name'],
        grade: json['grade'],
        holds: List<int>.from(json['holds']),
        done: json['done'] ?? false, // para compatibilidad con datos anteriores
      );

  ClimbingRoute copyWith({bool? done}) {
    return ClimbingRoute(
      name: name,
      grade: grade,
      holds: holds,
      done: done ?? this.done,
    );
  }
}