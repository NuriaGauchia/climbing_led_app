class ClimbingRoute {
  final String name;
  final String grade;
  final List<int> holds;
  final String creator; // 👈 nuevo campo
  final bool done;

  ClimbingRoute({
    required this.name,
    required this.grade,
    required this.holds,
    required this.creator, // 👈 nuevo
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'grade': grade,
        'holds': holds,
        'creator': creator, // 👈 nuevo
        'done': done,
      };

  factory ClimbingRoute.fromJson(Map<String, dynamic> json) => ClimbingRoute(
        name: json['name'],
        grade: json['grade'],
        holds: List<int>.from(json['holds']),
        creator: json['creator'] ?? 'Usuario Desconocido', // 👈 fallback por si faltara
        done: json['done'] ?? false,
      );

  ClimbingRoute copyWith({bool? done}) {
    return ClimbingRoute(
      name: name,
      grade: grade,
      holds: holds,
      creator: creator,
      done: done ?? this.done,
    );
  }
}