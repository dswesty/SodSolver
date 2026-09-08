#
#              Use the qt terminal by default which will pop up a window
#set terminal qt
#
#              For png image uncomment these two lines
set output "reverse_sod_exact.png"
set terminal png
#
#              For encapsulated Postscript output uncomment these two lines 
# set output "sod_exact.ps"
# set terminal postscript color
# set terminal postscript enhanced


set xrange[-2.0:2.0]
set size 1,1
set origin 0,0
set nokey
set xlabel "x (position)"
set multiplot

                              # Plot density
set size 0.5,0.5
set origin 0,0.5
set ylabel "{/Symbol r} (density)"
set yrange [0.05:1.05]
plot "reverse_sod_exact.dat" using 1:4 with lines lw 1 linecolor 'blue'

                              # Plot pressure
set size 0.5,0.5
set origin 0,0
set ylabel "P (pressure)"
set yrange [0.05:1.05]
plot "reverse_sod_exact.dat" using 1:3 with lines lw 1 linecolor 'blue'

                              # Plot velocity
set size 0.5,0.5
set origin 0.5,0.5
set ylabel "v (velocity)"
set yrange [-0.9:0.05]
plot "reverse_sod_exact.dat" using 1:2 with lines lw 1 linecolor 'blue'

                              # Plot specific energy
set size 0.5,0.5
set origin 0.5,0
set ylabel "e (specific energy)"
set yrange [0.85:1.95]
plot "reverse_sod_exact.dat" using 1:5 with lines lw 1 linecolor 'blue'


# set nomultiplot
# reset

pause -1 "Press enter to continue"

