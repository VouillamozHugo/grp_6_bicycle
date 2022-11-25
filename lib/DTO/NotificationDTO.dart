class NotificationDTO {
  NotificationDTO({
    required this.problemDescription,
    required this.isValidatedByAdmin,
    required this.affectedRouteId,
    required this.problemType,
    required this.problemCoords,
  });

  final String problemDescription;
  final bool isValidatedByAdmin;
  final int affectedRouteId;
  final String problemType;
  final Map<String, double> problemCoords;
}
