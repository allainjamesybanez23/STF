enum VehicleType {
  traditionalJeep(6.0), // km/L
  modernJeep(8.0),
  bus(4.0);

  const VehicleType(this.kmPerLiter);
  final double kmPerLiter;
}

class FuelSavingsCalculator {
  static double calculateFuelCost(
    double distanceKm,
    double kmPerLiter,
    double pricePerLiter,
  ) {
    return (distanceKm / kmPerLiter) * pricePerLiter;
  }

  static double estimateIdlingSavings(
    double idleMinutes,
    double kmPerLiter,
    double pricePerLiter,
  ) {
    // Assume idling wastes 0.1L/hour per vehicle type adjustment
    double wastePerHour = 0.5 / kmPerLiter; // heuristic
    return (wastePerHour * (idleMinutes / 60)) * pricePerLiter;
  }
}
