include <MCAD/units.scad>

module ServoTrumpetAttachment() {
    trumpetTubeRadius = 12.1 / 2;
    thickness = 6;
    length = trumpetTubeRadius * 2 + 3;
    holeDistance = 18;
    width = 24;
    $fn = 60;

    difference() {
        translate([-width / 2, -trumpetTubeRadius - 3, 0])
        cube([width, length, thickness]);

        translate([0, 0, -epsilon])
        cylinder(r=trumpetTubeRadius, h=thickness + epsilon * 2);

        translate([-trumpetTubeRadius, 0, -epsilon])
        cube([trumpetTubeRadius * 2, 12, thickness + epsilon * 2]);

        for (x = [0, 1])
        mirror([x, 0, 0])
        translate([holeDistance / 2, 7, thickness / 2])
        rotate([90, 0, 0])
        cylinder(r=3.1 / 2, h=length + 1);
    }
}

translate([0, 0, 9])
rotate([90, 0, 0])
ServoTrumpetAttachment();
