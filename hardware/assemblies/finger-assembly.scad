use <../vitamins/valves.scad>
use <../parts/rack.scad>
use <../parts/fingertip.scad>

module FingerAssembly(middle=false) {
    translate([0, 0, -$t * valvePressAmount()]) {
        color("pink")
        translate([22, -15.5 + (middle ? -3.5 : 0), -5-6.4])
        rotate([middle ? 0 : 90, -90, 0])
        Rack(middle=middle);

        color("#ffe0bd")
        translate([18, -55, 38])
        rotate([0, 180, 0])
        Fingertip();
    }
}

FingerAssembly();
