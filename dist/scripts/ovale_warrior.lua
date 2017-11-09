local __Scripts = LibStub:GetLibrary("ovale/Scripts")
local OvaleScripts = __Scripts.OvaleScripts
do
    local name = "icyveins_warrior_protection"
    local desc = "[7.2.5] Icy-Veins: Warrior Protection"
    local code = [[

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddCheckBox(opt_interrupt L(interrupt) default specialization=protection)
AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=protection)
AddCheckBox(opt_warrior_protection_aoe L(AOE) default specialization=protection)

AddFunction ProtectionHealMe
{
	if HealthPercent() < 70 Spell(victory_rush)
	if HealthPercent() < 85 Spell(impending_victory)
}

AddFunction ProtectionGetInMeleeRange
{
	if CheckBoxOn(opt_melee_range) and not InFlightToTarget(intercept) and not InFlightToTarget(heroic_leap)
	{
		if target.InRange(intercept) Spell(intercept)
		if SpellCharges(intercept) == 0 and target.Distance(atLeast 8) and target.Distance(atMost 40) Spell(heroic_leap)
		if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
	}
}

AddFunction ProtectionInterruptActions
{
	if CheckBoxOn(opt_interrupt) and not target.IsFriend() and target.Casting()
	{
		if target.InRange(pummel) and target.IsInterruptible() Spell(pummel)
		if target.InRange(storm_bolt) and not target.Classification(worldboss) Spell(storm_bolt)
		if target.InRange(intercept) and not target.Classification(worldboss) and Talent(warbringer_talent) Spell(intercept)
		if target.Distance(less 10) and not target.Classification(worldboss) Spell(shockwave)
		if target.Distance(less 8) and target.IsInterruptible() Spell(arcane_torrent_rage)
		if target.InRange(quaking_palm) and not target.Classification(worldboss) Spell(quaking_palm)
		if target.Distance(less 5) and not target.Classification(worldboss) Spell(war_stomp)
		if target.InRange(intimidating_shout) and not target.Classification(worldboss) Spell(intimidating_shout)
	}
}

AddFunction ProtectionOffensiveCooldowns
{
	Spell(avatar)
	Spell(battle_cry)
	if (Talent(booming_voice_talent) and RageDeficit() >= Talent(booming_voice_talent)*60) Spell(demoralizing_shout)
}

#
# Short
#

AddFunction ProtectionDefaultShortCDActions
{
	ProtectionHealMe()
	if ArmorSetBonus(T20 2) and RageDeficit() >= 26 Spell(berserker_rage)
	if IncomingDamage(5 physical=1) 
	{
		if not BuffPresent(shield_block_buff) and SpellCharges(shield_block) < SpellMaxCharges(shield_block) Spell(neltharions_fury)
		if not BuffPresent(neltharions_fury_buff) and (SpellCooldown(neltharions_fury)>0 or SpellCharges(shield_block) == SpellMaxCharges(shield_block)) Spell(shield_block)
	}
	if ((not BuffPresent(renewed_fury_buff) and Talent(renewed_fury_talent)) or Rage() >= 60) Spell(ignore_pain)
	# range check
	ProtectionGetInMeleeRange()
}

#
# Single-Target
#

AddFunction ProtectionDefaultMainActions
{
	Spell(shield_slam)
	if Talent(devastatator_talent) and BuffPresent(revenge_buff) Spell(revenge)
	if BuffPresent(vengeance_revenge_buff) Spell(revenge)
	Spell(thunder_clap)
	if BuffPresent(revenge_buff) Spell(revenge)
	Spell(storm_bolt)
	Spell(devastate)
}

#
# AOE
#

AddFunction ProtectionDefaultAoEActions
{
	Spell(ravager)
	Spell(revenge)
	Spell(thunder_clap)
	Spell(shield_slam)
	if Enemies() >= 3 Spell(shockwave)
	Spell(devastate)
}

#
# Cooldowns
#

AddFunction ProtectionDefaultCdActions 
{
	ProtectionInterruptActions()
	ProtectionOffensiveCooldowns()
	if IncomingDamage(1.5 magic=1) > 0 Spell(spell_reflection)
	if (HasEquippedItem(shifting_cosmic_sliver)) Spell(shield_wall)
	Item(Trinket0Slot usable=1 text=13)
	Item(Trinket1Slot usable=1 text=14)
	Spell(demoralizing_shout)
	Spell(shield_wall)
	Spell(last_stand)
	
}

#
# Icons
#

AddIcon help=shortcd specialization=protection
{
	ProtectionDefaultShortCDActions()
}

AddIcon enemies=1 help=main specialization=protection
{
	ProtectionDefaultMainActions()
}

AddIcon checkbox=opt_warrior_protection_aoe help=aoe specialization=protection
{
	ProtectionDefaultAoEActions()
}

AddIcon help=cd specialization=protection
{
	ProtectionDefaultCdActions()
}
	
]]
    OvaleScripts:RegisterScript("WARRIOR", "protection", name, desc, code, "script")
end
do
    local name = "sc_warrior_arms_t19"
    local desc = "[7.0] Simulationcraft: Warrior_Arms_T19"
    local code = [[
# Based on SimulationCraft profile "Warrior_Arms_T19P".
#	class=warrior
#	spec=arms
#	talents=1332311

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=arms)
AddCheckBox(opt_use_consumables L(opt_use_consumables) default specialization=arms)

AddFunction ArmsUseItemActions
{
 Item(Trinket0Slot text=13 usable=1)
 Item(Trinket1Slot text=14 usable=1)
}

AddFunction ArmsGetInMeleeRange
{
 if CheckBoxOn(opt_melee_range) and not InFlightToTarget(charge) and not InFlightToTarget(heroic_leap)
 {
  if target.InRange(charge) Spell(charge)
  if SpellCharges(charge) == 0 and target.Distance(atLeast 8) and target.Distance(atMost 40) Spell(heroic_leap)
  if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
 }
}

### actions.single

AddFunction ArmsSingleMainActions
{
 #colossus_smash,if=buff.shattered_defenses.down
 if BuffExpires(shattered_defenses_buff) Spell(colossus_smash)
 #warbreaker,if=(raid_event.adds.in>90|!raid_event.adds.exists)&((talent.fervor_of_battle.enabled&debuff.colossus_smash.remains<gcd)|!talent.fervor_of_battle.enabled&((buff.stone_heart.up|cooldown.mortal_strike.remains<=gcd.remains)&buff.shattered_defenses.down))
 if { 600 > 90 or not False(raid_event_adds_exists) } and { Talent(fervor_of_battle_talent) and target.DebuffRemaining(colossus_smash_debuff) < GCD() or not Talent(fervor_of_battle_talent) and { BuffPresent(stone_heart_buff) or SpellCooldown(mortal_strike) <= GCDRemaining() } and BuffExpires(shattered_defenses_buff) } Spell(warbreaker)
 #focused_rage,if=!buff.battle_cry_deadly_calm.up&buff.focused_rage.stack<3&!cooldown.colossus_smash.up&(rage>=130|debuff.colossus_smash.down|talent.anger_management.enabled&cooldown.battle_cry.remains<=8)
 if not BuffPresent(battle_cry_deadly_calm_buff) and BuffStacks(focused_rage_buff) < 3 and not { not SpellCooldown(colossus_smash) > 0 } and { Rage() >= 130 or target.DebuffExpires(colossus_smash_debuff) or Talent(anger_management_talent) and SpellCooldown(battle_cry) <= 8 } Spell(focused_rage)
 #rend,if=remains<=gcd.max|remains<5&cooldown.battle_cry.remains<2&(cooldown.bladestorm.remains<2|!set_bonus.tier20_4pc)
 if target.DebuffRemaining(rend_debuff) <= GCD() or target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } Spell(rend)
 #execute,if=buff.stone_heart.react
 if BuffPresent(stone_heart_buff) Spell(execute_arms)
 #overpower,if=buff.battle_cry.down
 if BuffExpires(battle_cry_buff) Spell(overpower)
 #mortal_strike,if=buff.shattered_defenses.up|buff.executioners_precision.down
 if BuffPresent(shattered_defenses_buff) or BuffExpires(executioners_precision_buff) Spell(mortal_strike)
 #rend,if=remains<=duration*0.3
 if target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 Spell(rend)
 #whirlwind,if=spell_targets.whirlwind>1|talent.fervor_of_battle.enabled
 if Enemies() > 1 or Talent(fervor_of_battle_talent) Spell(whirlwind)
 #slam,if=spell_targets.whirlwind=1&!talent.fervor_of_battle.enabled&(rage>=52|!talent.rend.enabled|!talent.ravager.enabled)
 if Enemies() == 1 and not Talent(fervor_of_battle_talent) and { Rage() >= 52 or not Talent(rend_talent) or not Talent(ravager_talent) } Spell(slam)
 #overpower
 Spell(overpower)
}

AddFunction ArmsSingleMainPostConditions
{
}

AddFunction ArmsSingleShortCdActions
{
 #bladestorm,if=buff.battle_cry.up&set_bonus.tier20_4pc
 if BuffPresent(battle_cry_buff) and ArmorSetBonus(T20 4) Spell(bladestorm_arms)

 unless BuffExpires(shattered_defenses_buff) and Spell(colossus_smash) or { 600 > 90 or not False(raid_event_adds_exists) } and { Talent(fervor_of_battle_talent) and target.DebuffRemaining(colossus_smash_debuff) < GCD() or not Talent(fervor_of_battle_talent) and { BuffPresent(stone_heart_buff) or SpellCooldown(mortal_strike) <= GCDRemaining() } and BuffExpires(shattered_defenses_buff) } and Spell(warbreaker) or not BuffPresent(battle_cry_deadly_calm_buff) and BuffStacks(focused_rage_buff) < 3 and not { not SpellCooldown(colossus_smash) > 0 } and { Rage() >= 130 or target.DebuffExpires(colossus_smash_debuff) or Talent(anger_management_talent) and SpellCooldown(battle_cry) <= 8 } and Spell(focused_rage) or { target.DebuffRemaining(rend_debuff) <= GCD() or target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } } and Spell(rend)
 {
  #ravager,if=cooldown.battle_cry.remains<=gcd&debuff.colossus_smash.remains>6
  if SpellCooldown(battle_cry) <= GCD() and target.DebuffRemaining(colossus_smash_debuff) > 6 Spell(ravager)

  unless BuffPresent(stone_heart_buff) and Spell(execute_arms) or BuffExpires(battle_cry_buff) and Spell(overpower) or { BuffPresent(shattered_defenses_buff) or BuffExpires(executioners_precision_buff) } and Spell(mortal_strike) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Spell(rend) or { Enemies() > 1 or Talent(fervor_of_battle_talent) } and Spell(whirlwind) or Enemies() == 1 and not Talent(fervor_of_battle_talent) and { Rage() >= 52 or not Talent(rend_talent) or not Talent(ravager_talent) } and Spell(slam) or Spell(overpower)
  {
   #bladestorm,if=(raid_event.adds.in>90|!raid_event.adds.exists)&!set_bonus.tier20_4pc
   if { 600 > 90 or not False(raid_event_adds_exists) } and not ArmorSetBonus(T20 4) Spell(bladestorm_arms)
  }
 }
}

