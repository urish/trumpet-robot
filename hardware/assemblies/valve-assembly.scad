use <../vitamins/valves.scad>
use <../parts/fingertip.scad>
use <../parts/rack.scad>
use <./servo-assembly.scad>

module ValveAssembly() {
    TrumpetValves(pressed=$t);
    rackPosition = [22, -15, -5];

    translate([-valveDistance() * 2, 55, -10]) {
        ServoAssembly();

        translate(rackPosition)
        rotate([90, -90, 0])
        Rack();
    }

    translate([-valveDistance()/2, 70, -10])  {
        ServoAssembly(hasSpacer=true);

        translate(rackPosition)
        rotate([90, -90, 0])
        Rack(fingerLength=64);
    }

    translate([valveDistance() * 2, 55, -10])
    rotate([0, 180, 0]) {
        ServoAssembly(gearDirection=1);

        translate([rackPosition[0], rackPosition[1], -rackPosition[2]])
        mirror([0, 0, 1])
        rotate([90, -90, 0])
        Rack();
    }
}

ValveAssembly();
