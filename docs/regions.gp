#
#              Use the qt terminal by default which will pop up a window
set terminal qt
#

set xrange[-2.0:2.0]
set size 1,1
set origin 0,0
set nokey
set xlabel "x (position)"
set title 'Shock tube density at t=0.7 seconds for {/Symbol g} = 5/3 '
set yrange [0.05:1.05]

set arrow from -0.9,0.05 to -0.9,1.05 nohead dt "-" lw 1
set arrow from -0.12,0.05 to -0.12,1.05 nohead dt "-" lw 1
set arrow from 0.585,0.05 to 0.585,1.05 nohead dt "-" lw 1
set arrow from 1.295,0.05 to 1.295,1.05 nohead dt "-" lw 1

set label "I" at -1.5,0.35 font "Courier,25"
set label "II" at -0.6,0.35 font "Courier,25"
set label "III" at 0.07,0.35 font "Courier,25"
set label "IV" at 0.85,0.35 font "Courier,25"
set label "V" at 1.6,0.35 font "Courier,25"

                              # Plot density
set size 1.0,1.0
set origin 0,0.
set ylabel "{/Symbol r} (density)"
plot "sod_exact.dat" using 1:4 with lines lw 2 linecolor 'blue'

pause -1 "Press enter to continue"

