class TripDates {
  static final TripDates _instance = TripDates._internal();

  DateTime? startDate;
  DateTime? endDate;

  factory TripDates() {
    return _instance;
  }

  TripDates._internal();
}
