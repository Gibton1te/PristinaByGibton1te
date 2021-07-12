// Noise "language", for audible emotes.
/datum/language/noise
	name = "Noise"
	desc = "Noises"
	key = ""
	flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER

/datum/language/noise/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/datum/language/noise/format_message_plain(message, verb)
	return message

/datum/language/noise/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

// 'basic' language; spoken by default.
/datum/language/common
	name = LANGUAGE_GALCOM
	desc = "The common Underground tongue."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "0"
	flags = RESTRICTED
	syllables = list("blah","blah","blah","bleh","meh","neh","nah","wah")

//TODO flag certain languages to use the mob-type specific say_quote and then get rid of these.
/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

// Galactic common languages (systemwide accepted standards).
/datum/language/lunar
	name = LANGUAGE_LUNAR
	desc = "An older language, another useless try to create something like Esperanto - a language is simple to use and easy to learn. Now it is spoken mostly by medical workers thanks to it latin base."
	speech_verb = "enunciates"
	colour = "moon"
	key = "2"
	space_chance = 100
	syllables = list("lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
					 "sed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore",
					 "magna", "aliqua", "ut", "enim", "ad", "minim", "veniam", "quis", "nostrud",
					 "exercitation", "ullamco", "laboris", "nisi", "ut", "aliquip", "ex", "ea", "commodo",
					 "consequat", "duis", "aute", "irure", "dolor", "in", "reprehenderit", "in",
					 "voluptate", "velit", "esse", "cillum", "dolore", "eu", "fugiat", "nulla",
					 "pariatur", "excepteur", "sint", "occaecat", "cupidatat", "non", "proident", "sunt",
					 "in", "culpa", "qui", "officia", "deserunt", "mollit", "anim", "id", "est", "laborum")

// Criminal language.
/datum/language/gutter
	name = "Gutter"
	desc = "Much like Common, this crude pidgin tongue descended from numerous languages and serves as a trade language for criminal elements."
	flags = RESTRICTED
	speech_verb = "growls"
	colour = "rough"
	key = "3"
	syllables = list ("gra","ba","ba","breh","bra","rah","dur","ra","ro","gro","go","ber","bar","geh","heh", "gra")

/datum/language/sign
	name = LANGUAGE_SIGN
	desc = "A sign language commonly used for those who are deaf or mute."
	signlang_verb = list("gestures")
	colour = "say_quote"
	key = "s"
	flags = SIGNLANG | NO_STUTTER | NONVERBAL


//coldwar stuff
/*
/datum/language/russian
	name = "Russian"
	desc = "That's the russian language, actually"
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "r"
	colour = "russian"
	flags = RESTRICTED
	syllables = list("��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "����", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "��", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���", "���")

/datum/language/english
	name = "English"
	desc = "That's an english, obviously"
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "e"
	flags = RESTRICTED
	colour = "english"
	syllables = list("al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it", "le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to", "ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin", "his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi", "tio", "uld", "ver", "was", "wit", "you")

/datum/language/german
	name = "German"
	desc = "Fur Kaiser, Gott und Vaterland!"
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "d"
	colour = "german"
	flags = RESTRICTED
	syllables = list("die", "das", "wein", "mir", "und", "wier", "ein", "nein", "gen", "en", "sauen", "bien", "nien", "rien", "rhein", "deut", "der", "lieb", "en", "stein", "nein", "ja", "wolle", "sil", "be")
*/