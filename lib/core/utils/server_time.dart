/// Marks a server timestamp as UTC when it has no zone.
///
/// Some MoveM endpoints (task deadline, start and reminder times) return
/// times like `2026-11-10T16:59:00` that are UTC but carry no `Z`. Dart reads
/// those as device-local time, which in Cambodia (UTC+7) shows them 7 hours
/// early and shifts the deadline back on every save. Date-only values and
/// values that already have a zone are returned unchanged.
String? asServerUtc(String? value) {
  if (value == null || value.isEmpty || !value.contains('T')) return value;
  final hasZone = value.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(value);
  return hasZone ? value : '${value}Z';
}
