use <libraries/naca_sweep.scad>  // http://www.thingiverse.com/thing:1208001
use <libraries/splines.scad>     // http://www.thingiverse.com/thing:1208001

ipl=$fn*2; // interpolation points

function gen_dat(S, ipl=100) =
   [ for (i=[0:len(S)-1])
       let(dat = Tz_(S[i][2], // apply Tz
                 Rx_(S[i][4], // apply Rx
                 Ry_(S[i][5], // apply Ry
                 circle_(S[i][3], ipl))))) // generate circle data using rad
       T_(S[i][0], S[i][1], 0, dat)]; // apply Tx and Ty

function circle_(r=10, ipl=30) = [for (i=[0:ipl-1]) [r*sin(i*360/ipl), r*cos(i*360/ipl), 0]];

module bendytube(circles, wall_thickness) {
  innerskin = [for(i=[len(circles)-1:-1:0]) [for(j=[0:len(circles[0])-1]) circles[i][j]-(j==3?wall_thickness:0)]];

  outer = gen_dat(nSpline(circles,ipl), ipl/3);
  inner = gen_dat(nSpline(innerskin,ipl), ipl/3);
  sweep(concat(outer, inner), close = true);
}

module bendytube_raw(circles, wall_thickness) {
  sweep(gen_dat(circles, ipl/3), showslices = true);
}