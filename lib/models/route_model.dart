enum HoldType { start, path, finish, foot }

class ClimbingRoute {
  final String name;
  final String grade;
  final Map<int, HoldType> holds;
  final String creator;
  final bool done;

  ClimbingRoute({
    required this.name,
    required this.grade,
    required this.holds,
    required this.creator,
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'grade': grade,
        'holds': holds.map((key, value) => MapEntry(key.toString(), value.name)),
        'creator': creator,
        'done': done,
      };

  factory ClimbingRoute.fromJson(Map<String, dynamic> json) => ClimbingRoute(
        name: json['name'],
        grade: json['grade'],
        holds: Map<String, String>.from(json['holds'])
            .map((k, v) => MapEntry(
                  int.parse(k),
                  HoldType.values.firstWhere((e) => e.name == v, orElse: () => HoldType.path),
                )),
        creator: json['creator'] ?? 'Usuario Desconocido',
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