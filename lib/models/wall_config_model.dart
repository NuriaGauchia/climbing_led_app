class WallConfig {
  final int rows;
  final int cols;
  final List<int> activeCells;

  WallConfig({
    required this.rows,
    required this.cols,
    required this.activeCells,
  });

  Map<String, dynamic> toJson() => {
        'rows': rows,
        'cols': cols,
        'activeCells': activeCells,
      };

  factory WallConfig.fromJson(Map<String, dynamic> json) => WallConfig(
        rows: json['rows'],
        cols: json['cols'],
        activeCells: List<int>.from(json['activeCells']),
      );
}