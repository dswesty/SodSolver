set output "sod_exact.png"
set terminal png
#
#              For encapsulated Postscript output uncomment this lines 
# set output "sod_exact.ps"
# set terminal postscript color
# set terminal postscript enhanced
set xrange[-2.0:2.0]
set size 1,1
set origin 0,0
set nokey
set xlabel "x (cm)"
set multiplot

                              # Plot density
set size 0.5,0.5
set origin 0,0.5
set ylabel "{/Symbol r} (g/cm^3)"
set yrange [0.05:1.05]
plot "sod_exact.dat" using 1:4 with lines lw 1 linecolor 'blue'

                              # Plot pressure
set size 0.5,0.5
set origin 0,0
set ylabel "P (erg/cm^3)"
set yrange [0.05:1.05]
plot "sod_exact.dat" using 1:3 with lines lw 1 linecolor 'blue'

                              # Plot velocity
set size 0.5,0.5
set origin 0.5,0.5
set ylabel "v (cm/s)"
set yrange [-0.05:0.9]
plot "sod_exact.dat" using 1:2 with lines lw 1 linecolor 'blue'

                              # Plot specific energy
set size 0.5,0.5
set origin 0.5,0
set ylabel "e (erg/g)"
set yrange [0.85:1.95]
plot "sod_exact.dat" using 1:5 with lines lw 1 linecolor 'blue'


set nomultiplot
reset
