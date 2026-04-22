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
  Geofence(
    name: 'Tabunok Junction',
    center: LatLng(10.2638, 123.8432),
    radiusMeters: 280,
    type: ZoneType.red,
  ),
  Geofence(
    name: 'Minglanilla Proper Crossing',
    center: LatLng(10.2459, 123.7968),
    radiusMeters: 300,
    type: ZoneType.red,
  ),
  Geofence(
    name: 'Bulacao Corridor',
    center: LatLng(10.2760, 123.8362),
    radiusMeters: 320,
    type: ZoneType.amber,
  ),
  Geofence(
    name: 'South Bus Terminal Approach',
    center: LatLng(10.2948, 123.8927),
    radiusMeters: 260,
    type: ZoneType.red,
  ),
  Geofence(
    name: 'Ayala Center Cebu Approach',
    center: LatLng(10.3176, 123.9059),
    radiusMeters: 260,
    type: ZoneType.amber,
  ),
  Geofence(
    name: 'Parkmall Mandaue Junction',
    center: LatLng(10.3328, 123.9361),
    radiusMeters: 260,
    type: ZoneType.red,
  ),
  Geofence(
    name: 'AS Fortuna-Banilad Road',
    center: LatLng(10.3398, 123.9156),
    radiusMeters: 280,
    type: ZoneType.amber,
  ),
  Geofence(
    name: 'Consolacion Highway Bottleneck',
    center: LatLng(10.3759, 123.9562),
    radiusMeters: 300,
    type: ZoneType.amber,
  ),
  Geofence(
    name: 'Talisay Lawaan Junction',
    center: LatLng(10.2562, 123.8507),
    radiusMeters: 280,
    type: ZoneType.red,
  ),
  Geofence(
    name: 'Naga National Highway Stretch',
    center: LatLng(10.2083, 123.7589),
    radiusMeters: 360,
    type: ZoneType.amber,
  ),
  Geofence(
    name: 'SM Seaside-Cube Approach',
    center: LatLng(10.2813, 123.8798),
    radiusMeters: 300,
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
      FuelType.gasoline: 61.8,
      FuelType.kerosene: 57.0,
    },
    pricesLastWeek: {
      FuelType.diesel: 53.4,
      FuelType.gasoline: 62.3,
      FuelType.kerosene: 57.3,
    },
  ),
  FuelStation(
    name: 'Caltex Mandaue',
    brand: 'Caltex',
    location: LatLng(10.3390, 123.9340),
    pricesThisWeek: {
      FuelType.diesel: 55.0,
      FuelType.gasoline: 63.0,
      FuelType.kerosene: 58.4,
    },
    pricesLastWeek: {
      FuelType.diesel: 55.1,
      FuelType.gasoline: 63.5,
      FuelType.kerosene: 58.6,
    },
  ),
  FuelStation(
    name: 'Petron Colon',
    brand: 'Petron',
    location: LatLng(10.2941, 123.9014),
    pricesThisWeek: {
      FuelType.diesel: 58.0,
      FuelType.gasoline: 63.9,
      FuelType.kerosene: 59.4,
    },
    pricesLastWeek: {
      FuelType.diesel: 57.8,
      FuelType.gasoline: 64.2,
      FuelType.kerosene: 59.2,
    },
  ),
  FuelStation(
    name: 'Unioil Banilad',
    brand: 'Unioil',
    location: LatLng(10.3448, 123.9068),
    pricesThisWeek: {
      FuelType.diesel: 59.0,
      FuelType.gasoline: 63.2,
      FuelType.kerosene: 60.1,
    },
    pricesLastWeek: {
      FuelType.diesel: 59.3,
      FuelType.gasoline: 63.6,
      FuelType.kerosene: 60.4,
    },
  ),
  FuelStation(
    name: 'Shell Carbon Market',
    brand: 'Shell',
    location: LatLng(10.2911, 123.8975),
    pricesThisWeek: {
      FuelType.diesel: 62.0,
      FuelType.gasoline: 65.3,
      FuelType.kerosene: 61.5,
    },
    pricesLastWeek: {
      FuelType.diesel: 61.7,
      FuelType.gasoline: 65.1,
      FuelType.kerosene: 61.2,
    },
  ),
  FuelStation(
    name: 'PTT IT Park',
    brand: 'PTT',
    location: LatLng(10.3305, 123.9048),
    pricesThisWeek: {
      FuelType.diesel: 67.0,
      FuelType.gasoline: 65.9,
      FuelType.kerosene: 62.8,
    },
    pricesLastWeek: {
      FuelType.diesel: 67.4,
      FuelType.gasoline: 66.1,
      FuelType.kerosene: 63.0,
    },
  ),
  FuelStation(
    name: 'Phoenix Mactan',
    brand: 'Phoenix',
    location: LatLng(10.2975, 123.9730),
    pricesThisWeek: {
      FuelType.diesel: 70.0,
      FuelType.gasoline: 66.8,
      FuelType.kerosene: 64.2,
    },
    pricesLastWeek: {
      FuelType.diesel: 69.7,
      FuelType.gasoline: 66.6,
      FuelType.kerosene: 64.0,
    },
  ),
  FuelStation(
    name: 'Jetti N. Bacalso',
    brand: 'Jetti',
    location: LatLng(10.2817, 123.8719),
    pricesThisWeek: {
      FuelType.diesel: 56.0,
      FuelType.gasoline: 62.6,
      FuelType.kerosene: 58.0,
    },
    pricesLastWeek: {
      FuelType.diesel: 56.3,
      FuelType.gasoline: 62.9,
      FuelType.kerosene: 58.3,
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
  TrafficStopPoint(
    name: 'Tabunok Signal',
    position: LatLng(10.2639, 123.8434),
    type: ZoneType.red,
    note: 'Heavy queue at peak hours, prepare to stop.',
  ),
  TrafficStopPoint(
    name: 'Minglanilla Crossing',
    position: LatLng(10.2461, 123.7969),
    type: ZoneType.red,
    note: 'Slow-moving junction, cut engine on long stop.',
  ),
  TrafficStopPoint(
    name: 'Bulacao Traffic Lights',
    position: LatLng(10.2756, 123.8359),
    type: ZoneType.amber,
    note: 'Coast in, avoid hard braking.',
  ),
  TrafficStopPoint(
    name: 'Parkmall Junction Lights',
    position: LatLng(10.3329, 123.9364),
    type: ZoneType.red,
    note: 'Frequent stoplight cycle, expect congestion.',
  ),
  TrafficStopPoint(
    name: 'AS Fortuna Crossing',
    position: LatLng(10.3396, 123.9153),
    type: ZoneType.amber,
    note: 'Maintain slow roll, coast between signals.',
  ),
  TrafficStopPoint(
    name: 'Lawaan Signal',
    position: LatLng(10.2564, 123.8509),
    type: ZoneType.red,
    note: 'Busy merge lane, prepare full stop.',
  ),
  TrafficStopPoint(
    name: 'Naga Highway Lights',
    position: LatLng(10.2085, 123.7592),
    type: ZoneType.amber,
    note: 'Long corridor flow, coast to save fuel.',
  ),
  TrafficStopPoint(
    name: 'SM Seaside Main Lights',
    position: LatLng(10.2811, 123.8794),
    type: ZoneType.red,
    note: 'High-volume traffic near mall access.',
  ),
  TrafficStopPoint(
    name: 'Cube Intersection Lights',
    position: LatLng(10.2804, 123.8810),
    type: ZoneType.amber,
    note: 'Coast in, avoid racing the signal.',
  ),
];
