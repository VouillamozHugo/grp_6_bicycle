class RouteDTO {
  RouteDTO(
      {required this.routeName,
      required this.startPoint,
      required this.endPoint,
      required this.longitudeList,
      required this.lattitudeList,
      required this.distanceKm,
      required this.durationMinutes,
      required this.heightDiffUpMeters,
      required this.heightDiffDownMeters});

  final String routeName;
  final String startPoint;
  final String endPoint;
  final List<double> longitudeList;
  final List<double> lattitudeList;
  final int distanceKm;
  final int durationMinutes;
  final int heightDiffUpMeters;
  final int heightDiffDownMeters;
}
