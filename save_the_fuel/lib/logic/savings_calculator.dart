class SavingsTracker {
  static const double idleBurnRateLitersPerHour = 0.5;
  static const double fuelCostPerLiter = 170;

  static double idleLossPhp(int timeInSeconds) {
    return (timeInSeconds / 3600) * idleBurnRateLitersPerHour * fuelCostPerLiter;
  }

  static double litersSavedFromIdle(int timeInSeconds) {
    return (timeInSeconds / 3600) * idleBurnRateLitersPerHour;
  }
}
