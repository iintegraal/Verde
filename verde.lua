if(_G.VERDE) then
	print(Color(0, 66, 0, 255)"verde already running within the game.")
	return false
end

local verde     = table.Copy(_G) || {}
local _Hooks    = {}
verde.ConCMD    = table.Copy(concommand)
verde.me        = LocalPlayer()

verde_esp      = CreateClientConVar("verde_esp", "1", false, false)
verde_bhop      = CreateClientConVar("verde_bhop", "1", false, false)


function verde.Plyvalid(ent)
  if(!IsValid(ent) || ent == verde.me || !ent:Alive() || ent:Health() < 1 || ent:Name() == nil  || ent:IsRagdoll() || ent:Team() == TEAM_SPECTATOR) then
    return false
  else
    return true
  end
end

function verde.AddHook(event_name, func)
	local name = verde.RandomString()

	hook.Add(event_name, name, func)

	if(!_Hooks[event_name]) then
		_Hooks[event_name] = {}
	end

	_Hooks[event_name][name] = func
end



function verde.Bhop(ucmd)
if(verde_bhop:GetBool()) then
  if(ucmd:KeyDown(2) && !verde.me:IsOnGround()) then
		if(verde.me:GetMoveType() == MOVETYPE_NOCLIP || verde.me:WaterLevel() >= 2) then return end

    	ucmd:SetButtons(bit.band(ucmd:GetButtons(), bit.bnot(2)))

    end
  end
end


function verde.Esp(ply)
	if(verde_esp:GetBool()) then
		if(verde.Plyvalid(ply)) then

		local c = (ply:GetPos() + Vector(0,0,0)):ToScreen()
		draw.SimpleTextOutlined(ply:Name(), "BudgetLabel", c.x, c.y, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0))
		draw.SimpleTextOutlined(ply:Health().."%", "BudgetLabel", c.x, c.y + 11, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0))
		draw.SimpleTextOutlined(math.Round(ply:GetPos():Distance(verde.me:GetShootPos())/52.52,2), "BudgetLabel", c.x, c.y + 21, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0, Color(0,0,0))

		end
	end
end

verde.AddHook("CreateMove", function(ucmd)

	verde.Bhop(ucmd)

end )

verde.ConCMD['Add']("verde_unload", function()

	for k, v in next, _Hooks do
		for _k, _v in pairs(v) do
			hook.Remove(k, _k)
		end
	end

	_G.VERDE = nil
	print(Color(255, 0, 0, 255)"verde unloaded")

	_G.VERDE = true
print(Color(0, 66, 0, 255)"verde initialised")

end )
