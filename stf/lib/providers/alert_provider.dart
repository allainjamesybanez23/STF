import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/alert_model.dart';

class AlertProvider extends ChangeNotifier {
  late List<Alert> _activeAlerts;
  bool _isLoading = false;
  late String _userDeviceId;

  List<Alert> get activeAlerts =>
      _activeAlerts.where((a) => !a.isExpired).toList();
  bool get isLoading => _isLoading;

  AlertProvider() {
    _init();
  }

  Future<void> _init() async {
    _userDeviceId = await _getDeviceId();
    _loadHardcodedAlerts();
  }

  Future<String> _getDeviceId() async {
    // In production, use device_info_plus to get unique device ID
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _loadHardcodedAlerts() {
    // Initialize with hardcoded alerts at Cebu locations
    _activeAlerts = [
      Alert(
        id: '1',
        type: AlertType.accident,
        latitude: 10.3157,
        longitude: 123.8854,
        zoneName: 'SRP',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        createdByUserId: _userDeviceId,
      ),
      Alert(
        id: '2',
        type: AlertType.roadConstruction,
        latitude: 10.3246,
        longitude: 123.9134,
        zoneName: 'Mactan Bridge',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        createdByUserId: _userDeviceId,
      ),
      Alert(
        id: '3',
        type: AlertType.flooding,
        latitude: 10.2893,
        longitude: 123.8987,
        zoneName: 'Carbon Market',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        createdByUserId: _userDeviceId,
      ),
      Alert(
        id: '4',
        type: AlertType.event,
        latitude: 10.3120,
        longitude: 123.8765,
        zoneName: 'IT Park',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        createdByUserId: _userDeviceId,
      ),
    ];
    notifyListeners();
  }

  Future<void> reportAlert({
    required AlertType type,
    required double latitude,
    required double longitude,
    required String zoneName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final newAlert = Alert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        latitude: latitude,
        longitude: longitude,
        zoneName: zoneName,
        createdAt: DateTime.now(),
        createdByUserId: _userDeviceId,
      );

      _activeAlerts.insert(0, newAlert);
      print('Alert reported: ${type.name} at $zoneName');
    } catch (e) {
      print('Error reporting alert: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get nearby alerts within 2km radius
  List<Alert> getNearbyAlerts(double latitude, double longitude) {
    return activeAlerts.where((alert) {
      double distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        alert.latitude,
        alert.longitude,
      );
      return distance < 2000; // 2km radius
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
