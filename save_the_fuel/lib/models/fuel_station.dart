import 'package:latlong2/latlong.dart';

enum FuelType { diesel, ron91, ron95, ron97 }

String fuelTypeLabel(FuelType type) {
  switch (type) {
    case FuelType.diesel:
      return 'Diesel';
    case FuelType.ron91:
      return 'RON 91';
    case FuelType.ron95:
      return 'RON 95';
    case FuelType.ron97:
      return 'RON 97';
  }
}

class FuelStation {
  const FuelStation({
    required this.name,
    required this.brand,
    required this.location,
    required this.pricesThisWeek,
    required this.pricesLastWeek,
    this.verified = false,
  });

  final String name;
  final String brand;
  final LatLng location;
  final Map<FuelType, double> pricesThisWeek;
  final Map<FuelType, double> pricesLastWeek;
  final bool verified;

  double priceFor(FuelType type) => pricesThisWeek[type] ?? 0;
  double lastWeekPriceFor(FuelType type) => pricesLastWeek[type] ?? 0;
  double deltaFor(FuelType type) => priceFor(type) - lastWeekPriceFor(type);

  FuelStation copyWith({bool? verified}) {
    return FuelStation(
      name: name,
      brand: brand,
      location: location,
      pricesThisWeek: pricesThisWeek,
      pricesLastWeek: pricesLastWeek,
      verified: verified ?? this.verified,
    );
  }
}
