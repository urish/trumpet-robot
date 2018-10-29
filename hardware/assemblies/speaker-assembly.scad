use <../vitamins/speaker.scad>
use <../parts/big-speaker-enclosure.scad>
use <../parts/big-speaker-spacers.scad>
use <../parts/big-speaker-cover.scad>

translate([0, 0, -62])
SpeakerEnclosure();

color("silver")
SpeakerSpacers();

translate([0, 0, 9])
color("black")
Speaker();

SpeakerCover();