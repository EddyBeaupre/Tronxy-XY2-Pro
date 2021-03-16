G21; set units to mm
G90; set absolute positioning
M82; set extrusion to absolute
M107 T0; turn off fans tool 0
M140 S60; set bed temperature
M104 S205 T0; set nozzle temperature
M190 S60; wait for bed temperature
M109 S205 T0; wait for nozzle temperature
G28; auto home
G92 E0; set extruder position to zero
G1 Z0.2 F1200; raise nozzle 0.2mm
G1 Y125 X25 F3600; move XY-Axis (bed) to 25mm x 125mm to prep for print
G1 X200 E100 F200; move X-Axis 200mm while feeding 100mm of filament
G92 E0; set extruder position to zero
G1 E-5 F600; Retract filament 5mm
G1 Z100 F1200; ; raise nozzle to 100mm
G1 E5 F600; Return filament to original position
G92 E0; set extruder position to zero
M104 S0; make sure the extuder heater is turned off.
M140 S0; make sure the bed heater is turned off.
M84; shut down motors.
