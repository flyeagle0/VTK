catch {load vtktcl}
if { [catch {set VTK_TCL $env(VTK_TCL)}] != 0} { set VTK_TCL "../../examplesTcl" }
if { [catch {set VTK_DATA $env(VTK_DATA)}] != 0} { set VTK_DATA "../../../vtkdata" }

# Generate random planes to form a convex polyhedron.
# Create a polyhedral representation of the planes.

# get the interactor ui
source $VTK_TCL/vtkInt.tcl

# get some nice colors
source $VTK_TCL/colors.tcl

# create some points laying between 1<=r<5 (r is radius)
# the points also have normals pointing away from the origin.
#
vtkMath math
vtkPoints points
vtkNormals normals
for {set i 0} {$i<100} {incr i 1} {
    set radius 1.0
    set theta  [math Random 0 360]
    set phi    [math Random 0 180]

    set x [expr $radius*sin($phi)*cos($theta)]
    set y [expr $radius*sin($phi)*sin($theta)]
    set z [expr $radius*cos($phi)]

    eval points InsertPoint $i $x $y $z
    eval normals InsertNormal $i $x $y $z
}

vtkPlanes planes
    planes SetPoints points
    planes SetNormals normals

vtkSphereSource ss
vtkHull hull
    hull SetPlanes planes

vtkPolyData pd
    hull GenerateHull pd -20 20 -20 20 -20 20

# triangulate them
#
vtkPolyDataMapper mapHull
    mapHull SetInput pd 
vtkActor hullActor
    hullActor SetMapper mapHull

# Create graphics objects
# Create the rendering window, renderer, and interactive renderer
vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

# Add the actors to the renderer, set the background and size
ren1 AddActor hullActor
renWin SetSize 250 250

# render the image
#
iren SetUserMethod {wm deiconify .vtkInteract}
[ren1 GetActiveCamera] Zoom 1.5
iren Initialize

renWin SetFileName "DelMesh.ppm"
#renWin SaveImageAsPPM

# prevent the tk window from showing up then start the event loop
wm withdraw .


