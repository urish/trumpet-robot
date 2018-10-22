include <MCAD/units.scad>

baseHeight = 6;
servoLength = 12;
servoWidth = 22.4;
motorWidth = servoWidth + 20;
servoHoleDistance = 2.75;
rackRailHeight = 8;
mountingHoleDistance = 18;

$fn = 60;

module ServoMount(middle=false) {
    wallWidth = middle ? 6 : 2;

    difference() {
        union() {
            cube([wallWidth, motorWidth, baseHeight + 3]);

            translate([wallWidth, 0, 0])
            cube([rackRailHeight, motorWidth, baseHeight]);
            
            translate([wallWidth+rackRailHeight, 0, 0])
            cube([6, motorWidth, baseHeight + 11.5 + 4.6]);  
        }

        // Holes for mounting onto trumpet
        if (middle) {
            for (y = [-1, 1])
            translate([wallWidth / 2, motorWidth/2 + y * mountingHoleDistance / 2, -epsilon])
            cylinder(r=1.5, h=baseHeight+3+2*epsilon);
        } else {
            for (y = [-1, 1])
            translate([0, motorWidth/2 + y * mountingHoleDistance / 2, baseHeight / 2])
            rotate([0, 90, 0])
            translate([0, 0, -epsilon])
            cylinder(r=1.5, h=2+rackRailHeight+6+2*epsilon);
        }
    }

    translate([wallWidth+rackRailHeight+2, 0, baseHeight + 11.5 + 4.6])
    difference() {
        cube([4, motorWidth, 14]);
    
        translate([-epsilon, 10, 0])
        cube([4 + epsilon * 2, servoWidth, servoLength]);
        
        for (y = [10 - servoHoleDistance, motorWidth - 10 + servoHoleDistance])
        translate([0, y, servoLength / 2])
        rotate([0, 90, 0])
        cylinder(r=1.5, h=4 + epsilon * 2);
    }
}

// Left
translate([25, 0, 0])
ServoMount();

// Middle
ServoMount(middle=true);

// Right
translate([-5, 0, 0])
mirror([1, 0, 0])
ServoMount();