AddFunction ArmsSingleShortCdPostConditions
{
 BuffExpires(shattered_defenses_buff) and Spell(colossus_smash) or { 600 > 90 or not False(raid_event_adds_exists) } and { Talent(fervor_of_battle_talent) and target.DebuffRemaining(colossus_smash_debuff) < GCD() or not Talent(fervor_of_battle_talent) and { BuffPresent(stone_heart_buff) or SpellCooldown(mortal_strike) <= GCDRemaining() } and BuffExpires(shattered_defenses_buff) } and Spell(warbreaker) or not BuffPresent(battle_cry_deadly_calm_buff) and BuffStacks(focused_rage_buff) < 3 and not { not SpellCooldown(colossus_smash) > 0 } and { Rage() >= 130 or target.DebuffExpires(colossus_smash_debuff) or Talent(anger_management_talent) and SpellCooldown(battle_cry) <= 8 } and Spell(focused_rage) or { target.DebuffRemaining(rend_debuff) <= GCD() or target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } } and Spell(rend) or BuffPresent(stone_heart_buff) and Spell(execute_arms) or BuffExpires(battle_cry_buff) and Spell(overpower) or { BuffPresent(shattered_defenses_buff) or BuffExpires(executioners_precision_buff) } and Spell(mortal_strike) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Spell(rend) or { Enemies() > 1 or Talent(fervor_of_battle_talent) } and Spell(whirlwind) or Enemies() == 1 and not Talent(fervor_of_battle_talent) and { Rage() >= 52 or not Talent(rend_talent) or not Talent(ravager_talent) } and Spell(slam) or Spell(overpower)
}

AddFunction ArmsSingleCdActions
{
}

AddFunction ArmsSingleCdPostConditions
{
 BuffPresent(battle_cry_buff) and ArmorSetBonus(T20 4) and Spell(bladestorm_arms) or BuffExpires(shattered_defenses_buff) and Spell(colossus_smash) or { 600 > 90 or not False(raid_event_adds_exists) } and { Talent(fervor_of_battle_talent) and target.DebuffRemaining(colossus_smash_debuff) < GCD() or not Talent(fervor_of_battle_talent) and { BuffPresent(stone_heart_buff) or SpellCooldown(mortal_strike) <= GCDRemaining() } and BuffExpires(shattered_defenses_buff) } and Spell(warbreaker) or not BuffPresent(battle_cry_deadly_calm_buff) and BuffStacks(focused_rage_buff) < 3 and not { not SpellCooldown(colossus_smash) > 0 } and { Rage() >= 130 or target.DebuffExpires(colossus_smash_debuff) or Talent(anger_management_talent) and SpellCooldown(battle_cry) <= 8 } and Spell(focused_rage) or { target.DebuffRemaining(rend_debuff) <= GCD() or target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } } and Spell(rend) or SpellCooldown(battle_cry) <= GCD() and target.DebuffRemaining(colossus_smash_debuff) > 6 and Spell(ravager) or BuffPresent(stone_heart_buff) and Spell(execute_arms) or BuffExpires(battle_cry_buff) and Spell(overpower) or { BuffPresent(shattered_defenses_buff) or BuffExpires(executioners_precision_buff) } and Spell(mortal_strike) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Spell(rend) or { Enemies() > 1 or Talent(fervor_of_battle_talent) } and Spell(whirlwind) or Enemies() == 1 and not Talent(fervor_of_battle_talent) and { Rage() >= 52 or not Talent(rend_talent) or not Talent(ravager_talent) } and Spell(slam) or Spell(overpower) or { 600 > 90 or not False(raid_event_adds_exists) } and not ArmorSetBonus(T20 4) and Spell(bladestorm_arms)
}

### actions.precombat

AddFunction ArmsPrecombatMainActions
{
}

AddFunction ArmsPrecombatMainPostConditions
{
}

AddFunction ArmsPrecombatShortCdActions
{
}

AddFunction ArmsPrecombatShortCdPostConditions
{
}

AddFunction ArmsPrecombatCdActions
{
 #flask,type=countless_armies
 #food,type=lavish_suramar_feast
 #augmentation,type=defiled
 #snapshot_stats
 #potion,name=old_war
 if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(old_war_potion usable=1)
}

AddFunction ArmsPrecombatCdPostConditions
{
}

### actions.execute

AddFunction ArmsExecuteMainActions
{
 #colossus_smash,if=buff.shattered_defenses.down&(buff.battle_cry.down|buff.battle_cry.remains>gcd.max)
 if BuffExpires(shattered_defenses_buff) and { BuffExpires(battle_cry_buff) or BuffRemaining(battle_cry_buff) > GCD() } Spell(colossus_smash)
 #warbreaker,if=(raid_event.adds.in>90|!raid_event.adds.exists)&cooldown.mortal_strike.remains<=gcd.remains&buff.shattered_defenses.down&buff.executioners_precision.stack=2
 if { 600 > 90 or not False(raid_event_adds_exists) } and SpellCooldown(mortal_strike) <= GCDRemaining() and BuffExpires(shattered_defenses_buff) and BuffStacks(executioners_precision_buff) == 2 Spell(warbreaker)
 #focused_rage,if=rage.deficit<35
 if RageDeficit() < 35 Spell(focused_rage)
 #rend,if=remains<5&cooldown.battle_cry.remains<2&(cooldown.bladestorm.remains<2|!set_bonus.tier20_4pc)
 if target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } Spell(rend)
 #mortal_strike,if=buff.executioners_precision.stack=2&buff.shattered_defenses.up
 if BuffStacks(executioners_precision_buff) == 2 and BuffPresent(shattered_defenses_buff) Spell(mortal_strike)
 #overpower,if=rage<40
 if Rage() < 40 Spell(overpower)
 #execute,if=buff.shattered_defenses.down|rage>=40|talent.dauntless.enabled&rage>=36
 if BuffExpires(shattered_defenses_buff) or Rage() >= 40 or Talent(dauntless_talent) and Rage() >= 36 Spell(execute_arms)
}

AddFunction ArmsExecuteMainPostConditions
{
}

AddFunction ArmsExecuteShortCdActions
{
 #bladestorm,if=buff.battle_cry.up&(set_bonus.tier20_4pc|equipped.the_great_storms_eye)
 if BuffPresent(battle_cry_buff) and { ArmorSetBonus(T20 4) or HasEquippedItem(the_great_storms_eye) } Spell(bladestorm_arms)

 unless BuffExpires(shattered_defenses_buff) and { BuffExpires(battle_cry_buff) or BuffRemaining(battle_cry_buff) > GCD() } and Spell(colossus_smash) or { 600 > 90 or not False(raid_event_adds_exists) } and SpellCooldown(mortal_strike) <= GCDRemaining() and BuffExpires(shattered_defenses_buff) and BuffStacks(executioners_precision_buff) == 2 and Spell(warbreaker) or RageDeficit() < 35 and Spell(focused_rage) or target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } and Spell(rend)
 {
  #ravager,if=cooldown.battle_cry.remains<=gcd&debuff.colossus_smash.remains>6
  if SpellCooldown(battle_cry) <= GCD() and target.DebuffRemaining(colossus_smash_debuff) > 6 Spell(ravager)

  unless BuffStacks(executioners_precision_buff) == 2 and BuffPresent(shattered_defenses_buff) and Spell(mortal_strike) or Rage() < 40 and Spell(overpower) or { BuffExpires(shattered_defenses_buff) or Rage() >= 40 or Talent(dauntless_talent) and Rage() >= 36 } and Spell(execute_arms)
  {
   #bladestorm,interrupt=1,if=(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)&!set_bonus.tier20_4pc
   if { 600 > 90 or not False(raid_event_adds_exists) or Enemies() > Enemies(tagged=1) } and not ArmorSetBonus(T20 4) Spell(bladestorm_arms)
  }
 }
}

AddFunction ArmsExecuteShortCdPostConditions
{
 BuffExpires(shattered_defenses_buff) and { BuffExpires(battle_cry_buff) or BuffRemaining(battle_cry_buff) > GCD() } and Spell(colossus_smash) or { 600 > 90 or not False(raid_event_adds_exists) } and SpellCooldown(mortal_strike) <= GCDRemaining() and BuffExpires(shattered_defenses_buff) and BuffStacks(executioners_precision_buff) == 2 and Spell(warbreaker) or RageDeficit() < 35 and Spell(focused_rage) or target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } and Spell(rend) or BuffStacks(executioners_precision_buff) == 2 and BuffPresent(shattered_defenses_buff) and Spell(mortal_strike) or Rage() < 40 and Spell(overpower) or { BuffExpires(shattered_defenses_buff) or Rage() >= 40 or Talent(dauntless_talent) and Rage() >= 36 } and Spell(execute_arms)
}

AddFunction ArmsExecuteCdActions
{
}

AddFunction ArmsExecuteCdPostConditions
{
 BuffPresent(battle_cry_buff) and { ArmorSetBonus(T20 4) or HasEquippedItem(the_great_storms_eye) } and Spell(bladestorm_arms) or BuffExpires(shattered_defenses_buff) and { BuffExpires(battle_cry_buff) or BuffRemaining(battle_cry_buff) > GCD() } and Spell(colossus_smash) or { 600 > 90 or not False(raid_event_adds_exists) } and SpellCooldown(mortal_strike) <= GCDRemaining() and BuffExpires(shattered_defenses_buff) and BuffStacks(executioners_precision_buff) == 2 and Spell(warbreaker) or RageDeficit() < 35 and Spell(focused_rage) or target.DebuffRemaining(rend_debuff) < 5 and SpellCooldown(battle_cry) < 2 and { SpellCooldown(bladestorm_arms) < 2 or not ArmorSetBonus(T20 4) } and Spell(rend) or SpellCooldown(battle_cry) <= GCD() and target.DebuffRemaining(colossus_smash_debuff) > 6 and Spell(ravager) or BuffStacks(executioners_precision_buff) == 2 and BuffPresent(shattered_defenses_buff) and Spell(mortal_strike) or Rage() < 40 and Spell(overpower) or { BuffExpires(shattered_defenses_buff) or Rage() >= 40 or Talent(dauntless_talent) and Rage() >= 36 } and Spell(execute_arms) or { 600 > 90 or not False(raid_event_adds_exists) or Enemies() > Enemies(tagged=1) } and not ArmorSetBonus(T20 4) and Spell(bladestorm_arms)
}

### actions.cleave

