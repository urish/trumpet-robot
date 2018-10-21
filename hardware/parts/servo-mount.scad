include <MCAD/units.scad>

base_height = 6;
servo_length = 12;
servo_width = 22.4;
mount_width = servo_width + 20;
servo_hole_distance = 2.75;
rack_rail_height = 8;
mountingHoleDistance = 18;

$fn = 60;

module ServoMount() {
    difference() {
        union() {
            cube([2, mount_width, base_height + 3]);

            translate([2, 0, 0])
            cube([rack_rail_height, mount_width, base_height]);
            
            translate([2+rack_rail_height, 0, 0])
            cube([6, mount_width, base_height + 11.5 + 4.6]);  
        }

        for (y = [-1, 1])
        translate([0, mount_width/2 + y * mountingHoleDistance / 2, base_height / 2])
        rotate([0, 90, 0])
        translate([0, 0, -epsilon])
        cylinder(r=1.5, h=2+rack_rail_height+6+2*epsilon);
    }

    translate([2+rack_rail_height+2, 0, base_height + 11.5 + 4.6])
    difference() {
        cube([4, mount_width, 14]);
    
        translate([-epsilon, 10, 0])
        cube([4 + epsilon * 2, servo_width, servo_length]);
        
        for (y = [10 - servo_hole_distance, mount_width - 10 + servo_hole_distance])
        translate([0, y, servo_length / 2])
        rotate([0, 90, 0])
        cylinder(r=1.5, h=4 + epsilon * 2);
    }
}

ServoMount();