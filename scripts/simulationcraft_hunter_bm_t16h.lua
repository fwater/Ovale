local _, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "SimulationCraft: Hunter_BM_T16H"
	local desc = "[5.4] SimulationCraft: Hunter_BM_T16H" 
	local code = [[
# Based on SimulationCraft profile "Hunter_BM_T16H".
#	class=hunter
#	spec=beast_mastery
#	talents=http://us.battle.net/wow/en/tool/talent-calculator#Ya!...100

Include(ovale_common)
Include(ovale_hunter_common)

AddFunction BeastMasteryDefaultActions
{
	#virmens_bite_potion,if=target.time_to_die<=25|buff.stampede.up
	if target.TimeToDie() <= 25 or BuffPresent(stampede_buff) UsePotionAgility()
	#use_item,slot=hands
	UseItemActions()
	#auto_shot
	#explosive_trap,if=active_enemies>1
	if Enemies() > 1 Spell(explosive_trap)
	#serpent_sting,if=!ticking
	if not target.DebuffPresent(serpent_sting_debuff) Spell(serpent_sting)
	#blood_fury
	Spell(blood_fury)
	#dire_beast,if=enabled
	if TalentPoints(dire_beast_talent) Spell(dire_beast)
	#fervor,if=enabled&focus<=65
	if TalentPoints(fervor_talent) and Focus() <= 65 Spell(fervor)
	#bestial_wrath,if=focus>60&!buff.beast_within.up
	if Focus() > 60 and not BuffPresent(beast_within_buff) Spell(bestial_wrath)
	#multi_shot,if=active_enemies>5|(active_enemies>1&buff.beast_cleave.down)
	if Enemies() > 5 or { Enemies() > 1 and BuffExpires(beast_cleave_buff) } Spell(multi_shot)
	#rapid_fire,if=!buff.rapid_fire.up
	if not BuffPresent(rapid_fire_buff) Spell(rapid_fire)
	#stampede,if=trinket.stat.agility.up|target.time_to_die<=20|(trinket.stacking_stat.agility.stack>10&trinket.stat.agility.cooldown_remains<=3)
	if BuffPresent(trinket_stat_agility_buff) or target.TimeToDie() <= 20 or { BuffStacks(trinket_stacking_stat_agility_buff) > 10 and { ItemCooldown(Trinket0Slot) + ItemCooldown(Trinket1Slot) } <= 3 } Spell(stampede)
	#barrage,if=enabled&active_enemies>5
	if TalentPoints(barrage_talent) and Enemies() > 5 Spell(barrage)
	#kill_shot
	Spell(kill_shot usable=1)
	#kill_command
	if pet.Present() KillCommand()
	#a_murder_of_crows,if=enabled&!ticking
	if TalentPoints(a_murder_of_crows_talent) and not target.DebuffPresent(a_murder_of_crows_debuff) Spell(a_murder_of_crows)
	#glaive_toss,if=enabled
	if TalentPoints(glaive_toss_talent) Spell(glaive_toss)
	#lynx_rush,if=enabled&!dot.lynx_rush.ticking
	if TalentPoints(lynx_rush_talent) and not target.DebuffPresent(lynx_rush_debuff) Spell(lynx_rush)
	#barrage,if=enabled
	if TalentPoints(barrage_talent) Spell(barrage)
	#powershot,if=enabled
	if TalentPoints(powershot_talent) Spell(powershot)
	#cobra_shot,if=active_enemies>5
	if Enemies() > 5 Spell(cobra_shot)
	#arcane_shot,if=buff.thrill_of_the_hunt.react|buff.beast_within.up
	if BuffPresent(thrill_of_the_hunt_buff) or BuffPresent(beast_within_buff) Spell(arcane_shot)
	#focus_fire,five_stacks=1
	if BuffStacks(frenzy_buff any=1) == 5 Spell(focus_fire)
	#cobra_shot,if=dot.serpent_sting.remains<6
	if target.DebuffRemains(serpent_sting_debuff) < 6 Spell(cobra_shot)
	#arcane_shot,if=focus>=61
	if Focus() >= 61 Spell(arcane_shot)
	#cobra_shot
	Spell(cobra_shot)
}

AddFunction BeastMasteryPrecombatActions
{
	#flask,type=spring_blossoms
	#food,type=sea_mist_rice_noodles
	#aspect_of_the_hawk
	if not Stance(hunter_aspect_of_the_hawk) Spell(aspect_of_the_hawk)
	#hunters_mark,if=target.time_to_die>=21&!debuff.ranged_vulnerability.up
	if target.TimeToDie() >= 21 and not target.DebuffPresent(ranged_vulnerability any=1) Spell(hunters_mark)
	#summon_pet
	SummonPet()
	#snapshot_stats
	#virmens_bite_potion
	UsePotionAgility()
}

AddIcon specialization=beast_mastery help=main
{
	if InCombat(no) BeastMasteryPrecombatActions()
	BeastMasteryDefaultActions()
}

### Required symbols
# a_murder_of_crows
# a_murder_of_crows_debuff
# a_murder_of_crows_talent
# arcane_shot
# aspect_of_the_hawk
# barrage
# barrage_talent
# beast_cleave_buff
# beast_within_buff
# bestial_wrath
# blood_fury
# cobra_shot
# dire_beast
# dire_beast_talent
# explosive_trap
# fervor
# fervor_talent
# focus_fire
# glaive_toss
# glaive_toss_talent
# hunters_mark
# kill_command
# kill_shot
# lynx_rush
# lynx_rush_debuff
# lynx_rush_talent
# multi_shot
# powershot
# powershot_talent
# rapid_fire
# rapid_fire_buff
# serpent_sting
# serpent_sting_debuff
# stampede
# stampede_buff
# summon_pet
# thrill_of_the_hunt_buff
# trinket_stacking_stat_agility_buff
# trinket_stat_agility_buff
# virmens_bite_potion
]]
	OvaleScripts:RegisterScript("HUNTER", name, desc, code, "reference")
end
