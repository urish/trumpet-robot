// Print using Flexible Filament (TPU)

include <MCAD/units.scad>

feetUpperRadius = 9.5;
feetLowerRadius = 12.5;
feetLowerHeight = 10;
feetUpperHeight = 2.7;

module TrumpetStandFoot() {
    $fn=60;

    cylinder(h=feetLowerHeight, r=feetLowerRadius);

    translate([0, 0, feetLowerHeight])
    cylinder(h=feetUpperHeight, r=feetUpperRadius);
}

TrumpetStandFoot();
