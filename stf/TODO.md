# Alerto MVP TODO

## Approved Plan Steps (Core Loop Priority)

1. ✅ [DONE] Plan confirmed with Figma link.
2. Create lib/models/vehicle_model.dart, trip_model.dart.
3. Create lib/services/location_service.dart, tts_service.dart.
4. Create lib/providers/traffic_provider.dart (live location → zone → TTS/UI).
5. Update lib/services/traffic_service.dart (add SRP, Minglanilla hotspots).
6. Update lib/theme.dart (define SugboColors).
7. Create lib/screens/savings_screen.dart (fuel savings calc).
8. Update lib/screens/hud_screen.dart (Provider, live updates, report stub).
9. Update lib/screens/map_screen.dart (Google Maps, live marker).
10. Create lib/screens/home_screen.dart (bottom nav HUD/Map/Savings).
11. Update lib/main.dart (Providers, Firebase init, HomeScreen).
12. Update pubspec.yaml (assets if needed).
13. Android/iOS perms, Firebase config notes.
14. `flutter pub get && flutter run` test.
15. Mark complete.

Progress: Steps 2-7 done (savings, home nav). Hotspots, UI integration next.
