include <MCAD/units.scad>

$fn = 60;

height = 2.5;
rimRadius = 27.25 / 2;
rimHeight = 5;
width = 50.6;
length = 90.7;
padding = 24;
enclosureHoleInset=8;

module SpeakerMount() {
    difference() {
        union() {
            color("silver")
            translate([-width/2, -length/2, 0])
            cube([width, length, height]);

            cylinder(r=rimRadius+1.5, h=height+rimHeight);
        }
        
        translate([0, 0, -epsilon])
        cylinder(r=rimRadius, h=height+rimHeight+epsilon*2);

        // Speaker Holes
        for (x=[-1, 1], y=[-1, 1])
        translate([x * (width/2-(3.47+3.86/2)), y * (length/2-(4.65+5.86/2)), -epsilon])
        cylinder(r=2.1, h=height+epsilon*2);
    }
}

SpeakerMount();