AddFunction ArmsCleaveMainActions
{
 #mortal_strike
 Spell(mortal_strike)
 #execute,if=buff.stone_heart.react
 if BuffPresent(stone_heart_buff) Spell(execute_arms)
 #colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
 if BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) Spell(colossus_smash)
 #warbreaker,if=buff.shattered_defenses.down
 if BuffExpires(shattered_defenses_buff) Spell(warbreaker)
 #focused_rage,if=rage>100|buff.battle_cry_deadly_calm.up
 if Rage() > 100 or BuffPresent(battle_cry_deadly_calm_buff) Spell(focused_rage)
 #whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&(!talent.focused_rage.enabled|buff.battle_cry_deadly_calm.up|buff.cleave.up)
 if Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 50 } and { not Talent(focused_rage_talent) or BuffPresent(battle_cry_deadly_calm_buff) or BuffPresent(cleave_buff) } Spell(whirlwind)
 #rend,if=remains<=duration*0.3
 if target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 Spell(rend)
 #cleave
 Spell(cleave)
 #whirlwind,if=rage>40|buff.cleave.up
 if Rage() > 40 or BuffPresent(cleave_buff) Spell(whirlwind)
}

AddFunction ArmsCleaveMainPostConditions
{
}

AddFunction ArmsCleaveShortCdActions
{
 unless Spell(mortal_strike) or BuffPresent(stone_heart_buff) and Spell(execute_arms) or BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) and Spell(colossus_smash) or BuffExpires(shattered_defenses_buff) and Spell(warbreaker) or { Rage() > 100 or BuffPresent(battle_cry_deadly_calm_buff) } and Spell(focused_rage) or Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 50 } and { not Talent(focused_rage_talent) or BuffPresent(battle_cry_deadly_calm_buff) or BuffPresent(cleave_buff) } and Spell(whirlwind) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Spell(rend)
 {
  #bladestorm
  Spell(bladestorm_arms)

  unless Spell(cleave) or { Rage() > 40 or BuffPresent(cleave_buff) } and Spell(whirlwind)
  {
   #shockwave
   Spell(shockwave)
   #storm_bolt
   Spell(storm_bolt)
  }
 }
}

AddFunction ArmsCleaveShortCdPostConditions
{
 Spell(mortal_strike) or BuffPresent(stone_heart_buff) and Spell(execute_arms) or BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) and Spell(colossus_smash) or BuffExpires(shattered_defenses_buff) and Spell(warbreaker) or { Rage() > 100 or BuffPresent(battle_cry_deadly_calm_buff) } and Spell(focused_rage) or Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 50 } and { not Talent(focused_rage_talent) or BuffPresent(battle_cry_deadly_calm_buff) or BuffPresent(cleave_buff) } and Spell(whirlwind) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Spell(rend) or Spell(cleave) or { Rage() > 40 or BuffPresent(cleave_buff) } and Spell(whirlwind)
}

AddFunction ArmsCleaveCdActions
{
}

AddFunction ArmsCleaveCdPostConditions
{
 Spell(mortal_strike) or BuffPresent(stone_heart_buff) and Spell(execute_arms) or BuffExpires(shattered_defenses_buff) and BuffExpires(precise_strikes_buff) and Spell(colossus_smash) or BuffExpires(shattered_defenses_buff) and Spell(warbreaker) or { Rage() > 100 or BuffPresent(battle_cry_deadly_calm_buff) } and Spell(focused_rage) or Talent(fervor_of_battle_talent) and { target.DebuffPresent(colossus_smash_debuff) or RageDeficit() < 50 } and { not Talent(focused_rage_talent) or BuffPresent(battle_cry_deadly_calm_buff) or BuffPresent(cleave_buff) } and Spell(whirlwind) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Spell(rend) or Spell(bladestorm_arms) or Spell(cleave) or { Rage() > 40 or BuffPresent(cleave_buff) } and Spell(whirlwind) or Spell(shockwave) or Spell(storm_bolt)
}

### actions.aoe

AddFunction ArmsAoeMainActions
{
 #warbreaker,if=(cooldown.bladestorm.up|cooldown.bladestorm.remains<=gcd)&(cooldown.battle_cry.up|cooldown.battle_cry.remains<=gcd)
 if { not SpellCooldown(bladestorm_arms) > 0 or SpellCooldown(bladestorm_arms) <= GCD() } and { not SpellCooldown(battle_cry) > 0 or SpellCooldown(battle_cry) <= GCD() } Spell(warbreaker)
 #colossus_smash,if=buff.in_for_the_kill.down&talent.in_for_the_kill.enabled
 if BuffExpires(in_for_the_kill_buff) and Talent(in_for_the_kill_talent) Spell(colossus_smash)
 #colossus_smash,cycle_targets=1,if=debuff.colossus_smash.down&spell_targets.whirlwind<=10
 if target.DebuffExpires(colossus_smash_debuff) and Enemies() <= 10 Spell(colossus_smash)
 #cleave,if=spell_targets.whirlwind>=5
 if Enemies() >= 5 Spell(cleave)
 #whirlwind,if=spell_targets.whirlwind>=5&buff.cleave.up
 if Enemies() >= 5 and BuffPresent(cleave_buff) Spell(whirlwind)
 #whirlwind,if=spell_targets.whirlwind>=7
 if Enemies() >= 7 Spell(whirlwind)
 #colossus_smash,if=buff.shattered_defenses.down
 if BuffExpires(shattered_defenses_buff) Spell(colossus_smash)
 #execute,if=buff.stone_heart.react
 if BuffPresent(stone_heart_buff) Spell(execute_arms)
 #mortal_strike,if=buff.shattered_defenses.up|buff.executioners_precision.down
 if BuffPresent(shattered_defenses_buff) or BuffExpires(executioners_precision_buff) Spell(mortal_strike)
 #rend,cycle_targets=1,if=remains<=duration*0.3&spell_targets.whirlwind<=3
 if target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Enemies() <= 3 Spell(rend)
 #cleave
 Spell(cleave)
 #whirlwind
 Spell(whirlwind)
}

AddFunction ArmsAoeMainPostConditions
{
}

AddFunction ArmsAoeShortCdActions
{
 unless { not SpellCooldown(bladestorm_arms) > 0 or SpellCooldown(bladestorm_arms) <= GCD() } and { not SpellCooldown(battle_cry) > 0 or SpellCooldown(battle_cry) <= GCD() } and Spell(warbreaker)
 {
  #bladestorm,if=buff.battle_cry.up&(set_bonus.tier20_4pc|equipped.the_great_storms_eye)
  if BuffPresent(battle_cry_buff) and { ArmorSetBonus(T20 4) or HasEquippedItem(the_great_storms_eye) } Spell(bladestorm_arms)
 }
}

AddFunction ArmsAoeShortCdPostConditions
{
 { not SpellCooldown(bladestorm_arms) > 0 or SpellCooldown(bladestorm_arms) <= GCD() } and { not SpellCooldown(battle_cry) > 0 or SpellCooldown(battle_cry) <= GCD() } and Spell(warbreaker) or BuffExpires(in_for_the_kill_buff) and Talent(in_for_the_kill_talent) and Spell(colossus_smash) or target.DebuffExpires(colossus_smash_debuff) and Enemies() <= 10 and Spell(colossus_smash) or Enemies() >= 5 and Spell(cleave) or Enemies() >= 5 and BuffPresent(cleave_buff) and Spell(whirlwind) or Enemies() >= 7 and Spell(whirlwind) or BuffExpires(shattered_defenses_buff) and Spell(colossus_smash) or BuffPresent(stone_heart_buff) and Spell(execute_arms) or { BuffPresent(shattered_defenses_buff) or BuffExpires(executioners_precision_buff) } and Spell(mortal_strike) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Enemies() <= 3 and Spell(rend) or Spell(cleave) or Spell(whirlwind)
}

AddFunction ArmsAoeCdActions
{
}

AddFunction ArmsAoeCdPostConditions
{
 { not SpellCooldown(bladestorm_arms) > 0 or SpellCooldown(bladestorm_arms) <= GCD() } and { not SpellCooldown(battle_cry) > 0 or SpellCooldown(battle_cry) <= GCD() } and Spell(warbreaker) or BuffPresent(battle_cry_buff) and { ArmorSetBonus(T20 4) or HasEquippedItem(the_great_storms_eye) } and Spell(bladestorm_arms) or BuffExpires(in_for_the_kill_buff) and Talent(in_for_the_kill_talent) and Spell(colossus_smash) or target.DebuffExpires(colossus_smash_debuff) and Enemies() <= 10 and Spell(colossus_smash) or Enemies() >= 5 and Spell(cleave) or Enemies() >= 5 and BuffPresent(cleave_buff) and Spell(whirlwind) or Enemies() >= 7 and Spell(whirlwind) or BuffExpires(shattered_defenses_buff) and Spell(colossus_smash) or BuffPresent(stone_heart_buff) and Spell(execute_arms) or { BuffPresent(shattered_defenses_buff) or BuffExpires(executioners_precision_buff) } and Spell(mortal_strike) or target.DebuffRemaining(rend_debuff) <= BaseDuration(rend_debuff) * 0 and Enemies() <= 3 and Spell(rend) or Spell(cleave) or Spell(whirlwind)
}

### actions.default

AddFunction ArmsDefaultMainActions
{
 #charge
 if CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(charge)
 #run_action_list,name=cleave,if=spell_targets.whirlwind>=2&talent.sweeping_strikes.enabled
 if Enemies() >= 2 and Talent(sweeping_strikes_talent) ArmsCleaveMainActions()

 unless Enemies() >= 2 and Talent(sweeping_strikes_talent) and ArmsCleaveMainPostConditions()
 {
  #run_action_list,name=aoe,if=spell_targets.whirlwind>=5&!talent.sweeping_strikes.enabled
  if Enemies() >= 5 and not Talent(sweeping_strikes_talent) ArmsAoeMainActions()

  unless Enemies() >= 5 and not Talent(sweeping_strikes_talent) and ArmsAoeMainPostConditions()
  {
   #run_action_list,name=execute,target_if=target.health.pct<=20&spell_targets.whirlwind<5
   if target.HealthPercent() <= 20 and Enemies() < 5 ArmsExecuteMainActions()

   unless target.HealthPercent() <= 20 and Enemies() < 5 and ArmsExecuteMainPostConditions()
   {
    #run_action_list,name=single,if=target.health.pct>20
    if target.HealthPercent() > 20 ArmsSingleMainActions()
   }
  }
 }
}

AddFunction ArmsDefaultMainPostConditions
{
 Enemies() >= 2 and Talent(sweeping_strikes_talent) and ArmsCleaveMainPostConditions() or Enemies() >= 5 and not Talent(sweeping_strikes_talent) and ArmsAoeMainPostConditions() or target.HealthPercent() <= 20 and Enemies() < 5 and ArmsExecuteMainPostConditions() or target.HealthPercent() > 20 and ArmsSingleMainPostConditions()
}

AddFunction ArmsDefaultShortCdActions
{
 unless CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge)
 {
  #auto_attack
  ArmsGetInMeleeRange()
  #run_action_list,name=cleave,if=spell_targets.whirlwind>=2&talent.sweeping_strikes.enabled
  if Enemies() >= 2 and Talent(sweeping_strikes_talent) ArmsCleaveShortCdActions()

  unless Enemies() >= 2 and Talent(sweeping_strikes_talent) and ArmsCleaveShortCdPostConditions()
  {
   #run_action_list,name=aoe,if=spell_targets.whirlwind>=5&!talent.sweeping_strikes.enabled
   if Enemies() >= 5 and not Talent(sweeping_strikes_talent) ArmsAoeShortCdActions()

   unless Enemies() >= 5 and not Talent(sweeping_strikes_talent) and ArmsAoeShortCdPostConditions()
   {
    #run_action_list,name=execute,target_if=target.health.pct<=20&spell_targets.whirlwind<5
    if target.HealthPercent() <= 20 and Enemies() < 5 ArmsExecuteShortCdActions()

    unless target.HealthPercent() <= 20 and Enemies() < 5 and ArmsExecuteShortCdPostConditions()
    {
     #run_action_list,name=single,if=target.health.pct>20
     if target.HealthPercent() > 20 ArmsSingleShortCdActions()
    }
   }
  }
 }
}

