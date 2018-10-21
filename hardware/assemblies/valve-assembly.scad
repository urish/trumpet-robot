use <../vitamins/valves.scad>
use <../parts/fingertip.scad>
use <../parts/rack.scad>
use <./servo-assembly.scad>
use <./finger-assembly.scad>

module ValveAssembly() {
    TrumpetValves(pressed=$t);

    translate([-valveDistance() * 2 + 6, 55, -10]) {
        ServoAssembly();

        FingerAssembly();
    }

    translate([valveDistance() / 2 + 6.5, 58, -10])  {
        rotate([0, 0, -90])
        ServoAssembly(middle=true);

        translate([-37.5, -3, 0])
        FingerAssembly(middle=true);
    }

    translate([valveDistance() * 2 - 6, 55, -10])
    mirror([1, 0, 0]) {
        ServoAssembly();

        FingerAssembly();
    }
}

ValveAssembly();
