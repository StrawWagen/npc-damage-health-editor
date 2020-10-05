local npcWeights = {
	["npc_zombie"] = 100,
	["npc_fastzombie"] = 95,
	["npc_poisonzombie"] = 115,
	["npc_zombie_torso"] = 40,
	["npc_fastzombie_torso"] = 40,
	["npc_headcrab_fast"] = 4.5,
	["npc_headcrab"] = 5,
	["npc_headcrab_black"] = 5,
	["npc_barnacle"] = 500,
	["npc_zombine"] = 100,
	
	
	["npc_antlion"] = 115,
	["npc_antlion_worker"] = 115,
	["npc_antlionguard"] = 1000,
	["npc_antlionguardian"] = 1000,
	
	
	["npc_metropolice"] = 90,
	["npc_combine_s"] = 100,
	["npc_stalker"] = 70,
	["npc_hunter"] = 1000,
	
	["npc_turret_floor"] = 100,
	["npc_manhack"] = 3.69,
	["npc_rollermine"] = 50,
	["npc_cscanner"] = 9,
	["npc_clawscanner"] = 68.13,
	["npc_helicopter"] = 2400,
	
	
	["npc_crow"] = 1.5,
	["npc_pigeon"] = 2,
	["npc_seagull"] = 1.5,
	
	
	["npc_monk"] = 90,
	["npc_alyx"] = 60,
	["npc_barney"] = 90,
	["npc_citizen"] = 80,
	["npc_dog"] = 260,
	["npc_magnusson"] = 90,
	["npc_kleiner"] = 90,
	["npc_mossman"] = 70,
	["npc_eli"] = 90,
	["npc_fisherman"] = 1,
	["npc_gman"] = 90,
	["npc_odessa"] = 90,
	["npc_vortigaunt"] = 81,
	["npc_breen"] = 90,
}

local function buffNPC( ent )
	if IsValid( ent ) and ent:IsNPC() and npcWeights[ent:GetClass()] then
		timer.Simple( 0, function()
			if IsValid( ent ) and ent:IsNPC() then
				local baseWeight = npcWeights[ent:GetClass()]
				local hpMul = math.Round(ent:GetPhysicsObject():GetMass() / baseWeight, 3) 
				local baseHP = ent:Health()
				ent:SetHealth( baseHP * hpMul )
				ent:SetMaxHealth( baseHP * hpMul )
				
				if IsValid( ent:CPPIGetOwner() ) and ent:IsNPC() and math.Round(hpMul, 1) != 1 then
					if ent:CPPIGetOwner():IsLineOfSightClear( ent ) then
						ent:CPPIGetOwner():ChatPrint( ent:GetClass() .. "'s HP multiplied by " .. math.Round(hpMul, 1) )
					end
				end
			end
		end )
	end
end

hook.Remove( "OnEntityCreated", "BuffNPC" )
hook.Add( "OnEntityCreated", "BuffNPC", buffNPC )


local function scaleNPCDamage( target, dmgInfo )
	local attacker = dmgInfo:GetAttacker()
	
	if not IsValid( attacker ) then return end
	if not attacker:IsNPC() then return end
	
	local defWeight = npcWeights[attacker:GetClass()]
	if not defWeight then return end
	
	local phys = attacker:GetPhysicsObject()
	if not phys then return end
	
	local dmgMul = math.Round( phys:GetMass() / defWeight, 1 )
	dmgInfo:ScaleDamage( dmgMul )
end



hook.Remove( "EntityTakeDamage", "ScaleNPCDamage" )
hook.Add( "EntityTakeDamage", "ScaleNPCDamage", scaleNPCDamage )