AddFunction ArmsDefaultShortCdPostConditions
{
 CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge) or Enemies() >= 2 and Talent(sweeping_strikes_talent) and ArmsCleaveShortCdPostConditions() or Enemies() >= 5 and not Talent(sweeping_strikes_talent) and ArmsAoeShortCdPostConditions() or target.HealthPercent() <= 20 and Enemies() < 5 and ArmsExecuteShortCdPostConditions() or target.HealthPercent() > 20 and ArmsSingleShortCdPostConditions()
}

AddFunction ArmsDefaultCdActions
{
 unless CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge)
 {
  #potion,name=old_war,if=(!talent.avatar.enabled|buff.avatar.up)&buff.battle_cry.up&debuff.colossus_smash.up|target.time_to_die<=26
  if { { not Talent(avatar_talent) or BuffPresent(avatar_buff) } and BuffPresent(battle_cry_buff) and target.DebuffPresent(colossus_smash_debuff) or target.TimeToDie() <= 26 } and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(old_war_potion usable=1)
  #blood_fury,if=buff.battle_cry.up|target.time_to_die<=16
  if BuffPresent(battle_cry_buff) or target.TimeToDie() <= 16 Spell(blood_fury_ap)
  #berserking,if=buff.battle_cry.up|target.time_to_die<=11
  if BuffPresent(battle_cry_buff) or target.TimeToDie() <= 11 Spell(berserking)
  #arcane_torrent,if=buff.battle_cry_deadly_calm.down&rage.deficit>40&cooldown.battle_cry.remains
  if BuffExpires(battle_cry_deadly_calm_buff) and RageDeficit() > 40 and SpellCooldown(battle_cry) > 0 Spell(arcane_torrent_rage)
  #avatar,if=gcd.remains<0.25&(buff.battle_cry.up|cooldown.battle_cry.remains<15)|target.time_to_die<=20
  if 0 < 0 and { BuffPresent(battle_cry_buff) or SpellCooldown(battle_cry) < 15 } or target.TimeToDie() <= 20 Spell(avatar)
  #use_item,name=gift_of_radiance,if=(buff.avatar.up|!talent.avatar.enabled)&debuff.colossus_smash.up&buff.battle_cry.up
  if { BuffPresent(avatar_buff) or not Talent(avatar_talent) } and target.DebuffPresent(colossus_smash_debuff) and BuffPresent(battle_cry_buff) ArmsUseItemActions()
  #battle_cry,if=target.time_to_die<=6|(gcd.remains<=0.5&prev_gcd.1.ravager)|!talent.ravager.enabled&!gcd.remains&target.debuff.colossus_smash.remains>=5&(!cooldown.bladestorm.remains|!set_bonus.tier20_4pc)&(!talent.rend.enabled|dot.rend.remains>4)
  if target.TimeToDie() <= 6 or 0 <= 0 and PreviousGCDSpell(ravager) or not Talent(ravager_talent) and not 0 and target.DebuffRemaining(colossus_smash_debuff) >= 5 and { not SpellCooldown(bladestorm_arms) > 0 or not ArmorSetBonus(T20 4) } and { not Talent(rend_talent) or target.DebuffRemaining(rend_debuff) > 4 } Spell(battle_cry)
  #run_action_list,name=cleave,if=spell_targets.whirlwind>=2&talent.sweeping_strikes.enabled
  if Enemies() >= 2 and Talent(sweeping_strikes_talent) ArmsCleaveCdActions()

  unless Enemies() >= 2 and Talent(sweeping_strikes_talent) and ArmsCleaveCdPostConditions()
  {
   #run_action_list,name=aoe,if=spell_targets.whirlwind>=5&!talent.sweeping_strikes.enabled
   if Enemies() >= 5 and not Talent(sweeping_strikes_talent) ArmsAoeCdActions()

   unless Enemies() >= 5 and not Talent(sweeping_strikes_talent) and ArmsAoeCdPostConditions()
   {
    #run_action_list,name=execute,target_if=target.health.pct<=20&spell_targets.whirlwind<5
    if target.HealthPercent() <= 20 and Enemies() < 5 ArmsExecuteCdActions()

    unless target.HealthPercent() <= 20 and Enemies() < 5 and ArmsExecuteCdPostConditions()
    {
     #run_action_list,name=single,if=target.health.pct>20
     if target.HealthPercent() > 20 ArmsSingleCdActions()
    }
   }
  }
 }
}

AddFunction ArmsDefaultCdPostConditions
{
 CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge) or Enemies() >= 2 and Talent(sweeping_strikes_talent) and ArmsCleaveCdPostConditions() or Enemies() >= 5 and not Talent(sweeping_strikes_talent) and ArmsAoeCdPostConditions() or target.HealthPercent() <= 20 and Enemies() < 5 and ArmsExecuteCdPostConditions() or target.HealthPercent() > 20 and ArmsSingleCdPostConditions()
}

### Arms icons.

AddCheckBox(opt_warrior_arms_aoe L(AOE) default specialization=arms)

AddIcon checkbox=!opt_warrior_arms_aoe enemies=1 help=shortcd specialization=arms
{
 if not InCombat() ArmsPrecombatShortCdActions()
 unless not InCombat() and ArmsPrecombatShortCdPostConditions()
 {
  ArmsDefaultShortCdActions()
 }
}

AddIcon checkbox=opt_warrior_arms_aoe help=shortcd specialization=arms
{
 if not InCombat() ArmsPrecombatShortCdActions()
 unless not InCombat() and ArmsPrecombatShortCdPostConditions()
 {
  ArmsDefaultShortCdActions()
 }
}

AddIcon enemies=1 help=main specialization=arms
{
 if not InCombat() ArmsPrecombatMainActions()
 unless not InCombat() and ArmsPrecombatMainPostConditions()
 {
  ArmsDefaultMainActions()
 }
}

AddIcon checkbox=opt_warrior_arms_aoe help=aoe specialization=arms
{
 if not InCombat() ArmsPrecombatMainActions()
 unless not InCombat() and ArmsPrecombatMainPostConditions()
 {
  ArmsDefaultMainActions()
 }
}

AddIcon checkbox=!opt_warrior_arms_aoe enemies=1 help=cd specialization=arms
{
 if not InCombat() ArmsPrecombatCdActions()
 unless not InCombat() and ArmsPrecombatCdPostConditions()
 {
  ArmsDefaultCdActions()
 }
}

AddIcon checkbox=opt_warrior_arms_aoe help=cd specialization=arms
{
 if not InCombat() ArmsPrecombatCdActions()
 unless not InCombat() and ArmsPrecombatCdPostConditions()
 {
  ArmsDefaultCdActions()
 }
}

### Required symbols
# bladestorm_arms
# battle_cry_buff
# colossus_smash
# shattered_defenses_buff
# warbreaker
# fervor_of_battle_talent
# colossus_smash_debuff
# stone_heart_buff
# mortal_strike
# focused_rage
# battle_cry_deadly_calm_buff
# focused_rage_buff
# anger_management_talent
# battle_cry
# rend
# rend_debuff
# ravager
# execute_arms
# overpower
# executioners_precision_buff
# whirlwind
# slam
# rend_talent
# ravager_talent
# old_war_potion
# the_great_storms_eye
# dauntless_talent
# precise_strikes_buff
# focused_rage_talent
# cleave_buff
# cleave
# shockwave
# storm_bolt
# in_for_the_kill_buff
# in_for_the_kill_talent
# charge
# avatar_talent
# avatar_buff
# blood_fury_ap
# berserking
# arcane_torrent_rage
# avatar
# sweeping_strikes_talent
# heroic_leap
# pummel
]]
    OvaleScripts:RegisterScript("WARRIOR", "arms", name, desc, code, "script")
