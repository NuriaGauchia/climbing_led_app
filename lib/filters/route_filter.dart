import '../models/route_model.dart';

class RouteFilter {
  String name;
  String creator;
  String? minGrade;
  String? maxGrade;
  String done; // 'todos', 'hechos', 'no_hechos'

  RouteFilter({
    this.name = '',
    this.creator = '',
    this.minGrade,
    this.maxGrade,
    this.done = 'todos',
  });
}

List<ClimbingRoute> applyFilters(
  List<ClimbingRoute> routes,
  RouteFilter filter,
  List<String> grades,
) {
  final minIndex = filter.minGrade != null ? grades.indexOf(filter.minGrade!) : 0;
  final maxIndex = filter.maxGrade != null ? grades.indexOf(filter.maxGrade!) : grades.length - 1;

  return routes.where((route) {
    final matchesName = route.name.toLowerCase().contains(filter.name.toLowerCase());
    final matchesCreator = route.creator.toLowerCase().contains(filter.creator.toLowerCase());
    final routeIndex = grades.indexOf(route.grade);
    final matchesGrade = routeIndex >= minIndex && routeIndex <= maxIndex;
    final matchesDone = filter.done == 'todos' ||
        (filter.done == 'hechos' && route.done) ||
        (filter.done == 'no_hechos' && !route.done);

    return matchesName && matchesCreator && matchesGrade && matchesDone;
  }).toList();
}

