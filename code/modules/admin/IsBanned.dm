#ifndef OVERRIDE_BAN_SYSTEM
//Blocks an attempt to connect before even creating our client datum thing.
/world/IsBanned(key, address, computer_id, type)
	var/static/key_cache = list()
	if(type == "world")
		return ..()

	if(key_cache[key] >= REALTIMEOFDAY)
		return list("reason"="concurrent connection attempts", "desc"="You are attempting to connect too fast. Try again.")
	key_cache[key] = REALTIMEOFDAY + 10 //This proc shouldn't be runtiming. But if it does, then the expiry time will cover it to ensure genuine connection attempts don't get trapped in limbo.

	var/ckeytext = ckey(key)

	if(admin_datums[ckeytext])
		key_cache[key] = 0
		return ..()

	//Check if user is whitelisted
	if(config.useckeywhitelist && !check_ckey_whitelisted(ckey(key)))
		return list("reason"="civilian", "desc"="\nNon-whitelisted users are not allowed. Get whitelisted at https://discord.gg/QF5naBv2gw")

	//Guest Checking
	if(!config.guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("<span class='notice'>Failed Login: [key] - Guests not allowed</span>")
		key_cache[key] = 0
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	var/client/C = GLOB.ckey_directory[ckeytext]
	//If this isn't here, then topic call spam will result in all clients getting kicked with a connecting too fast error.
	if (C && ckeytext == C.ckey && address == C.address && computer_id == C.computer_id)
		key_cache[key] = 0
		return

	//check if the IP address is a known TOR node
	if(config && config.ToRban && ToRban_isbanned(address))
		log_access("Failed Login: [src] - Banned: ToR")
		message_admins("<span class='notice'>Failed Login: [src] - Banned: ToR</span>")
		//ban their computer_id and ckey for posterity
		AddBan(ckey(key), computer_id, "Use of ToR", "Automated Ban", 0, 0)
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [config.banappeals]")


	if(config.ban_legacy_system)

		//Ban Checking
		. = CheckBan(ckeytext, computer_id, address)
		if(.)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]")
			message_admins("<span class='notice'>Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]</span>")
			key_cache[key] = 0
			return .

		key_cache[key] = 0
		return ..()	//default pager ban stuff

	else

		if(!establish_db_connection())
			error("Ban database connection failure. Key [ckeytext] not checked")
			log_misc("Ban database connection failure. Key [ckeytext] not checked")
			key_cache[key] = 0
			return

		var/failedcid = 1
		var/failedip = 1

		var/ipquery = ""
		var/cidquery = ""
		if(address)
			failedip = 0
			ipquery = " OR ip = '[address]' "

		if(computer_id)
			failedcid = 0
			cidquery = " OR computerid = '[computer_id]' "

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM erro_ban WHERE (ckey = '[ckeytext]' [ipquery] [cidquery]) AND (bantype = 'PERMABAN'  OR (bantype = 'TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")

		query.Execute()

		while(query.NextRow())
			var/pckey = query.item[1]
			//var/pip = query.item[2]
			//var/pcid = query.item[3]
			var/ackey = query.item[4]
			var/reason = query.item[5]
			var/expiration = query.item[6]
			var/duration = query.item[7]
			var/bantime = query.item[8]
			var/bantype = query.item[9]

			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

			var/desc = "\nReason: You, or another user of this computer or connection ([pckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [ackey] on [bantime], [expires]"

			key_cache[key] = 0
			return list("reason"="[bantype]", "desc"="[desc]")

		if (failedcid)
			message_admins("[key] has logged in with a blank computer id in the ban check.")
		if (failedip)
			message_admins("[key] has logged in with a blank ip in the ban check.")
		key_cache[key] = 0
		return ..()	//default pager ban stuff
#endif
#undef OVERRIDE_BAN_SYSTEM