end
do
    local name = "sc_warrior_fury_t19"
    local desc = "[7.0] Simulationcraft: Warrior_Fury_T19"
    local code = [[
# Based on SimulationCraft profile "Warrior_Fury_T19P".
#	class=warrior
#	spec=fury
#	talents=2333232

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=fury)
AddCheckBox(opt_use_consumables L(opt_use_consumables) default specialization=fury)

AddFunction FuryUseItemActions
{
 Item(Trinket0Slot text=13 usable=1)
 Item(Trinket1Slot text=14 usable=1)
}

AddFunction FuryGetInMeleeRange
{
 if CheckBoxOn(opt_melee_range) and not InFlightToTarget(charge) and not InFlightToTarget(heroic_leap)
 {
  if target.InRange(charge) Spell(charge)
  if SpellCharges(charge) == 0 and target.Distance(atLeast 8) and target.Distance(atMost 40) Spell(heroic_leap)
  if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
 }
}

### actions.three_targets

AddFunction FuryThreetargetsMainActions
{
 #execute,if=buff.stone_heart.react
 if BuffPresent(stone_heart_buff) Spell(execute)
 #rampage,if=buff.meat_cleaver.up&((buff.enrage.down&!talent.frothing_berserker.enabled)|(rage>=100&talent.frothing_berserker.enabled))|buff.massacre.react
 if BuffPresent(meat_cleaver_buff) and { not IsEnraged() and not Talent(frothing_berserker_talent) or Rage() >= 100 and Talent(frothing_berserker_talent) } or BuffPresent(massacre_buff) Spell(rampage)
 #raging_blow,if=talent.inner_rage.enabled
 if Talent(inner_rage_talent) Spell(raging_blow)
 #bloodthirst
 Spell(bloodthirst)
 #whirlwind
 Spell(whirlwind)
}

AddFunction FuryThreetargetsMainPostConditions
{
}

AddFunction FuryThreetargetsShortCdActions
{
}

AddFunction FuryThreetargetsShortCdPostConditions
{
 BuffPresent(stone_heart_buff) and Spell(execute) or { BuffPresent(meat_cleaver_buff) and { not IsEnraged() and not Talent(frothing_berserker_talent) or Rage() >= 100 and Talent(frothing_berserker_talent) } or BuffPresent(massacre_buff) } and Spell(rampage) or Talent(inner_rage_talent) and Spell(raging_blow) or Spell(bloodthirst) or Spell(whirlwind)
}

AddFunction FuryThreetargetsCdActions
{
}

AddFunction FuryThreetargetsCdPostConditions
{
 BuffPresent(stone_heart_buff) and Spell(execute) or { BuffPresent(meat_cleaver_buff) and { not IsEnraged() and not Talent(frothing_berserker_talent) or Rage() >= 100 and Talent(frothing_berserker_talent) } or BuffPresent(massacre_buff) } and Spell(rampage) or Talent(inner_rage_talent) and Spell(raging_blow) or Spell(bloodthirst) or Spell(whirlwind)
}

### actions.single_target

AddFunction FurySingletargetMainActions
{
 #bloodthirst,if=buff.fujiedas_fury.up&buff.fujiedas_fury.remains<2
 if BuffPresent(fujiedas_fury_buff) and BuffRemaining(fujiedas_fury_buff) < 2 Spell(bloodthirst)
 #furious_slash,if=talent.frenzy.enabled&(buff.frenzy.down|buff.frenzy.remains<=2)
 if Talent(frenzy_talent) and { BuffExpires(frenzy_buff) or BuffRemaining(frenzy_buff) <= 2 } Spell(furious_slash)
 #raging_blow,if=buff.enrage.up&talent.inner_rage.enabled
 if IsEnraged() and Talent(inner_rage_talent) Spell(raging_blow)
 #rampage,if=target.health.pct>21&((buff.enrage.down&!talent.frothing_berserker.enabled)|buff.massacre.react|rage>=100)
 if target.HealthPercent() > 21 and { not IsEnraged() and not Talent(frothing_berserker_talent) or BuffPresent(massacre_buff) or Rage() >= 100 } Spell(rampage)
 #execute,if=buff.stone_heart.react&((talent.inner_rage.enabled&cooldown.raging_blow.remains>1)|buff.enrage.up)
 if BuffPresent(stone_heart_buff) and { Talent(inner_rage_talent) and SpellCooldown(raging_blow) > 1 or IsEnraged() } Spell(execute)
 #bloodthirst
 Spell(bloodthirst)
 #furious_slash,if=set_bonus.tier19_2pc&!talent.inner_rage.enabled
 if ArmorSetBonus(T19 2) and not Talent(inner_rage_talent) Spell(furious_slash)
 #raging_blow
 Spell(raging_blow)
 #whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
 if BuffPresent(wrecking_ball_buff) and IsEnraged() Spell(whirlwind)
 #furious_slash
 Spell(furious_slash)
}

AddFunction FurySingletargetMainPostConditions
{
}

AddFunction FurySingletargetShortCdActions
{
}

AddFunction FurySingletargetShortCdPostConditions
{
 BuffPresent(fujiedas_fury_buff) and BuffRemaining(fujiedas_fury_buff) < 2 and Spell(bloodthirst) or Talent(frenzy_talent) and { BuffExpires(frenzy_buff) or BuffRemaining(frenzy_buff) <= 2 } and Spell(furious_slash) or IsEnraged() and Talent(inner_rage_talent) and Spell(raging_blow) or target.HealthPercent() > 21 and { not IsEnraged() and not Talent(frothing_berserker_talent) or BuffPresent(massacre_buff) or Rage() >= 100 } and Spell(rampage) or BuffPresent(stone_heart_buff) and { Talent(inner_rage_talent) and SpellCooldown(raging_blow) > 1 or IsEnraged() } and Spell(execute) or Spell(bloodthirst) or ArmorSetBonus(T19 2) and not Talent(inner_rage_talent) and Spell(furious_slash) or Spell(raging_blow) or BuffPresent(wrecking_ball_buff) and IsEnraged() and Spell(whirlwind) or Spell(furious_slash)
}

AddFunction FurySingletargetCdActions
{
}

AddFunction FurySingletargetCdPostConditions
{
 BuffPresent(fujiedas_fury_buff) and BuffRemaining(fujiedas_fury_buff) < 2 and Spell(bloodthirst) or Talent(frenzy_talent) and { BuffExpires(frenzy_buff) or BuffRemaining(frenzy_buff) <= 2 } and Spell(furious_slash) or IsEnraged() and Talent(inner_rage_talent) and Spell(raging_blow) or target.HealthPercent() > 21 and { not IsEnraged() and not Talent(frothing_berserker_talent) or BuffPresent(massacre_buff) or Rage() >= 100 } and Spell(rampage) or BuffPresent(stone_heart_buff) and { Talent(inner_rage_talent) and SpellCooldown(raging_blow) > 1 or IsEnraged() } and Spell(execute) or Spell(bloodthirst) or ArmorSetBonus(T19 2) and not Talent(inner_rage_talent) and Spell(furious_slash) or Spell(raging_blow) or BuffPresent(wrecking_ball_buff) and IsEnraged() and Spell(whirlwind) or Spell(furious_slash)
}

### actions.precombat

AddFunction FuryPrecombatMainActions
{
}

AddFunction FuryPrecombatMainPostConditions
{
}

AddFunction FuryPrecombatShortCdActions
{
}

AddFunction FuryPrecombatShortCdPostConditions
{
}

AddFunction FuryPrecombatCdActions
{
 #flask,type=countless_armies
 #food,type=lavish_suramar_feast
 #augmentation,type=defiled
 #snapshot_stats
 #potion,name=old_war
 if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(old_war_potion usable=1)
}

AddFunction FuryPrecombatCdPostConditions
{
}

### actions.movement

AddFunction FuryMovementMainActions
{
}

AddFunction FuryMovementMainPostConditions
{
}

AddFunction FuryMovementShortCdActions
{
 #heroic_leap
 if CheckBoxOn(opt_melee_range) and target.Distance(atLeast 8) and target.Distance(atMost 40) Spell(heroic_leap)
}

AddFunction FuryMovementShortCdPostConditions
{
}

AddFunction FuryMovementCdActions
{
}

AddFunction FuryMovementCdPostConditions
{
 CheckBoxOn(opt_melee_range) and target.Distance(atLeast 8) and target.Distance(atMost 40) and Spell(heroic_leap)
}

### actions.execute

AddFunction FuryExecuteMainActions
{
 #bloodthirst,if=buff.fujiedas_fury.up&buff.fujiedas_fury.remains<2
 if BuffPresent(fujiedas_fury_buff) and BuffRemaining(fujiedas_fury_buff) < 2 Spell(bloodthirst)
 #execute,if=artifact.juggernaut.enabled&(!buff.juggernaut.up|buff.juggernaut.remains<2)|buff.stone_heart.react
 if HasArtifactTrait(juggernaut) and { not BuffPresent(juggernaut_buff) or BuffRemaining(juggernaut_buff) < 2 } or BuffPresent(stone_heart_buff) Spell(execute)
 #furious_slash,if=talent.frenzy.enabled&buff.frenzy.remains<=2
 if Talent(frenzy_talent) and BuffRemaining(frenzy_buff) <= 2 Spell(furious_slash)
 #execute,if=cooldown.battle_cry.remains<5
 if SpellCooldown(battle_cry) < 5 Spell(execute)
 #rampage,if=buff.massacre.react&buff.enrage.remains<1
 if BuffPresent(massacre_buff) and EnrageRemaining() < 1 Spell(rampage)
 #execute
 Spell(execute)
 #bloodthirst
 Spell(bloodthirst)
 #furious_slash,if=set_bonus.tier19_2pc
 if ArmorSetBonus(T19 2) Spell(furious_slash)
 #raging_blow
 Spell(raging_blow)
 #odyns_fury,if=buff.enrage.up&rage<100
 if IsEnraged() and Rage() < 100 Spell(odyns_fury)
 #furious_slash
 Spell(furious_slash)
}

AddFunction FuryExecuteMainPostConditions
{
}

AddFunction FuryExecuteShortCdActions
{
}

AddFunction FuryExecuteShortCdPostConditions
{
 BuffPresent(fujiedas_fury_buff) and BuffRemaining(fujiedas_fury_buff) < 2 and Spell(bloodthirst) or { HasArtifactTrait(juggernaut) and { not BuffPresent(juggernaut_buff) or BuffRemaining(juggernaut_buff) < 2 } or BuffPresent(stone_heart_buff) } and Spell(execute) or Talent(frenzy_talent) and BuffRemaining(frenzy_buff) <= 2 and Spell(furious_slash) or SpellCooldown(battle_cry) < 5 and Spell(execute) or BuffPresent(massacre_buff) and EnrageRemaining() < 1 and Spell(rampage) or Spell(execute) or Spell(bloodthirst) or ArmorSetBonus(T19 2) and Spell(furious_slash) or Spell(raging_blow) or IsEnraged() and Rage() < 100 and Spell(odyns_fury) or Spell(furious_slash)
}

AddFunction FuryExecuteCdActions
{
}

AddFunction FuryExecuteCdPostConditions
{
 BuffPresent(fujiedas_fury_buff) and BuffRemaining(fujiedas_fury_buff) < 2 and Spell(bloodthirst) or { HasArtifactTrait(juggernaut) and { not BuffPresent(juggernaut_buff) or BuffRemaining(juggernaut_buff) < 2 } or BuffPresent(stone_heart_buff) } and Spell(execute) or Talent(frenzy_talent) and BuffRemaining(frenzy_buff) <= 2 and Spell(furious_slash) or SpellCooldown(battle_cry) < 5 and Spell(execute) or BuffPresent(massacre_buff) and EnrageRemaining() < 1 and Spell(rampage) or Spell(execute) or Spell(bloodthirst) or ArmorSetBonus(T19 2) and Spell(furious_slash) or Spell(raging_blow) or IsEnraged() and Rage() < 100 and Spell(odyns_fury) or Spell(furious_slash)
}

### actions.cooldowns

AddFunction FuryCooldownsMainActions
{
 #rampage,if=talent.massacre.enabled&buff.massacre.react&buff.enrage.remains<1
 if Talent(massacre_talent) and BuffPresent(massacre_buff) and EnrageRemaining() < 1 Spell(rampage)
 #bloodthirst,if=target.health.pct<20&buff.enrage.remains<1
 if target.HealthPercent() < 20 and EnrageRemaining() < 1 Spell(bloodthirst)
 #execute,if=equipped.draught_of_souls&cooldown.draught_of_souls.remains<1&buff.juggernaut.remains<3
 if HasEquippedItem(draught_of_souls) and SpellCooldown(draught_of_souls) < 1 and BuffRemaining(juggernaut_buff) < 3 Spell(execute)
 #odyns_fury,if=buff.enrage.up&cooldown.raging_blow.remains>0&target.health.pct>20
 if IsEnraged() and SpellCooldown(raging_blow) > 0 and target.HealthPercent() > 20 Spell(odyns_fury)
 #execute
 Spell(execute)
 #raging_blow,if=talent.inner_rage.enabled&buff.enrage.up
 if Talent(inner_rage_talent) and IsEnraged() Spell(raging_blow)
 #rampage,if=talent.reckless_abandon.enabled&!talent.frothing_berserker.enabled|(talent.frothing_berserker.enabled&rage>=100)
 if Talent(reckless_abandon_talent) and not Talent(frothing_berserker_talent) or Talent(frothing_berserker_talent) and Rage() >= 100 Spell(rampage)
 #bloodthirst,if=buff.enrage.remains<1&!talent.outburst.enabled
 if EnrageRemaining() < 1 and not Talent(outburst_talent) Spell(bloodthirst)
 #raging_blow
 Spell(raging_blow)
 #bloodthirst
 Spell(bloodthirst)
 #whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
 if BuffPresent(wrecking_ball_buff) and IsEnraged() Spell(whirlwind)
 #furious_slash
 Spell(furious_slash)
}

AddFunction FuryCooldownsMainPostConditions
{
}

AddFunction FuryCooldownsShortCdActions
{
 unless Talent(massacre_talent) and BuffPresent(massacre_buff) and EnrageRemaining() < 1 and Spell(rampage) or target.HealthPercent() < 20 and EnrageRemaining() < 1 and Spell(bloodthirst) or HasEquippedItem(draught_of_souls) and SpellCooldown(draught_of_souls) < 1 and BuffRemaining(juggernaut_buff) < 3 and Spell(execute) or IsEnraged() and SpellCooldown(raging_blow) > 0 and target.HealthPercent() > 20 and Spell(odyns_fury) or Spell(execute) or Talent(inner_rage_talent) and IsEnraged() and Spell(raging_blow) or { Talent(reckless_abandon_talent) and not Talent(frothing_berserker_talent) or Talent(frothing_berserker_talent) and Rage() >= 100 } and Spell(rampage)
 {
  #berserker_rage,if=talent.outburst.enabled&buff.enrage.down&buff.battle_cry.up
  if Talent(outburst_talent) and not IsEnraged() and BuffPresent(battle_cry_buff) Spell(berserker_rage)
 }
}

AddFunction FuryCooldownsShortCdPostConditions
{
 Talent(massacre_talent) and BuffPresent(massacre_buff) and EnrageRemaining() < 1 and Spell(rampage) or target.HealthPercent() < 20 and EnrageRemaining() < 1 and Spell(bloodthirst) or HasEquippedItem(draught_of_souls) and SpellCooldown(draught_of_souls) < 1 and BuffRemaining(juggernaut_buff) < 3 and Spell(execute) or IsEnraged() and SpellCooldown(raging_blow) > 0 and target.HealthPercent() > 20 and Spell(odyns_fury) or Spell(execute) or Talent(inner_rage_talent) and IsEnraged() and Spell(raging_blow) or { Talent(reckless_abandon_talent) and not Talent(frothing_berserker_talent) or Talent(frothing_berserker_talent) and Rage() >= 100 } and Spell(rampage) or EnrageRemaining() < 1 and not Talent(outburst_talent) and Spell(bloodthirst) or Spell(raging_blow) or Spell(bloodthirst) or BuffPresent(wrecking_ball_buff) and IsEnraged() and Spell(whirlwind) or Spell(furious_slash)
}

AddFunction FuryCooldownsCdActions
{
}

AddFunction FuryCooldownsCdPostConditions
{
 Talent(massacre_talent) and BuffPresent(massacre_buff) and EnrageRemaining() < 1 and Spell(rampage) or target.HealthPercent() < 20 and EnrageRemaining() < 1 and Spell(bloodthirst) or HasEquippedItem(draught_of_souls) and SpellCooldown(draught_of_souls) < 1 and BuffRemaining(juggernaut_buff) < 3 and Spell(execute) or IsEnraged() and SpellCooldown(raging_blow) > 0 and target.HealthPercent() > 20 and Spell(odyns_fury) or Spell(execute) or Talent(inner_rage_talent) and IsEnraged() and Spell(raging_blow) or { Talent(reckless_abandon_talent) and not Talent(frothing_berserker_talent) or Talent(frothing_berserker_talent) and Rage() >= 100 } and Spell(rampage) or Talent(outburst_talent) and not IsEnraged() and BuffPresent(battle_cry_buff) and Spell(berserker_rage) or EnrageRemaining() < 1 and not Talent(outburst_talent) and Spell(bloodthirst) or Spell(raging_blow) or Spell(bloodthirst) or BuffPresent(wrecking_ball_buff) and IsEnraged() and Spell(whirlwind) or Spell(furious_slash)
}

### actions.aoe

AddFunction FuryAoeMainActions
{
 #bloodthirst,if=buff.enrage.down|rage<90
 if not IsEnraged() or Rage() < 90 Spell(bloodthirst)
 #whirlwind,if=buff.meat_cleaver.down
 if BuffExpires(meat_cleaver_buff) Spell(whirlwind)
 #rampage,if=buff.meat_cleaver.up&(buff.enrage.down&!talent.frothing_berserker.enabled|buff.massacre.react|rage>=100)
 if BuffPresent(meat_cleaver_buff) and { not IsEnraged() and not Talent(frothing_berserker_talent) or BuffPresent(massacre_buff) or Rage() >= 100 } Spell(rampage)
 #bloodthirst
 Spell(bloodthirst)
 #whirlwind
 Spell(whirlwind)
}

AddFunction FuryAoeMainPostConditions
{
}

AddFunction FuryAoeShortCdActions
{
 unless { not IsEnraged() or Rage() < 90 } and Spell(bloodthirst)
 {
  #bladestorm,if=buff.enrage.remains>2&(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
  if EnrageRemaining() > 2 and { 600 > 90 or not False(raid_event_adds_exists) or Enemies() > Enemies(tagged=1) } Spell(bladestorm_fury)
 }
}

AddFunction FuryAoeShortCdPostConditions
{
 { not IsEnraged() or Rage() < 90 } and Spell(bloodthirst) or BuffExpires(meat_cleaver_buff) and Spell(whirlwind) or BuffPresent(meat_cleaver_buff) and { not IsEnraged() and not Talent(frothing_berserker_talent) or BuffPresent(massacre_buff) or Rage() >= 100 } and Spell(rampage) or Spell(bloodthirst) or Spell(whirlwind)
}

AddFunction FuryAoeCdActions
{
}

AddFunction FuryAoeCdPostConditions
{
 { not IsEnraged() or Rage() < 90 } and Spell(bloodthirst) or EnrageRemaining() > 2 and { 600 > 90 or not False(raid_event_adds_exists) or Enemies() > Enemies(tagged=1) } and Spell(bladestorm_fury) or BuffExpires(meat_cleaver_buff) and Spell(whirlwind) or BuffPresent(meat_cleaver_buff) and { not IsEnraged() and not Talent(frothing_berserker_talent) or BuffPresent(massacre_buff) or Rage() >= 100 } and Spell(rampage) or Spell(bloodthirst) or Spell(whirlwind)
}

### actions.default

AddFunction FuryDefaultMainActions
{
 #charge
 if CheckBoxOn(opt_melee_range) and target.InRange(charge) Spell(charge)
 #run_action_list,name=movement,if=movement.distance>5
 if target.Distance() > 5 FuryMovementMainActions()

 unless target.Distance() > 5 and FuryMovementMainPostConditions()
 {
  #dragon_roar,if=(equipped.convergence_of_fates&cooldown.battle_cry.remains<2)|!equipped.convergence_of_fates&(!cooldown.battle_cry.remains<=10|cooldown.battle_cry.remains<2)
  if HasEquippedItem(convergence_of_fates) and SpellCooldown(battle_cry) < 2 or not HasEquippedItem(convergence_of_fates) and { not SpellCooldown(battle_cry) <= 10 or SpellCooldown(battle_cry) < 2 } Spell(dragon_roar)
  #rampage,if=cooldown.battle_cry.remains<4&target.health.pct>20
  if SpellCooldown(battle_cry) < 4 and target.HealthPercent() > 20 Spell(rampage)
  #bloodthirst,if=equipped.kazzalax_fujiedas_fury&buff.fujiedas_fury.down
  if HasEquippedItem(kazzalax_fujiedas_fury) and BuffExpires(fujiedas_fury_buff) Spell(bloodthirst)
  #bloodbath,if=buff.dragon_roar.up|!talent.dragon_roar.enabled&buff.battle_cry.up
  if BuffPresent(dragon_roar_buff) or not Talent(dragon_roar_talent) and BuffPresent(battle_cry_buff) Spell(bloodbath)
  #run_action_list,name=cooldowns,if=buff.battle_cry.up&spell_targets.whirlwind=1
  if BuffPresent(battle_cry_buff) and Enemies() == 1 FuryCooldownsMainActions()

  unless BuffPresent(battle_cry_buff) and Enemies() == 1 and FuryCooldownsMainPostConditions()
  {
   #call_action_list,name=three_targets,if=target.health.pct>20&(spell_targets.whirlwind=3|spell_targets.whirlwind=4)
   if target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } FuryThreetargetsMainActions()

   unless target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } and FuryThreetargetsMainPostConditions()
   {
    #call_action_list,name=aoe,if=spell_targets.whirlwind>4
    if Enemies() > 4 FuryAoeMainActions()

    unless Enemies() > 4 and FuryAoeMainPostConditions()
    {
     #run_action_list,name=execute,if=target.health.pct<20
     if target.HealthPercent() < 20 FuryExecuteMainActions()

     unless target.HealthPercent() < 20 and FuryExecuteMainPostConditions()
     {
      #run_action_list,name=single_target,if=target.health.pct>20
      if target.HealthPercent() > 20 FurySingletargetMainActions()
     }
    }
   }
  }
 }
}

