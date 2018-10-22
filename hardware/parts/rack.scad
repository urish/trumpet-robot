include <MCAD/units.scad>

module Rack(
    numTeeth = 9,
    teethInterval = 6.4,
    toothHeight = 4.5,
    width = 7.5,
    thickness = 7,
    middle = false,
) {
    rackLength = teethInterval * numTeeth;
    fingerWidth = 8;
    fingerThickness = 7.5;
    fingerLength = 48 + (middle ? 3.5 : 0);
    $fn = 60;

    // End stop
    translate([-5, 0, 0])
    cube([5, width, thickness]);

    // Rack body
    cube([rackLength, width - toothHeight, thickness]);

    for (toothIdx = [1 : numTeeth]) {
        translate([teethInterval * (toothIdx - 0.75), width - toothHeight, 0])
        linear_extrude(thickness)
        polygon([
            [0, 0], 
            [1.3, toothHeight], 
            [3.14, toothHeight],
            [4.44, 0]
        ]);
    }

    // Finger
    translate([rackLength - fingerWidth, middle ? width : 0, 0])
    rotate([middle ? 90 : 0, 0, 0])
    difference() {
        cube([fingerWidth, fingerThickness, fingerLength]);

        translate([0, fingerThickness / 2, fingerLength - 8])
        rotate([0, 90, 0])
        translate([0, 0, -epsilon])
        cylinder(r=1.6, h=fingerWidth + 2 * epsilon);
    }
}

// Left
rotate([90, 0, 0])
Rack();

// Middle
translate([-15, -25, 0])
Rack(middle=true);

// Right
translate([20, 25, 0])
mirror([1, 0, 0])
rotate([90, 0, 0])
Rack();
