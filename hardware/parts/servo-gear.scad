include <MCAD/units.scad>
use <MCAD/involute_gears.scad>

function servoGearInnerRadius() = 13.5;
function servoGearOuterRadius() = 18;

module ServoGear(thickness=6) {
    linear_extrude(thickness)
    difference() {
        gear_shape(
            number_of_teeth=16,
            pitch_radius=servoGearOuterRadius() - 2.1,
            root_radius=servoGearInnerRadius(),
            base_radius=servoGearOuterRadius() - 3,
            outer_radius=servoGearOuterRadius(),
            half_thick_angle=5.625,
            involute_facets=16
        );
        
        circle(r=4.7/2, $fn=12);
    }
    
    linear_extrude(3)
    difference() {
        circle(r=6, $fn=60);
        
        circle(r=2.5/2, h=3+epsilon, $fn=12);
    }
}

ServoGear();