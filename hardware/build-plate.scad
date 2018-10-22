use <parts/fingertip.scad>
use <parts/rack.scad>
use <parts/servo-gear.scad>
use <parts/servo-trumpet-attachment.scad>
use <parts/servo-mount.scad>

// 3 Finger Assemblies
translate([-10, -40, 0])
Fingertip();

translate([15, -40, 0])
Fingertip();

translate([-20, -5, 0])
Fingertip();

// Left
rotate([90, 0, 0])
Rack();

// Middle
translate([-15, -25, 0])
Rack(middle=true);

// Right
translate([15, 20, 0])
mirror([1, 0, 0])
rotate([90, 0, 0])
Rack();

// 3 Servo Assemblies
for (x = [-35, 0, 35])
translate([x + 10, 43, 0])
rotate([0, 0, x])
ServoGear();

translate([40, 15, 9])
rotate([90, 0, 0])
ServoTrumpetAttachment();

translate([-10, -55, 9])
rotate([90, 0, 0])
ServoTrumpetAttachment();

translate([18, -55, 9])
rotate([90, 0, 0])
ServoTrumpetAttachment();

translate([65, 15, 0])
ServoMount();

translate([61, -30, 0])
ServoMount(true);

translate([65, -75, 0])
ServoMount();