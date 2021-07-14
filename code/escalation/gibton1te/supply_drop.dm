#define AIRSHIPMENT 100

/obj/structure/closet/crate/airsupply
	name = "supply crate"
	icon = 'icons/obj/64airdrop.dmi'
	icon_state =  "crate"
	icon_opened = "crateopen"
	mouse_opacity = FALSE
	anchored = 1
	invisibility = 101

/obj/structure/closet/crate/airsupply/New()
	..()
	airdrop()

/obj/structure/closet/crate/airsupply/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(opened)
		return
	else if(istype(W, /obj/item/weapon/carpentry/axe))
		qdel(src)

/obj/structure/closet/crate/airsupply/proc/airdrop()
//	playsound(src, 'sound/effects/supply_called_en.ogg', 70, 1)
	spawn(AIRSHIPMENT)
		invisibility = 0
		playsound(src, 'sound/effects/heli.ogg', 70, 1)
		icon_state = initial(icon_state) + "_air"
		spawn(50)
			mouse_opacity = TRUE
			density = TRUE
			icon_state = "crate"

/obj/structure/closet/crate/airsupply/medical_nato/New()
	..()

/obj/structure/closet/crate/airsupply/medical_wp/New()
	..()

/obj/structure/closet/crate/airsupply/medical_nato/WillContain()
	return list(
		/obj/item/weapon/gauze_pack/gauze = 3,
		/obj/item/stack/medical/ointment/nato = 1
	)

/obj/structure/closet/crate/airsupply/medical_wp/WillContain()
	return list(
		/obj/item/weapon/gauze_pack/ipp = 3,
		/obj/item/weapon/gauze_pack/woundseal/wp = 1
	)

/obj/structure/closet/crate/airsupply/ammo_nato/New()
	..()

/obj/structure/closet/crate/airsupply/ammo_wp/New()
	..()

/obj/structure/closet/crate/airsupply/ammo_nato/WillContain()
	return list(
		/obj/item/ammo_magazine/box/paper/box556x45 = 3,
	)

/obj/structure/closet/crate/airsupply/ammo_wp/WillContain()
	return list(
		/obj/item/ammo_magazine/box/paper/box545x39  = 2,
		/obj/item/ammo_magazine/box/paper/box762x54  = 1
	)