AddFunction FuryDefaultMainPostConditions
{
 target.Distance() > 5 and FuryMovementMainPostConditions() or BuffPresent(battle_cry_buff) and Enemies() == 1 and FuryCooldownsMainPostConditions() or target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } and FuryThreetargetsMainPostConditions() or Enemies() > 4 and FuryAoeMainPostConditions() or target.HealthPercent() < 20 and FuryExecuteMainPostConditions() or target.HealthPercent() > 20 and FurySingletargetMainPostConditions()
}

AddFunction FuryDefaultShortCdActions
{
 #auto_attack
 FuryGetInMeleeRange()

 unless CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge)
 {
  #run_action_list,name=movement,if=movement.distance>5
  if target.Distance() > 5 FuryMovementShortCdActions()

  unless target.Distance() > 5 and FuryMovementShortCdPostConditions()
  {
   #heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
   if { target.Distance() > 25 and 600 > 45 or not False(raid_event_movement_exists) } and CheckBoxOn(opt_melee_range) and target.Distance(atLeast 8) and target.Distance(atMost 40) Spell(heroic_leap)

   unless { HasEquippedItem(convergence_of_fates) and SpellCooldown(battle_cry) < 2 or not HasEquippedItem(convergence_of_fates) and { not SpellCooldown(battle_cry) <= 10 or SpellCooldown(battle_cry) < 2 } } and Spell(dragon_roar) or SpellCooldown(battle_cry) < 4 and target.HealthPercent() > 20 and Spell(rampage) or HasEquippedItem(kazzalax_fujiedas_fury) and BuffExpires(fujiedas_fury_buff) and Spell(bloodthirst) or { BuffPresent(dragon_roar_buff) or not Talent(dragon_roar_talent) and BuffPresent(battle_cry_buff) } and Spell(bloodbath)
   {
    #run_action_list,name=cooldowns,if=buff.battle_cry.up&spell_targets.whirlwind=1
    if BuffPresent(battle_cry_buff) and Enemies() == 1 FuryCooldownsShortCdActions()

    unless BuffPresent(battle_cry_buff) and Enemies() == 1 and FuryCooldownsShortCdPostConditions()
    {
     #call_action_list,name=three_targets,if=target.health.pct>20&(spell_targets.whirlwind=3|spell_targets.whirlwind=4)
     if target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } FuryThreetargetsShortCdActions()

     unless target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } and FuryThreetargetsShortCdPostConditions()
     {
      #call_action_list,name=aoe,if=spell_targets.whirlwind>4
      if Enemies() > 4 FuryAoeShortCdActions()

      unless Enemies() > 4 and FuryAoeShortCdPostConditions()
      {
       #run_action_list,name=execute,if=target.health.pct<20
       if target.HealthPercent() < 20 FuryExecuteShortCdActions()

       unless target.HealthPercent() < 20 and FuryExecuteShortCdPostConditions()
       {
        #run_action_list,name=single_target,if=target.health.pct>20
        if target.HealthPercent() > 20 FurySingletargetShortCdActions()
       }
      }
     }
    }
   }
  }
 }
}

