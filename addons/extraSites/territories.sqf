//@file Version: 1.0
//@file Name: territories.sqf
//@file Author: Cael817, GID Positioning System
//@file Desc: For placing territory markers

_pos = [13180.2,17381,2.54534];
_object = createMarker ["TERRITORY_FOREST", _pos];
_object setMarkerText "Forest Territory";
_object setMarkerColor "ColorYellow";
_object setMarkertype "Empty";
_object setMarkerShape "RECTANGLE";
_object setMarkerBrush "DiagGrid";
_object setMarkerSize [100, 100];
_object setMarkerDir 45;
