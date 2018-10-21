use <../vitamins/servo.scad>
use <../parts/servo-mount.scad>
use <../parts/servo-trumpet-attachment.scad>
use <MCAD/involute_gears.scad>

module FingerGear() {
    gear(hub_diameter=5, 
         gear_thickness=6, 
         number_of_teeth=16,
         hub_thickness=3,
         rim_thickness=6,
         circular_pitch=500);
}

module ServoAssembly(hasSpacer=false, gearDirection=-1) {
    translate([0, -2, 0])
    rotate([90, -90, 0])
    MicroServo();

    color("fuchsia")
    translate([0, -16, 5])
    rotate([90, -90, 0]) 
    rotate([0, 0, gearDirection * $t * 60])
    FingerGear();

    // TODO spacer

    color("cyan")
    translate([28, -25, 21])
    rotate([-90, 0, 90])
    ServoMount();

    color("orange")
    rotate([0, 90, 0])
    translate([0, -31 - (hasSpacer ? 15 : 0), 22])
    ServoTrumpetAttachment();
}
