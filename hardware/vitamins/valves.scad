include <MCAD/units.scad>

$fn = 60;

function valveDistance() = 24.2;
function valvePressAmount() = 20.75 - 5.3;

module SingleValve(pressed = 0) {
    translate([0, 0, -124.22])
    cylinder(h=124.22, r=20 / 2.0);

    color("silver")
    translate([0, 0, -123.22])
    cylinder(h=4, r=21.72/2);
    
    color("silver")
    translate([0, 0, -4.75])
    cylinder(h=4, r=21.72/2);

    cylinder(h=20.75 - (valvePressAmount() * pressed) - epsilon, r=5.56 / 2.0);

    color("#e6e6fa")
    translate([0, 0, 20.75-5.3 - (valvePressAmount() * pressed)])
    cylinder(h=5.3, r=16.88 / 2);
}

module TrumpetValves(pressed = 0) {
    for (x = [-1, 0, 1])
        translate([x * valveDistance(), 0, 0])
        SingleValve(pressed);

    translate([0, 20 / 2, -10])
    rotate([-90, 0, 0])
    cylinder(r=4.40 / 2, h=10);
    
    translate([-68.4/2, valveDistance(), -10])
    rotate([0, 90, 0])
    cylinder(r=11.94/2, h = 68.4);
}

TrumpetValves();
