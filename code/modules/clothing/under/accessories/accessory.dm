/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "tie"
	item_state = ""	//no inhands
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	var/slot = ACCESSORY_SLOT_DECOR
	var/obj/item/clothing/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/list/mob_overlay = list()
	var/overlay_state = null
	var/list/accessory_icons = list(slot_w_uniform_str = 'icons/mob/ties.dmi', slot_wear_suit_str = 'icons/mob/ties.dmi')
	var/accessory_slowdown = 0
	sprite_sheets = list(
		SPECIES_NABBER = 'icons/mob/species/nabber/ties.dmi'
		)
	var/list/on_rolled = list()	//used when jumpsuit sleevels are rolled ("rolled" entry) or it's rolled down ("down"). Set to "none" to hide in those states.
	var/armor_slowdown = 0
	var/high_visibility	//if it should appear on examine without detailed view
/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		var/tmp_icon_state = overlay_state? overlay_state : icon_state
		if(icon_override && ("[tmp_icon_state]_tie" in icon_states(icon_override)))
			inv_overlay = image(icon = icon_override, icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
		else if("[tmp_icon_state]_tie" in icon_states(default_onmob_icons[slot_tie_str]))
			inv_overlay = image(icon = default_onmob_icons[slot_tie_str], icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
		else
			inv_overlay = image(icon = default_onmob_icons[slot_tie_str], icon_state = tmp_icon_state, dir = SOUTH)
	inv_overlay.color = color
	return inv_overlay

/obj/item/clothing/accessory/get_mob_overlay(mob/user_mob, slot)
	if(!istype(loc,/obj/item/clothing/))	//don't need special handling if it's worn as normal item.
		return ..()
	var/bodytype = "Default"
	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		if(user_human.species.get_bodytype(user_human) in sprite_sheets)
			bodytype = user_human.species.get_bodytype(user_human)

		var/tmp_icon_state = overlay_state? overlay_state : icon_state

		if(istype(loc,/obj/item/clothing/under))
			var/obj/item/clothing/under/C = loc
			if(on_rolled["down"] && C.rolled_down > 0)
				tmp_icon_state = on_rolled["down"]
			else if(on_rolled["rolled"] && C.rolled_sleeves > 0)
				tmp_icon_state = on_rolled["rolled"]

		var/use_sprite_sheet = accessory_icons[slot]
		if(sprite_sheets[bodytype])
			use_sprite_sheet = sprite_sheets[bodytype]

		if(icon_override && ("[tmp_icon_state]_mob" in icon_states(icon_override)))
			return overlay_image(icon_override, "[tmp_icon_state]_mob", color, RESET_COLOR)
		else
			return overlay_image(use_sprite_sheet, tmp_icon_state, color, RESET_COLOR)

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	forceMove(has_suit)
	has_suit.overlays += get_inv_overlay()
	has_suit.slowdown_per_slot[slot_w_uniform] += accessory_slowdown
	has_suit.slowdown_per_slot[slot_wear_suit] += armor_slowdown
	if(istype(src, /obj/item/clothing/accessory/insignia/))
		var/obj/item/clothing/accessory/insignia/P = src
		S.insrank = P.rank

	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [has_suit].</span>")
		src.add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.overlays -= get_inv_overlay()
	has_suit.slowdown_per_slot[slot_w_uniform] = initial_slowdown
	has_suit.slowdown_per_slot[slot_wear_suit] = initial_slowdown
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		src.add_fingerprint(user)
	else
		src.forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/accessory/long
	icon_state = "longtie"

/obj/item/clothing/accessory/blue
	name = "blue tie"
	color = "#123c5a"

/obj/item/clothing/accessory/red
	name = "red tie"
	color = "#800000"

/obj/item/clothing/accessory/blue_clip
	name = "blue tie with a clip"
	icon_state = "bluecliptie"

/obj/item/clothing/accessory/red_long
	name = "red long tie"
	icon_state = "longtie"
	color = "#a02929"

/obj/item/clothing/accessory/black
	name = "black tie"
	color = "#ffffff"

/obj/item/clothing/accessory/yellow
	name = "yellow tie"
	icon_state = "longtie"
	color = "#c4c83d"

/obj/item/clothing/accessory/navy
	name = "navy tie"
	color = "#182e44"

/obj/item/clothing/accessory/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/brown
	name = "brown tie"
	icon_state = "longtie"
	color = "#b18345"

/obj/item/clothing/accessory/nt
	name = "\improper tie with a clip"
	desc = "A neosilk clip-on tie. This one has a clip on it with some unreadable markings."
	icon_state = "ntcliptie"

/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == I_HELP)
			var/obj/item/organ/organ = M.get_organ(user.zone_sel.selecting)
			if(organ)
				user.visible_message("[user] places [src] against [M]'s [organ.name] and listens attentively.",
									 "You place [src] against [M]'s [organ.name]. You hear [english_list(organ.listen())].")
	return ..(M,user)


//Medals
/obj/item/clothing/accessory/medal
	name = ACCESSORY_SLOT_MEDAL
	desc = "A simple medal."
	icon_state = "bronze"
	slot = ACCESSORY_SLOT_MEDAL

/obj/item/clothing/accessory/medal/iron
	name = "iron medal"
	desc = "A simple iron medal."
	icon_state = "iron"
	item_state = "iron"

/obj/item/clothing/accessory/medal/iron/star
	name = "iron star medal"
	desc = "An iron star awarded to members of the SCG for meritorious achievement or service in a combat zone."
	icon_state = "iron_star"

/obj/item/clothing/accessory/medal/iron/nanotrasen
	name = "\improper NanoTrasen merit medal"
	desc = "An iron medal awarded to NanoTrasen employees for merit."
	icon_state = "iron_nt"

/obj/item/clothing/accessory/medal/iron/sol
	name = "\improper Sol expeditionary medal"
	desc = "An iron medal awarded to members of the SCG for service outside of the borders of the Sol Central Government."
	icon_state = "iron_sol"

/obj/item/clothing/accessory/medal/bronze
	name = "bronze medal"
	desc = "A simple bronze medal."
	icon_state = "bronze"
	item_state = "bronze"

/obj/item/clothing/accessory/medal/bronze/heart
	name = "bronze heart medal"
	desc = "A bronze heart awarded to members of the SCG for injury or death in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/bronze/nanotrasen
	name = "\improper NanoTrasen sciences medal"
	desc = "A bronze medal awarded to NanoTrasen employees for signifigant contributions to the fields of science or engineering."
	icon_state = "bronze_nt"

/obj/item/clothing/accessory/medal/bronze/sol
	name = "\improper Sol defensive operations medal"
	desc = "A bronze medal awarded for members of the SCG for service defending the border regions."
	icon_state = "bronze_sol"

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A simple silver medal."
	icon_state = "silver"
	item_state = "silver"

/obj/item/clothing/accessory/medal/silver/sword
	name = "combat action medal"
	desc = "A silver medal awarded to members of the SCG for honorable service while under enemy fire."
	icon_state = "silver_sword"

/obj/item/clothing/accessory/medal/silver/nanotrasen
	name = "\improper NanoTrasen service medal"
	desc = "A silver medal awarded to NanoTrasen employees for distinguished service in support of corporate interests."
	icon_state = "silver_nt"

/obj/item/clothing/accessory/medal/silver/sol
	name = "\improper Sol valor medal"
	desc = "A silver medal awarded for members of the SCG for acts of exceptional valor."
	icon_state = "silver_sol"

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A simple gold medal."
	icon_state = "gold"
	item_state = "gold"

/obj/item/clothing/accessory/medal/gold/star
	name = "gold star medal"
	desc = "A gold star awarded to members of the SCG for acts of heroism in a combat zone."
	icon_state = "gold_star"

/obj/item/clothing/accessory/medal/gold/sun
	name = "solar service medal"
	desc = "A gold medal awarded to members of the SCG by the Secretary General for significant contributions to the Sol Central Government."
	icon_state = "gold_sun"

/obj/item/clothing/accessory/medal/gold/crest
	name = "solar honor medal"
	desc = "A gold medal awarded to members of the Defense Forces by the Secretary General for personal acts of valor and heroism above and beyond the call of duty."
	icon_state = "gold_crest"

/obj/item/clothing/accessory/medal/gold/nanotrasen
	name = "\improper NanoTrasen command medal"
	desc = "A gold medal awarded to NanoTrasen employees for service as the Captain of a NanoTrasen facility, station, or vessel."
	icon_state = "gold_nt"

/obj/item/clothing/accessory/medal/gold/sol
	name = "\improper Sol sapientarian medal"
	desc = "A gold medal awarded for members of the SCG for significant contributions to sapient rights."
	icon_state = "gold_sol"

/obj/item/clothing/accessory/medal/heart
	name = "medical medal"
	desc = "A white heart emblazoned with a red cross awarded to members of the SCG for service as a medical professional in a combat zone."
	icon_state = "white_heart"

//Ribbons
/obj/item/clothing/accessory/ribbon
	name = "ribbon"
	desc = "A simple military decoration."
	icon_state = "ribbon_marksman"
	slot = ACCESSORY_SLOT_MEDAL

/obj/item/clothing/accessory/ribbon/marksman
	name = "marksmanship ribbon"
	desc = "A military decoration awarded to members of the SCG for good marksmanship scores in training. Common in the days of energy weapons."
	icon_state = "ribbon_marksman"

/obj/item/clothing/accessory/ribbon/peace
	name = "peacekeeping ribbon"
	desc = "A military decoration awarded to members of the SCG for service during a peacekeeping operation."
	icon_state = "ribbon_peace"

/obj/item/clothing/accessory/ribbon/frontier
	name = "frontier ribbon"
	desc = "A military decoration awarded to members of the SCG for service along the frontier."
	icon_state = "ribbon_frontier"

/obj/item/clothing/accessory/ribbon/instructor
	name = "instructor ribbon"
	desc = "A military decoration awarded to members of the SCG for service as an instructor."
	icon_state = "ribbon_instructor"

//Specialty Pins
/obj/item/clothing/accessory/specialty
	name = "speciality blaze"
	desc = "A color blaze denoting fleet personnel in some special role. This one is silver."
	icon_state = "marinerank_command"
	slot = ACCESSORY_SLOT_INSIGNIA

/obj/item/clothing/accessory/specialty/janitor
	name = "custodial blazes"
	desc = "Purple blazes denoting a custodial technician."
	icon_state = "fleetspec_janitor"

/obj/item/clothing/accessory/specialty/brig
	name = "brig blazes"
	desc = "Red blazes denoting a brig officer."
	icon_state = "fleetspec_brig"

/obj/item/clothing/accessory/specialty/forensic
	name = "forensics blazes"
	desc = "Steel blazes denoting a forensic technician."
	icon_state = "fleetspec_forensic"

/obj/item/clothing/accessory/specialty/atmos
	name = "atmospherics blazes"
	desc = "Turquoise blazes denoting an atmospheric technician."
	icon_state = "fleetspec_atmos"

/obj/item/clothing/accessory/specialty/counselor
	name = "counselor blazes"
	desc = "Blue blazes denoting a counselor."
	icon_state = "fleetspec_counselor"

/obj/item/clothing/accessory/specialty/chemist
	name = "chemistry blazes"
	desc = "Orange blazes denoting a chemist."
	icon_state = "fleetspec_chemist"

/obj/item/clothing/accessory/specialty/enlisted
	name = "enlisted qualification pin"
	desc = "An iron pin denoting some special qualification."
	icon_state = "fleetpin_enlisted"

/obj/item/clothing/accessory/specialty/officer
	name = "officer's qualification pin"
	desc = "A golden pin denoting some special qualification."
	icon_state = "fleetpin_officer"


/obj/item/clothing/accessory/speciality/pilot
	name = "pilot's qualification pin"
	desc = "An iron pin denoting the qualification to fly in the SGDF."
	icon_state = "pin_pilot"

//Ranks
/obj/item/clothing/accessory/rank
	name = "ranks"
	desc = "Insignia denoting rank of some kind. These appear blank."
	icon_state = "fleetrank"
	on_rolled = list("down" = "none")
	slot = ACCESSORY_SLOT_RANK
	gender = PLURAL

/obj/item/clothing/accessory/rank/fleet
	name = "naval ranks"
	desc = "Insignia denoting naval rank of some kind. These appear blank."
	icon_state = "fleetrank"

/obj/item/clothing/accessory/rank/fleet/enlisted
	name = "ranks (E-1 crewman recruit)"
	desc = "Insignia denoting the rank of Crewman Recruit."
	icon_state = "fleetrank_enlisted"

/obj/item/clothing/accessory/rank/fleet/enlisted/e2
	name = "ranks (E-2 crewman apprentice)"
	desc = "Insignia denoting the rank of Crewman Apprentice."

/obj/item/clothing/accessory/rank/fleet/enlisted/e3
	name = "ranks (E-3 crewman)"
	desc = "Insignia denoting the rank of Crewman."

/obj/item/clothing/accessory/rank/fleet/enlisted/e4
	name = "ranks (E-4 petty officer third class)"
	desc = "Insignia denoting the rank of Petty Officer Third Class."

/obj/item/clothing/accessory/rank/fleet/enlisted/e5
	name = "ranks (E-5 petty officer second class)"
	desc = "Insignia denoting the rank of Petty Officer Second Class."

/obj/item/clothing/accessory/rank/fleet/enlisted/e6
	name = "ranks (E-6 petty officer first class)"
	desc = "Insignia denoting the rank of Petty Officer First Class."

/obj/item/clothing/accessory/rank/fleet/enlisted/e7
	name = "ranks (E-7 chief petty officer)"
	desc = "Insignia denoting the rank of Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e8
	name = "ranks (E-8 senior chief petty officer)"
	desc = "Insignia denoting the rank of Senior Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e9
	name = "ranks (E-9 master chief petty officer)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e9_alt1
	name = "ranks (E-9 command master chief petty officer)"
	desc = "Insignia denoting the rank of Command Master Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e9_alt2
	name = "ranks (E-9 fleet master chief petty officer)"
	desc = "Insignia denoting the rank of Fleet Master Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e9_alt3
	name = "ranks (E-9 force master chief petty officer)"
	desc = "Insignia denoting the rank of Force Master Chief Petty Officer."

/obj/item/clothing/accessory/rank/fleet/enlisted/e9_alt4
	name = "ranks (E-9 master chief petty officer of the Fleet)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer of the Fleet."

/obj/item/clothing/accessory/rank/fleet/enlisted/e9_alt5
	name = "ranks (E-9 master chief petty officer of the Expeditionary Corps)"
	desc = "Insignia denoting the rank of Master Chief Petty Officer of the Expeditionary Corps."

/obj/item/clothing/accessory/rank/fleet/officer
	name = "ranks (O-1 ensign)"
	desc = "Insignia denoting the rank of Ensign."
	icon_state = "fleetrank_officer"

/obj/item/clothing/accessory/rank/fleet/officer/o2
	name = "ranks (O-2 lieutenant junior grade)"
	desc = "Insignia denoting the rank of Lieutenant Junior Grade."

/obj/item/clothing/accessory/rank/fleet/officer/o3
	name = "ranks (O-3 lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."

/obj/item/clothing/accessory/rank/fleet/officer/o4
	name = "ranks (O-4 lieutenant commander)"
	desc = "Insignia denoting the rank of Lieutenant Commander."

/obj/item/clothing/accessory/rank/fleet/officer/o5
	name = "ranks (O-5 commander)"
	desc = "Insignia denoting the rank of Commander."

/obj/item/clothing/accessory/rank/fleet/officer/o6
	name = "ranks (O-6 captain)"
	desc = "Insignia denoting the rank of Captain."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/rank/fleet/flag
	name = "ranks (O-7 rear admiral lower half)"
	desc = "Insignia denoting the rank of Rear Admiral Lower Half."
	icon_state = "fleetrank_command"

/obj/item/clothing/accessory/rank/fleet/flag/o8
	name = "ranks (O-8 rear admiral upper half)"
	desc = "Insignia denoting the rank of Rear Admiral Upper Half."

/obj/item/clothing/accessory/rank/fleet/flag/o9
	name = "ranks (O-9 vice admiral)"
	desc = "Insignia denoting the rank of Vice Admiral."

/obj/item/clothing/accessory/rank/fleet/flag/o10
	name = "ranks (O-10 admiral)"
	desc = "Insignia denoting the rank of Admiral."

/obj/item/clothing/accessory/rank/fleet/flag/o10_alt
	name = "ranks (O-10 fleet admiral)"
	desc = "Insignia denoting the rank of Fleet Admiral."

/obj/item/clothing/accessory/rank/marine
	name = "marine ranks"
	desc = "Insignia denoting marine rank of some kind. These appear blank."
	icon_state = "marinerank_enlisted"

/obj/item/clothing/accessory/rank/marine/enlisted
	name = "ranks (private)"
	desc = "Insignia denoting the rank of Private."
	icon_state = "marinerank_enlisted"

/obj/item/clothing/accessory/rank/marine/enlisted/e0
	name = "ranks (recruit)"
	desc = "Insignia denoting the rank of Recruit."

/obj/item/clothing/accessory/rank/marine/enlisted/e2
	name = "ranks (private first class)"
	desc = "Insignia denoting the rank of Private First Class."

/obj/item/clothing/accessory/rank/marine/enlisted/e3
	name = "ranks (lance corporal)"
	desc = "Insignia denoting the rank of Lance Corporal."

/obj/item/clothing/accessory/rank/marine/enlisted/e4
	name = "ranks (corporal)"
	desc = "Insignia denoting the rank of Corporal."

/obj/item/clothing/accessory/rank/marine/enlisted/e5
	name = "ranks (sergeant)"
	desc = "Insignia denoting the rank of Sergeant."

/obj/item/clothing/accessory/rank/marine/enlisted/e6
	name = "ranks (staff sergeant)"
	desc = "Insignia denoting the rank of Staff Sergeant."

/obj/item/clothing/accessory/rank/marine/enlisted/e7
	name = "ranks (gunnery sergeant)"
	desc = "Insignia denoting the rank of Gunnery Sergeant."

/obj/item/clothing/accessory/rank/marine/enlisted/e8
	name = "ranks (master sergeant)"
	desc = "Insignia denoting the rank of Master Sergeant."

/obj/item/clothing/accessory/rank/marine/enlisted/e8_alt
	name = "ranks (first sergeant)"
	desc = "Insignia denoting the rank of First Sergeant."

/obj/item/clothing/accessory/rank/marine/enlisted/e9
	name = "ranks (master gunnery sergeant)"
	desc = "Insignia denoting the rank of Master Gunnery Sergeant."

/obj/item/clothing/accessory/rank/marine/enlisted/e9_alt1
	name = "ranks (sergeant major)"
	desc = "Insignia denoting the rank of Sergeant Major."

/obj/item/clothing/accessory/rank/marine/enlisted/e9_alt2
	name = "ranks (sergeant major of the Marine Corps)"
	desc = "Insignia denoting the rank of Sergeant Major of the Marine Corps."

/obj/item/clothing/accessory/rank/marine/officer
	name = "ranks (second lieutenant)"
	desc = "Insignia denoting the rank of Second Lieutenant."
	icon_state = "marinerank_officer"

/obj/item/clothing/accessory/rank/marine/officer/o2
	name = "ranks (first lieutenant)"
	desc = "Insignia denoting the rank of First Lieutenant."

/obj/item/clothing/accessory/rank/marine/officer/o3
	name = "ranks (captain)"
	desc = "Insignia denoting the rank of Captain."

/obj/item/clothing/accessory/rank/marine/officer/o4
	name = "ranks (major)"
	desc = "Insignia denoting the rank of Major."

/obj/item/clothing/accessory/rank/marine/officer/o5
	name = "ranks (lieutenant colonel)"
	desc = "Insignia denoting the rank of Lieutenant Colonel."

/obj/item/clothing/accessory/rank/marine/officer/o6
	name = "ranks (colonel)"
	desc = "Insignia denoting the rank of Colonel."

/obj/item/clothing/accessory/rank/marine/flag
	name = "ranks (brigadier general)"
	desc = "Insignia denoting the rank of Brigadier General."
	icon_state = "marinerank_command"

/obj/item/clothing/accessory/rank/marine/flag/o8
	name = "ranks (major general)"
	desc = "Insignia denoting the rank of Major General."

/obj/item/clothing/accessory/rank/marine/flag/o9
	name = "ranks (lieutenant general)"
	desc = "Insignia denoting the rank of lieutenant general."

/obj/item/clothing/accessory/rank/marine/flag/o10
	name = "ranks (general)"
	desc = "Insignia denoting the rank of General."

/obj/item/clothing/accessory/rank/marine/flag/o10_alt
	name = "ranks (commandant of the Marine Corps)"
	desc = "Insignia denoting the rank of Commandant of the Marine Corps."


//Department insignia
/obj/item/clothing/accessory/department
	name = "department insignia"
	desc = "Insignia denoting assignment to a department. These appear blank."
	icon_state = "dept_exped"
	on_rolled = list("down" = "dept_exped_rolled")
	slot = ACCESSORY_SLOT_DEPT

/obj/item/clothing/accessory/department/command
	name = "command insignia"
	desc = "Insignia denoting assignment to the command department. These fit Expeditionary Corps uniforms."
	color = "#e5ea4f"

/obj/item/clothing/accessory/department/command/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the command department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/department/command/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the command department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/department/engineering
	name = "engineering insignia"
	desc = "Insignia denoting assignment to the engineering department. These fit Expeditionary Corps uniforms."
	color = "#ff7f00"

/obj/item/clothing/accessory/department/engineering/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the engineering department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/department/engineering/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the engineering department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/department/security
	name = "security insignia"
	desc = "Insignia denoting assignment to the security department. These fit Expeditionary Corps uniforms."
	color = "#bf0000"

/obj/item/clothing/accessory/department/security/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the security department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/department/security/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the security department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/department/medical
	name = "medical insignia"
	desc = "Insignia denoting assignment to the medical department. These fit Expeditionary Corps uniforms."
	color = "#4c9ce4"

/obj/item/clothing/accessory/department/medical/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the medical department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/department/medical/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the medical department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/department/supply
	name = "supply insignia"
	desc = "Insignia denoting assignment to the supply department. These fit Expeditionary Corps uniforms."
	color = "#bb9042"

/obj/item/clothing/accessory/department/supply/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the supply department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/department/supply/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the supply department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/department/service
	name = "service insignia"
	desc = "Insignia denoting assignment to the service department. These fit Expeditionary Corps uniforms."
	color = "#6eaa2c"

/obj/item/clothing/accessory/department/service/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the service department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/department/service/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the service department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")

/obj/item/clothing/accessory/department/exploration
	name = "exploration insignia"
	desc = "Insignia denoting assignment to the exploration department. These fit Expeditionary Corps uniforms."
	color = "#68099e"

/obj/item/clothing/accessory/department/exploration/fleet
	icon_state = "dept_fleet"
	desc = "Insignia denoting assignment to the exploration department. These fit Fleet uniforms."
	on_rolled = list("rolled" = "dept_fleet_sleeves", "down" = "none")

/obj/item/clothing/accessory/department/exploration/marine
	icon_state = "dept_marine"
	desc = "Insignia denoting assignment to the exploration department. These fit Marine Corps uniforms."
	on_rolled = list("down" = "none")


//Necklaces
/obj/item/clothing/accessory/necklace
	name = "necklace"
	desc = "A simple necklace."
	icon_state = "necklace"
	slot_flags = SLOT_MASK | SLOT_TIE


//Misc
/obj/item/clothing/accessory/kneepads
	name = "kneepads"
	desc = "A pair of synthetic kneepads. Doesn't provide protection from more than arthritis."
	icon_state = "kneepads"

//Scarves
/obj/item/clothing/accessory/scarf
	name = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon_state = "whitescarf"

//Bowties
/obj/item/clothing/accessory/bowtie
	var/icon_tied
/obj/item/clothing/accessory/bowtie/New()
	icon_tied = icon_tied || icon_state
	..()

/obj/item/clothing/accessory/bowtie/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/bowtie/verb/toggle

/obj/item/clothing/accessory/bowtie/on_removed(mob/user as mob)
	if(has_suit)
		has_suit.verbs -= /obj/item/clothing/accessory/bowtie/verb/toggle
	..()

/obj/item/clothing/accessory/bowtie/verb/toggle()
	set name = "Toggle Bowtie"
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return 0

	var/obj/item/clothing/accessory/bowtie/H = null
	if (istype(src, /obj/item/clothing/accessory/bowtie))
		H = src
	else
		H = locate() in src

	if(H)
		H.do_toggle(usr)

/obj/item/clothing/accessory/bowtie/proc/do_toggle(user)
	if(icon_state == icon_tied)
		to_chat(usr, "You untie [src].")
	else
		to_chat(usr, "You tie [src].")

	update_icon()

/obj/item/clothing/accessory/bowtie/update_icon()
	if(icon_state == icon_tied)
		icon_state = "[icon_tied]_untied"
	else
		icon_state = icon_tied

/obj/item/clothing/accessory/bowtie/color
	name = "bowtie"
	desc = "A neosilk hand-tied bowtie."
	icon_state = "bowtie"

/obj/item/clothing/accessory/bowtie/ugly
	name = "horrible bowtie"
	desc = "A neosilk hand-tied bowtie. This one is disgusting."
	icon_state = "bowtie_ugly"


//redline shiet

/obj/item/clothing/accessory/rank/vpp
	name = "VPP ranks"
	desc = "Insignia denoting Voluntary People's Patrol rank of some kind. These appear blank."
	icon_state = "vpp_patrolman"

/obj/item/clothing/accessory/rank/vpp/e0
	name = "VPP ranks (patrolman)"
	desc = "Insignia denoting the rank of Patrolman."
	icon_state = "vpp_patrolman"

/obj/item/clothing/accessory/rank/vpp/e4
	name = "VPP ranks (sergeant)"
	desc = "Insignia denoting the rank of Sergeant."
	icon_state = "vpp_sergeant"

/obj/item/clothing/accessory/rank/provgov
	name = "Provisional Government ranks"
	desc = "Insignia denoting Provisional Government rank of some kind. These appear blank."
	icon_state = "vpp_patrolman"

/obj/item/clothing/accessory/rank/provgov/e7
	name = "ranks (staff sergeant)"
	desc = "Insignia denoting the rank of Staff Sergeant."
	icon_state = "provgov_staffsergeant"

/obj/item/clothing/accessory/rank/provgov/o1
	name = "ranks (junior lieutenant)"
	desc = "Insignia denoting the rank of Junior Lieutenant."
	icon_state = "provgov_junlieutenant"

/obj/item/clothing/accessory/rank/provgov/o2
	name = "ranks (lieutenant)"
	desc = "Insignia denoting the rank of Lieutenant."
	icon_state = "provgov_lieutenant"
