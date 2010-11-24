//Shield Generator - Shield Object
//The interactable shielding object

/obj/machinery/shielding/shield
	name = "shield"
	desc = "An energy shield."
	icon = 'effects.dmi'
	icon_state = "shieldsparkles"
	anchored = 1
	invisibility = 101
	density = 0
	opacity = 0

	var/blockatmosonly = 0
	var/obj/machinery/shielding/emitter/emitter = null


//Basic processing for shield tiles
/obj/machinery/shielding/shield/process()
	if (emitter && emitter.online)
		density = !blockatmosonly
		icon_state = "shieldsparkles[blockatmosonly]"
		explosionstrength = INFINITY
		invisibility = 0
	else
		density = 0
		invisibility = 101
		explosionstrength = 0


//Shield Density controller
/obj/machinery/shielding/shield/CanPass(atom/movable/mover, turf/source, height=1.5, air_group = 0)
	if (density)
		//Block all atmos flow & explosions, but optionally allow movement through
		return !air_group && blockatmosonly
	else
		return 1 //Shield is off; do nothing

//Explosion Handling - Includes support for preblast handling
/obj/machinery/shielding/shield/ex_act(strength)
	if (strength <= 0)
		strength = -strength
		if (emitter && emitter.online)
			emitter.Draw(strength * 50)
		#ifdef DEBUG
		world << "Shield Handled blast wave"
		#endif
	else if (density)
		world << "Active shield ex_act called with positive value?  What?  This makes no sense and should not have happened.  Tell a dev."