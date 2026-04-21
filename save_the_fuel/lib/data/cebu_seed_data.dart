import 'package:latlong2/latlong.dart';
import 'package:save_the_fuel/models/fuel_station.dart';
import 'package:save_the_fuel/models/geofence.dart';

const List<Geofence> cebuGeofences = [
  Geofence(
    name: 'Mactan Bridge',
    center: LatLng(10.3077, 123.9637),
    radiusMeters: 450,
    type: ZoneType.red,
  ),
  Geofence(
    name: 'SRP Coastal',
    center: LatLng(10.2794, 123.8788),
    radiusMeters: 600,
    type: ZoneType.green,
  ),
  Geofence(
    name: 'Colon Street',
    center: LatLng(10.2954, 123.8992),
    radiusMeters: 350,
    type: ZoneType.amber,
  ),
  Geofence(
    name: 'Cebu City Sports Complex Intersection',
    center: LatLng(10.3108, 123.9028),
    radiusMeters: 220,
    type: ZoneType.red,
  ),
];

const List<FuelStation> hardcodedStations = [
  FuelStation(
    name: 'Seaoil SRP',
    brand: 'Seaoil',
    location: LatLng(10.2798, 123.8801),
    pricesThisWeek: {
      FuelType.diesel: 53.0,
      FuelType.ron91: 59.2,
      FuelType.ron95: 61.8,
      FuelType.ron97: 67.0,
    },
    pricesLastWeek: {
      FuelType.diesel: 53.4,
      FuelType.ron91: 59.8,
      FuelType.ron95: 62.3,
      FuelType.ron97: 67.5,
    },
  ),
  FuelStation(
    name: 'Caltex Mandaue',
    brand: 'Caltex',
    location: LatLng(10.3390, 123.9340),
    pricesThisWeek: {
      FuelType.diesel: 55.0,
      FuelType.ron91: 60.4,
      FuelType.ron95: 63.0,
      FuelType.ron97: 68.7,
    },
    pricesLastWeek: {
      FuelType.diesel: 55.1,
      FuelType.ron91: 60.7,
      FuelType.ron95: 63.5,
      FuelType.ron97: 69.0,
    },
  ),
  FuelStation(
    name: 'Petron Colon',
    brand: 'Petron',
    location: LatLng(10.2941, 123.9014),
    pricesThisWeek: {
      FuelType.diesel: 58.0,
      FuelType.ron91: 61.2,
      FuelType.ron95: 63.9,
      FuelType.ron97: 69.2,
    },
    pricesLastWeek: {
      FuelType.diesel: 57.8,
      FuelType.ron91: 61.0,
      FuelType.ron95: 64.2,
      FuelType.ron97: 69.3,
    },
  ),
  FuelStation(
    name: 'Unioil Banilad',
    brand: 'Unioil',
    location: LatLng(10.3448, 123.9068),
    pricesThisWeek: {
      FuelType.diesel: 59.0,
      FuelType.ron91: 60.6,
      FuelType.ron95: 63.2,
      FuelType.ron97: 67.9,
    },
    pricesLastWeek: {
      FuelType.diesel: 59.3,
      FuelType.ron91: 61.0,
      FuelType.ron95: 63.6,
      FuelType.ron97: 68.2,
    },
  ),
  FuelStation(
    name: 'Shell Carbon Market',
    brand: 'Shell',
    location: LatLng(10.2911, 123.8975),
    pricesThisWeek: {
      FuelType.diesel: 62.0,
      FuelType.ron91: 62.4,
      FuelType.ron95: 65.3,
      FuelType.ron97: 71.0,
    },
    pricesLastWeek: {
      FuelType.diesel: 61.7,
      FuelType.ron91: 62.2,
      FuelType.ron95: 65.1,
      FuelType.ron97: 70.7,
    },
  ),
  FuelStation(
    name: 'PTT IT Park',
    brand: 'PTT',
    location: LatLng(10.3305, 123.9048),
    pricesThisWeek: {
      FuelType.diesel: 67.0,
      FuelType.ron91: 63.0,
      FuelType.ron95: 65.9,
      FuelType.ron97: 72.2,
    },
    pricesLastWeek: {
      FuelType.diesel: 67.4,
      FuelType.ron91: 63.5,
      FuelType.ron95: 66.1,
      FuelType.ron97: 72.4,
    },
  ),
  FuelStation(
    name: 'Phoenix Mactan',
    brand: 'Phoenix',
    location: LatLng(10.2975, 123.9730),
    pricesThisWeek: {
      FuelType.diesel: 70.0,
      FuelType.ron91: 64.0,
      FuelType.ron95: 66.8,
      FuelType.ron97: 73.6,
    },
    pricesLastWeek: {
      FuelType.diesel: 69.7,
      FuelType.ron91: 63.8,
      FuelType.ron95: 66.6,
      FuelType.ron97: 73.2,
    },
  ),
  FuelStation(
    name: 'Jetti N. Bacalso',
    brand: 'Jetti',
    location: LatLng(10.2817, 123.8719),
    pricesThisWeek: {
      FuelType.diesel: 56.0,
      FuelType.ron91: 59.9,
      FuelType.ron95: 62.6,
      FuelType.ron97: 68.1,
    },
    pricesLastWeek: {
      FuelType.diesel: 56.3,
      FuelType.ron91: 60.2,
      FuelType.ron95: 62.9,
      FuelType.ron97: 68.4,
    },
  ),
];

