FORT = gfortran
FFLAGS = -g -O0
LINK = gfortran
LFLAGS =

ALL: Sod_intermediate_pressure_demo Sod_solution_demo

Sod_intermediate_pressure_demo: Sod_module.o Sod_intermediate_pressure_demo.o
	$(LINK) $(LFLAGS) -o Sod_intermediate_pressure_demo Sod_intermediate_pressure_demo.o Sod_module.o

Sod_solution_demo: Sod_module.o Sod_solution_demo.o
	$(LINK) $(LFLAGS) -o Sod_solution_demo Sod_solution_demo.o Sod_module.o

Sod_module.o: Sod_module.f90
	$(FORT) $(FFLAGS) -c Sod_module.f90

Sod_intermediate_pressure_demo.o: Sod_intermediate_pressure_demo.f90
	$(FORT) $(FFLAGS) -c Sod_intermediate_pressure_demo.f90

Sod_solution_demo.o: Sod_solution_demo.f90
	$(FORT) $(FFLAGS) -c Sod_solution_demo.f90

clean: *.o *.mod
	/bin/rm *.o *.mod

sweep: *.o *.mod
	/bin/rm *.o *.mod Sod_solution_demo Sod_intermediate_pressure_demo
