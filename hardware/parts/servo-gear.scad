use <MCAD/involute_gears.scad>

module ServoGear() {
    gear(hub_diameter=5, 
         gear_thickness=6, 
         number_of_teeth=16,
         hub_thickness=3,
         rim_thickness=6,
         circular_pitch=500);
}