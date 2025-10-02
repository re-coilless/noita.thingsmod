local old = death
function death(...)
	old(...)
	local count = tonumber(GlobalsGetValue("PERK_PICKED_BOUNTIFUL_HUNTER_PICKUP_COUNT", "0"))
	if count>0 and math.random()<=(-0.985^count+1) then
		print("Win! " .. tostring(-0.985^count+1))
	end
end