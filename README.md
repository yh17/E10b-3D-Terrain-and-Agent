# E10b-3D-Terrain-and-Agent
This is an exercise to explore adding 3D terrain and a simple AI agent to a scene.

As usual, Fork and Clone this repository.

I have populated the scene with a Game node, and a Ground StaticBody to stand on. I have also created a first-person character which can move, look around, and jump. Your task will be to add some terrain and create a rudamentary AI agent (which is powered by a simple state machine).

 * From the Assets folder (in the FileSystem panel), drag blockSnowCornerLarge.glb to the Scene panel as a child of Game. You should see the model appear in the scene. Select the blockSnowCornerLarge node, and click the scene icon next to the name. You will see a dialog box saying that the scene was automatically imported. Click the "New Inherited" button.

 * In the blockSnowCornerLarge scene, right-click on blockSnowCornerLarge and Add Child Node. Select StaticBody. Then drag the blockSnowCornerLargeClone mesh as a child of the StaticBody node. Select blockSnowCornerLargeClone and (above the viewport), you will see a Mesh button. From the resulting menu, select Create Convex Collision Sibling(s) (you should see two CollisionShape nodes appear). Save the scene as res://Scenes/blockSnowCornerLarge.tscn and return to the Game scene. Delete the blockSnowCornerLarge node and right-click on Game. Instance Child Scene. Select Scenes/blockSnowCornerLarge.tscn (*not Assets/blockSnowQuarter.glb!*). Select the blockSnowCornerLarge node; in the Inspector->Spatial->Transform->Translation, set x=20, z=20. Set the Spatial->Transform->Scale to x=10, y=3, z=10.

 * Repeat the previous two bullets, instead using blockSnowHexagon.glb. In the Inspector->Spatial->Transform->Translation, set x=-20, z=20

 * Repeat again, instead using blockSnowQuarter.glb. In the Inspector->Spatial->Transform->Translation, set x=-20, z=-20

 * Knowing what you now know, you should be able to set up a scene for delivery.glb. The StaticBody will need to be a child of delivery/tmpParent/delivery, and you will need to create Convex Collision Siblings for every mesh. After you save and instance the new scene, scale the delivery node to x=3, y=3, z=3, and place it at x=10, z=10
 
 * Do the same with ambulance.glb. Scale it and place it at x=-5, z=10
 
 * Now, we will create an Enemy Agent. Right-click on the Game node and Add Child Node. Select KinematicBody. Change the name of the KinematicBody to Enemy. In the Inspector->Spatial->Transform->Translation, set y=2, z=20
 
 * Create a new MeshInstance as a child of Enemy. In the Inspector->MeshInstance->Mesh, select New SphereMesh. Then, in the same menu, select Edit. Change Radius=2 and Height=4

 * Create another new MeshInstance as a child of Enemy. In the Inspector->MeshInstance->Mesh, select New PrismMesh. Then, in the same menu, select Edit. Change Size.x=2, y=2, z=2. Select PrimativeMesh->Mesh and select New SpatialMaterial. Go back. In Inspector->Spatial->Transform->Translation, set z=2. Inspector->Spatial->Transform->Rotation Degrees, set x=90
 
 * Create Convex Collision Siblings for MeshInstance and MeshInstance2
 
 * Right-click on Enemy and Add Child Node. Select RayCast. Rename the RayCast node to Scan. In the Inspector, set Enabled=On, CastTo.z = 50. In Inspector->Spatial->Transform->Translation, set z=3
 
 * Right-click on Enemy and Add Child Node. Select Timer. In the Inspector, set Wait Time=3 and One Shot=On
 
 * Right-click on Enemy and Add Child Node. Select Area. Rename the Area node to Nearby

* Right-click on Nearby and Add Child Node. CollisionShape. In the Inspector->CollisionShape->Shape, select New SphereShape. Then, in the same menu, Edit the shape. Set the Radius=4

* Right-click on Enemy and Attach Script. Save the script as res://Scripts/Enemy.gd. Replace the contents of the new file with the following:

```
extends KinematicBody

var speed = 1
var state = ""

func _ready():
	change_state("scanning")

func change_state(new_state):
	state = new_state
	var material = $MeshInstance2.mesh.surface_get_material(0)
	if state == "scanning":
		material.albedo_color = Color(0,1,0)
	if state == "active":
		material.albedo_color = Color(1,1,0)
	if state == "hiding":
		material.albedo_color = Color(0,0,1)
	if state == "shooting":
		material.albedo_color = Color(1,0,0)
	$MeshInstance2.set_surface_material(0, material)		


func _physics_process(delta):
	if state == "scanning":
		rotate(Vector3(0, 1, 0), speed*delta)
		var c = $Scan.get_collider()
		if c != null and c.name == 'Player':
			change_state("active")
			$Timer.start()


func _on_Timer_timeout():
	var c = $Scan.get_collider()
	if state == "active":
		if c != null and c.name == 'Player':
			change_state("shooting")
			$Timer.start()
		else:
			change_state("scanning")
	if state == "shooting":
		if c != null and c.name == 'Player':
			$Timer.start()
		else:
			change_state("scanning")
		
		

func _on_Nearby_body_entered(body):
	if body.name == 'Player':
		change_state("hiding")


func _on_Nearby_body_exited(body):
	if body.name == 'Player':
		change_state("scanning")
```
 * We're almost done! Select the Timer node and go to the Node panel. Add a timeout() signal, and connect it to the 
 ```_on_Timer_timeout()``` function in Enemy.gd

 * Select the Nearby node and go to the Node panel. Add a body_entered() signal, and connect it to the 
 ```_on_Nearby_body_entered(body)``` function in Enemy.gd

* Select the Nearby node and go to the Node panel. Add a body_exited() signal, and connect it to the 
 ```_on_Nearby_body_exited(body)``` function in Enemy.gd

* Run the program, and make sure the Enemy sphere is reacting as you would expect (scanning, active, shooting, hiding) with corresponding color changes. When you are happy, update the LICENSE and README.md, commit and push your changes to GitHub, and turn in the URL of your repository on Canvas.
 
I have prepared a [short example video](https://youtu.be/p0maW5ZHO0A) which demonstrates the behaviors. Let me know if I need to clarify anything else.
 


 



