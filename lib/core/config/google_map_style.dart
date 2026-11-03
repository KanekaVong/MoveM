import 'package:flutter/material.dart';

class GoogleMapStyle {
  static const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#0d1527"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#8c9db5"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#09101f"}, {"weight": 3}]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#c8d6ea"}]
  },
  {
    "featureType": "poi",
    "stylers": [{"visibility": "on"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [{"color": "#112638"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#5b8296"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [{"color": "#223552"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#152338"}, {"weight": 1}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#9cb1ce"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#0d1527"}, {"weight": 2.5}]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [{"color": "#2e466d"}]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#1b2c45"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#3f5f94"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#273d61"}, {"weight": 1.5}]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#dbeafe"}]
  },
  {
    "featureType": "transit",
    "stylers": [{"visibility": "off"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#070d1a"}]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#2c4568"}]
  }
]
''';


  static String get darkMapStyle => _darkMapStyle;

}
class  routeColor{
  // Prevent instantiation
  routeColor._();

  // Core white line
  static const Color routeCore = Color(0xFFFFFFFF);

  // Outer cyan glow aura
  static const Color routeGlow = Color(0xFF2BB1BA);
}