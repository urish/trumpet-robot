use <../vitamins/servo.scad>
use <../parts/servo-gear.scad>
use <../parts/servo-mount.scad>
use <../parts/servo-trumpet-attachment.scad>

module ServoAssembly(middle=false) {
    translate([0, -2, 0])
    rotate([90, -90, 0])
    MicroServo();

    color("fuchsia")
    translate([0, -16, 5])
    rotate([90, -90, 0]) 
    rotate([0, 0, -$t * 50 + 13])
    ServoGear();

    color("cyan")
    translate([28, -(25 + (middle ? 4 : 0)), 21])
    rotate([-90, 0, 90])
    ServoMount(middle);

    color("orange") 
    if(middle) {
        translate([34, -29, 0])
        rotate([-90, 90, 0])
        ServoTrumpetAttachment();
    } else {
        rotate([0, 90, 0])
        translate([0, -31, 22])
        ServoTrumpetAttachment();
    }    
}

ServoAssembly();