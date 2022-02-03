use <bendytube.scad>

// TODO: add air escape hole
// TODO: add thingy to prevent water explosion when bottle full

/* [input spout] */

// the diameter of the spout you're trying to mount this thing to
spout_outer_diameter = 20.6;
spout_outer_radius = spout_outer_diameter / 2;
// how far the diameter stays the same or the length of the mounty bit
spout_length = 14;

/* [funnel] */

// how long the bent funnel piece will be
funnel_length_y = 20; // [10:1:30]
// how far the bent funnel piece will go to the side
funnel_length_x = 20; // [10:1:30]
// how bent the long funnel will be
angle = 65; // [50:1:90]

/* [bottle dimensions] */

// the inner diameter of the bottle you're trying to fill
bottle_inner_diameter = 16.7;
bottle_inner_radius = bottle_inner_diameter / 2;
// by how much the end of the spout will shrink, to put it inside the bottle
bottle_inner_shrink = 0.8;

bottle_radius = bottle_inner_radius * bottle_inner_shrink;

// self-explainatory
wall_thickness = 1.5;

module __Customizer_Limit__() {}

$fn = $preview ? 64 : 128;
// $fn = 50;
overlap = 0.001;

echo(str("quality: ", $fn));

function easeInCubic(t) = t * t;
function lerp(start, end, bias) = (end * bias + start * (1 - bias));

iter = 10;
circles = [
  // first circle; for striaght spout
  [ 0, 0, 0, spout_outer_radius + wall_thickness, 0, 0 ],

  // rest of the circles
  for (i = [0:1:iter])[
    0,
    funnel_length_x / iter* i* easeInCubic(i / iter),
    spout_length + funnel_length_y / iter* i,
    lerp(spout_outer_radius + wall_thickness, bottle_radius, easeInCubic(i / iter)),
    -angle / iter* i* easeInCubic(i / iter),
    0
  ]
];

rotate([0, 0, 90]) {
  bendytube(circles, wall_thickness);
}
// #bendytube_raw(circles, wall_thickness);