AddFunction FuryDefaultShortCdPostConditions
{
 CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge) or target.Distance() > 5 and FuryMovementShortCdPostConditions() or { HasEquippedItem(convergence_of_fates) and SpellCooldown(battle_cry) < 2 or not HasEquippedItem(convergence_of_fates) and { not SpellCooldown(battle_cry) <= 10 or SpellCooldown(battle_cry) < 2 } } and Spell(dragon_roar) or SpellCooldown(battle_cry) < 4 and target.HealthPercent() > 20 and Spell(rampage) or HasEquippedItem(kazzalax_fujiedas_fury) and BuffExpires(fujiedas_fury_buff) and Spell(bloodthirst) or { BuffPresent(dragon_roar_buff) or not Talent(dragon_roar_talent) and BuffPresent(battle_cry_buff) } and Spell(bloodbath) or BuffPresent(battle_cry_buff) and Enemies() == 1 and FuryCooldownsShortCdPostConditions() or target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } and FuryThreetargetsShortCdPostConditions() or Enemies() > 4 and FuryAoeShortCdPostConditions() or target.HealthPercent() < 20 and FuryExecuteShortCdPostConditions() or target.HealthPercent() > 20 and FurySingletargetShortCdPostConditions()
}

AddFunction FuryDefaultCdActions
{
 unless CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge)
 {
  #run_action_list,name=movement,if=movement.distance>5
  if target.Distance() > 5 FuryMovementCdActions()

  unless target.Distance() > 5 and FuryMovementCdPostConditions() or { target.Distance() > 25 and 600 > 45 or not False(raid_event_movement_exists) } and CheckBoxOn(opt_melee_range) and target.Distance(atLeast 8) and target.Distance(atMost 40) and Spell(heroic_leap)
  {
   #potion,name=old_war,if=buff.battle_cry.up&(buff.avatar.up|!talent.avatar.enabled)
   if BuffPresent(battle_cry_buff) and { BuffPresent(avatar_buff) or not Talent(avatar_talent) } and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(old_war_potion usable=1)

   unless { HasEquippedItem(convergence_of_fates) and SpellCooldown(battle_cry) < 2 or not HasEquippedItem(convergence_of_fates) and { not SpellCooldown(battle_cry) <= 10 or SpellCooldown(battle_cry) < 2 } } and Spell(dragon_roar) or SpellCooldown(battle_cry) < 4 and target.HealthPercent() > 20 and Spell(rampage) or HasEquippedItem(kazzalax_fujiedas_fury) and BuffExpires(fujiedas_fury_buff) and Spell(bloodthirst)
   {
    #avatar,if=buff.battle_cry.remains>6|cooldown.battle_cry.remains<10|(target.time_to_die<(cooldown.battle_cry.remains+10))
    if BuffRemaining(battle_cry_buff) > 6 or SpellCooldown(battle_cry) < 10 or target.TimeToDie() < SpellCooldown(battle_cry) + 10 Spell(avatar)
    #use_item,name=umbral_moonglaives,if=equipped.umbral_moonglaives&(cooldown.battle_cry.remains>gcd&cooldown.battle_cry.remains<2|cooldown.battle_cry.remains=0)
    if HasEquippedItem(umbral_moonglaives) and { SpellCooldown(battle_cry) > GCD() and SpellCooldown(battle_cry) < 2 or not SpellCooldown(battle_cry) > 0 } FuryUseItemActions()
    #battle_cry,if=gcd.remains=0&talent.reckless_abandon.enabled&(equipped.umbral_moonglaives&(prev_off_gcd.umbral_glaive_storm|(trinket.cooldown.remains>3&trinket.cooldown.remains<90))|!equipped.umbral_moonglaives)
    if not 0 > 0 and Talent(reckless_abandon_talent) and { HasEquippedItem(umbral_moonglaives) and { PreviousOffGCDSpell(umbral_glaive_storm) or { ItemCooldown(Trinket0Slot) and ItemCooldown(Trinket1Slot) } > 3 and { ItemCooldown(Trinket0Slot) and ItemCooldown(Trinket1Slot) } < 90 } or not HasEquippedItem(umbral_moonglaives) } Spell(battle_cry)
    #battle_cry,if=gcd.remains=0&talent.bladestorm.enabled&(raid_event.adds.in>90|!raid_event.adds.exists|spell_targets.bladestorm_mh>desired_targets)
    if not 0 > 0 and Talent(bladestorm_talent) and { 600 > 90 or not False(raid_event_adds_exists) or Enemies() > Enemies(tagged=1) } Spell(battle_cry)
    #battle_cry,if=gcd.remains=0&buff.dragon_roar.up&(cooldown.bloodthirst.remains=0|buff.enrage.remains>cooldown.bloodthirst.remains)
    if not 0 > 0 and BuffPresent(dragon_roar_buff) and { not SpellCooldown(bloodthirst) > 0 or EnrageRemaining() > SpellCooldown(bloodthirst) } Spell(battle_cry)
    #use_item,name=faulty_countermeasure,if=!equipped.umbral_moonglaives&buff.battle_cry.up&buff.enrage.up
    if not HasEquippedItem(umbral_moonglaives) and BuffPresent(battle_cry_buff) and IsEnraged() FuryUseItemActions()

    unless { BuffPresent(dragon_roar_buff) or not Talent(dragon_roar_talent) and BuffPresent(battle_cry_buff) } and Spell(bloodbath)
    {
     #blood_fury,if=buff.battle_cry.up
     if BuffPresent(battle_cry_buff) Spell(blood_fury_ap)
     #berserking,if=buff.battle_cry.up
     if BuffPresent(battle_cry_buff) Spell(berserking)
     #arcane_torrent,if=rage<rage.max-40
     if Rage() < MaxRage() - 40 Spell(arcane_torrent_rage)
     #run_action_list,name=cooldowns,if=buff.battle_cry.up&spell_targets.whirlwind=1
     if BuffPresent(battle_cry_buff) and Enemies() == 1 FuryCooldownsCdActions()

     unless BuffPresent(battle_cry_buff) and Enemies() == 1 and FuryCooldownsCdPostConditions()
     {
      #call_action_list,name=three_targets,if=target.health.pct>20&(spell_targets.whirlwind=3|spell_targets.whirlwind=4)
      if target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } FuryThreetargetsCdActions()

      unless target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } and FuryThreetargetsCdPostConditions()
      {
       #call_action_list,name=aoe,if=spell_targets.whirlwind>4
       if Enemies() > 4 FuryAoeCdActions()

       unless Enemies() > 4 and FuryAoeCdPostConditions()
       {
        #run_action_list,name=execute,if=target.health.pct<20
        if target.HealthPercent() < 20 FuryExecuteCdActions()

        unless target.HealthPercent() < 20 and FuryExecuteCdPostConditions()
        {
         #run_action_list,name=single_target,if=target.health.pct>20
         if target.HealthPercent() > 20 FurySingletargetCdActions()
        }
       }
      }
     }
    }
   }
  }
 }
}

AddFunction FuryDefaultCdPostConditions
{
 CheckBoxOn(opt_melee_range) and target.InRange(charge) and Spell(charge) or target.Distance() > 5 and FuryMovementCdPostConditions() or { target.Distance() > 25 and 600 > 45 or not False(raid_event_movement_exists) } and CheckBoxOn(opt_melee_range) and target.Distance(atLeast 8) and target.Distance(atMost 40) and Spell(heroic_leap) or { HasEquippedItem(convergence_of_fates) and SpellCooldown(battle_cry) < 2 or not HasEquippedItem(convergence_of_fates) and { not SpellCooldown(battle_cry) <= 10 or SpellCooldown(battle_cry) < 2 } } and Spell(dragon_roar) or SpellCooldown(battle_cry) < 4 and target.HealthPercent() > 20 and Spell(rampage) or HasEquippedItem(kazzalax_fujiedas_fury) and BuffExpires(fujiedas_fury_buff) and Spell(bloodthirst) or { BuffPresent(dragon_roar_buff) or not Talent(dragon_roar_talent) and BuffPresent(battle_cry_buff) } and Spell(bloodbath) or BuffPresent(battle_cry_buff) and Enemies() == 1 and FuryCooldownsCdPostConditions() or target.HealthPercent() > 20 and { Enemies() == 3 or Enemies() == 4 } and FuryThreetargetsCdPostConditions() or Enemies() > 4 and FuryAoeCdPostConditions() or target.HealthPercent() < 20 and FuryExecuteCdPostConditions() or target.HealthPercent() > 20 and FurySingletargetCdPostConditions()
}

### Fury icons.

AddCheckBox(opt_warrior_fury_aoe L(AOE) default specialization=fury)

AddIcon checkbox=!opt_warrior_fury_aoe enemies=1 help=shortcd specialization=fury
{
 if not InCombat() FuryPrecombatShortCdActions()
 unless not InCombat() and FuryPrecombatShortCdPostConditions()
 {
  FuryDefaultShortCdActions()
 }
}

AddIcon checkbox=opt_warrior_fury_aoe help=shortcd specialization=fury
{
 if not InCombat() FuryPrecombatShortCdActions()
 unless not InCombat() and FuryPrecombatShortCdPostConditions()
 {
  FuryDefaultShortCdActions()
 }
}

AddIcon enemies=1 help=main specialization=fury
{
 if not InCombat() FuryPrecombatMainActions()
 unless not InCombat() and FuryPrecombatMainPostConditions()
 {
  FuryDefaultMainActions()
 }
}

AddIcon checkbox=opt_warrior_fury_aoe help=aoe specialization=fury
{
 if not InCombat() FuryPrecombatMainActions()
 unless not InCombat() and FuryPrecombatMainPostConditions()
 {
  FuryDefaultMainActions()
 }
}

AddIcon checkbox=!opt_warrior_fury_aoe enemies=1 help=cd specialization=fury
{
 if not InCombat() FuryPrecombatCdActions()
 unless not InCombat() and FuryPrecombatCdPostConditions()
 {
  FuryDefaultCdActions()
 }
}

AddIcon checkbox=opt_warrior_fury_aoe help=cd specialization=fury
{
 if not InCombat() FuryPrecombatCdActions()
 unless not InCombat() and FuryPrecombatCdPostConditions()
 {
  FuryDefaultCdActions()
 }
}