const List<TrafficRoadSegment> cebuRoadSegments = [
  TrafficRoadSegment(
    name: 'Mactan Bridge Span',
    type: ZoneType.red,
    points: [
      LatLng(10.3073, 123.9566),
      LatLng(10.3078, 123.9615),
      LatLng(10.3084, 123.9669),
      LatLng(10.3090, 123.9714),
    ],
  ),
  TrafficRoadSegment(
    name: 'Colon Corridor',
    type: ZoneType.amber,
    points: [
      LatLng(10.2975, 123.9028),
      LatLng(10.2963, 123.9009),
      LatLng(10.2950, 123.8988),
      LatLng(10.2937, 123.8968),
    ],
  ),
  TrafficRoadSegment(
    name: 'CCSC Intersection Lanes',
    type: ZoneType.red,
    points: [
      LatLng(10.3122, 123.9012),
      LatLng(10.3113, 123.9022),
      LatLng(10.3106, 123.9034),
      LatLng(10.3098, 123.9045),
    ],
  ),
  TrafficRoadSegment(
    name: 'SRP Coastal Run',
    type: ZoneType.green,
    points: [
      LatLng(10.2879, 123.8756),
      LatLng(10.2838, 123.8772),
      LatLng(10.2792, 123.8790),
      LatLng(10.2733, 123.8815),
    ],
  ),
];

const List<TrafficStopPoint> cebuTrafficStops = [
  TrafficStopPoint(
    name: 'Fuente Osmena Signal',
    position: LatLng(10.3102, 123.8935),
    type: ZoneType.red,
    note: 'Major stoplight cycle, prepare to stop.',
  ),
  TrafficStopPoint(
    name: 'CCSC Intersection Lights',
    position: LatLng(10.3109, 123.9026),
    type: ZoneType.red,
    note: 'Frequent queueing, engine off when stopped.',
  ),
  TrafficStopPoint(
    name: 'Colon-MC Briones Junction',
    position: LatLng(10.2958, 123.9002),
    type: ZoneType.amber,
    note: 'Coast early to catch the next phase.',
  ),
  TrafficStopPoint(
    name: 'Mango Ave Crossing',
    position: LatLng(10.3127, 123.8921),
    type: ZoneType.amber,
    note: 'Moderate flow, no hard acceleration.',
  ),
];