### Required symbols
# execute
# stone_heart_buff
# rampage
# meat_cleaver_buff
# frothing_berserker_talent
# massacre_buff
# raging_blow
# inner_rage_talent
# bloodthirst
# whirlwind
# fujiedas_fury_buff
# furious_slash
# frenzy_talent
# frenzy_buff
# wrecking_ball_buff
# old_war_potion
# heroic_leap
# juggernaut
# juggernaut_buff
# battle_cry
# odyns_fury
# massacre_talent
# draught_of_souls
# reckless_abandon_talent
# berserker_rage
# outburst_talent
# battle_cry_buff
# bladestorm_fury
# charge
# avatar_buff
# avatar_talent
# dragon_roar
# convergence_of_fates
# kazzalax_fujiedas_fury
# avatar
# umbral_moonglaives
# umbral_glaive_storm
# bladestorm_talent
# dragon_roar_buff
# bloodbath
# dragon_roar_talent
# blood_fury_ap
# berserking
# arcane_torrent_rage
# pummel
]]
    OvaleScripts:RegisterScript("WARRIOR", "fury", name, desc, code, "script")
end
do
    local name = "sc_warrior_protection_t19"
    local desc = "[7.0] Simulationcraft: Warrior_Protection_T19"
    local code = [[
# Based on SimulationCraft profile "Warrior_Protection_T19P".
#	class=warrior
#	spec=protection
#	talents=1222312

Include(ovale_common)
Include(ovale_trinkets_mop)
Include(ovale_trinkets_wod)
Include(ovale_warrior_spells)

AddCheckBox(opt_melee_range L(not_in_melee_range) specialization=protection)
AddCheckBox(opt_use_consumables L(opt_use_consumables) default specialization=protection)

AddFunction ProtectionGetInMeleeRange
{
 if CheckBoxOn(opt_melee_range) and not InFlightToTarget(intercept) and not InFlightToTarget(heroic_leap)
 {
  if target.InRange(intercept) Spell(intercept)
  if SpellCharges(intercept) == 0 and target.Distance(atLeast 8) and target.Distance(atMost 40) Spell(heroic_leap)
  if not target.InRange(pummel) Texture(misc_arrowlup help=L(not_in_melee_range))
 }
}

### actions.prot

AddFunction ProtectionProtMainActions
{
 #shield_block,if=cooldown.shield_slam.remains=0
 if not SpellCooldown(shield_slam) > 0 Spell(shield_block)
 #ignore_pain,if=(!talent.vengeance.enabled&buff.renewed_fury.remains<1.5)|(!talent.vengeance.enabled&rage.deficit>=40)|(buff.vengeance_ignore_pain.up)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_revenge.up&rage<30&!buff.revenge.react)
 if not Talent(vengeance_talent) and BuffRemaining(renewed_fury_buff) < 1 or not Talent(vengeance_talent) and RageDeficit() >= 40 or BuffPresent(vengeance_ignore_pain_buff) or Talent(vengeance_talent) and not BuffPresent(vengeance_ignore_pain_buff) and not BuffPresent(vengeance_revenge_buff) and Rage() < 30 and not BuffPresent(revenge_buff) Spell(ignore_pain)
 #shield_slam
 Spell(shield_slam)
 #revenge,if=(!talent.vengeance.enabled)|(talent.vengeance.enabled&buff.revenge.react&!buff.vengeance_ignore_pain.up)|(buff.vengeance_revenge.up)|(talent.vengeance.enabled&!buff.vengeance_ignore_pain.up&!buff.vengeance_revenge.up&rage>=30)
 if not Talent(vengeance_talent) or Talent(vengeance_talent) and BuffPresent(revenge_buff) and not BuffPresent(vengeance_ignore_pain_buff) or BuffPresent(vengeance_revenge_buff) or Talent(vengeance_talent) and not BuffPresent(vengeance_ignore_pain_buff) and not BuffPresent(vengeance_revenge_buff) and Rage() >= 30 Spell(revenge)
 #thunder_clap
 Spell(thunder_clap)
 #devastate
 Spell(devastate)
}

AddFunction ProtectionProtMainPostConditions
{
}

AddFunction ProtectionProtShortCdActions
{
 #demoralizing_shout
 Spell(demoralizing_shout)
 #ravager,if=talent.ravager.enabled
 if Talent(ravager_talent) Spell(ravager)
}

AddFunction ProtectionProtShortCdPostConditions
{
 not SpellCooldown(shield_slam) > 0 and Spell(shield_block) or { not Talent(vengeance_talent) and BuffRemaining(renewed_fury_buff) < 1 or not Talent(vengeance_talent) and RageDeficit() >= 40 or BuffPresent(vengeance_ignore_pain_buff) or Talent(vengeance_talent) and not BuffPresent(vengeance_ignore_pain_buff) and not BuffPresent(vengeance_revenge_buff) and Rage() < 30 and not BuffPresent(revenge_buff) } and Spell(ignore_pain) or Spell(shield_slam) or { not Talent(vengeance_talent) or Talent(vengeance_talent) and BuffPresent(revenge_buff) and not BuffPresent(vengeance_ignore_pain_buff) or BuffPresent(vengeance_revenge_buff) or Talent(vengeance_talent) and not BuffPresent(vengeance_ignore_pain_buff) and not BuffPresent(vengeance_revenge_buff) and Rage() >= 30 } and Spell(revenge) or Spell(thunder_clap) or Spell(devastate)
}

AddFunction ProtectionProtCdActions
{
 #potion,name=old_war,if=target.time_to_die<25
 if target.TimeToDie() < 25 and CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(old_war_potion usable=1)
 #battle_cry,if=cooldown.shield_slam.remains=0
 if not SpellCooldown(shield_slam) > 0 Spell(battle_cry)
}

AddFunction ProtectionProtCdPostConditions
{
 Spell(demoralizing_shout) or Talent(ravager_talent) and Spell(ravager) or not SpellCooldown(shield_slam) > 0 and Spell(shield_block) or { not Talent(vengeance_talent) and BuffRemaining(renewed_fury_buff) < 1 or not Talent(vengeance_talent) and RageDeficit() >= 40 or BuffPresent(vengeance_ignore_pain_buff) or Talent(vengeance_talent) and not BuffPresent(vengeance_ignore_pain_buff) and not BuffPresent(vengeance_revenge_buff) and Rage() < 30 and not BuffPresent(revenge_buff) } and Spell(ignore_pain) or Spell(shield_slam) or { not Talent(vengeance_talent) or Talent(vengeance_talent) and BuffPresent(revenge_buff) and not BuffPresent(vengeance_ignore_pain_buff) or BuffPresent(vengeance_revenge_buff) or Talent(vengeance_talent) and not BuffPresent(vengeance_ignore_pain_buff) and not BuffPresent(vengeance_revenge_buff) and Rage() >= 30 } and Spell(revenge) or Spell(thunder_clap) or Spell(devastate)
}

### actions.precombat

AddFunction ProtectionPrecombatMainActions
{
}

AddFunction ProtectionPrecombatMainPostConditions
{
}

AddFunction ProtectionPrecombatShortCdActions
{
}

AddFunction ProtectionPrecombatShortCdPostConditions
{
}

AddFunction ProtectionPrecombatCdActions
{
 #flask,type=countless_armies
 #food,type=lavish_suramar_feast
 #augmentation,type=defiled
 #snapshot_stats
 #potion,name=old_war
 if CheckBoxOn(opt_use_consumables) and target.Classification(worldboss) Item(old_war_potion usable=1)
}

AddFunction ProtectionPrecombatCdPostConditions
{
}

### actions.default

AddFunction ProtectionDefaultMainActions
{
 #call_action_list,name=prot
 ProtectionProtMainActions()
}

AddFunction ProtectionDefaultMainPostConditions
{
 ProtectionProtMainPostConditions()
}

AddFunction ProtectionDefaultShortCdActions
{
 #auto_attack
 ProtectionGetInMeleeRange()

 unless Spell(intercept)
 {
  #call_action_list,name=prot
  ProtectionProtShortCdActions()
 }
}

AddFunction ProtectionDefaultShortCdPostConditions
{
 Spell(intercept) or ProtectionProtShortCdPostConditions()
}

AddFunction ProtectionDefaultCdActions
{
 unless Spell(intercept)
 {
  #blood_fury
  Spell(blood_fury_ap)
  #berserking
  Spell(berserking)
  #arcane_torrent
  Spell(arcane_torrent_rage)
  #call_action_list,name=prot
  ProtectionProtCdActions()
 }
}

AddFunction ProtectionDefaultCdPostConditions
{
 Spell(intercept) or ProtectionProtCdPostConditions()
}

### Protection icons.

AddCheckBox(opt_warrior_protection_aoe L(AOE) default specialization=protection)

AddIcon checkbox=!opt_warrior_protection_aoe enemies=1 help=shortcd specialization=protection
{
 if not InCombat() ProtectionPrecombatShortCdActions()
 unless not InCombat() and ProtectionPrecombatShortCdPostConditions()
 {
  ProtectionDefaultShortCdActions()
 }
}

AddIcon checkbox=opt_warrior_protection_aoe help=shortcd specialization=protection
{
 if not InCombat() ProtectionPrecombatShortCdActions()
 unless not InCombat() and ProtectionPrecombatShortCdPostConditions()
 {
  ProtectionDefaultShortCdActions()
 }
}

AddIcon enemies=1 help=main specialization=protection
{
 if not InCombat() ProtectionPrecombatMainActions()
 unless not InCombat() and ProtectionPrecombatMainPostConditions()
 {
  ProtectionDefaultMainActions()
 }
}

AddIcon checkbox=opt_warrior_protection_aoe help=aoe specialization=protection
{
 if not InCombat() ProtectionPrecombatMainActions()
 unless not InCombat() and ProtectionPrecombatMainPostConditions()
 {
  ProtectionDefaultMainActions()
 }
}

AddIcon checkbox=!opt_warrior_protection_aoe enemies=1 help=cd specialization=protection
{
 if not InCombat() ProtectionPrecombatCdActions()
 unless not InCombat() and ProtectionPrecombatCdPostConditions()
 {
  ProtectionDefaultCdActions()
 }
}

AddIcon checkbox=opt_warrior_protection_aoe help=cd specialization=protection
{
 if not InCombat() ProtectionPrecombatCdActions()
 unless not InCombat() and ProtectionPrecombatCdPostConditions()
 {
  ProtectionDefaultCdActions()
 }
}

### Required symbols
# old_war_potion
# battle_cry
# shield_slam
# demoralizing_shout
# ravager
# ravager_talent
# shield_block
# ignore_pain
# vengeance_talent
# renewed_fury_buff
# vengeance_ignore_pain_buff
# vengeance_revenge_buff
# revenge_buff
# revenge
# thunder_clap
# devastate
# intercept
# blood_fury_ap
# berserking
# arcane_torrent_rage
# heroic_leap
# pummel
]]
    OvaleScripts:RegisterScript("WARRIOR", "protection", name, desc, code, "script")
end
