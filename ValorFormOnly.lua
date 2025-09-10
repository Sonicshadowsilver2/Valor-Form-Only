local GameVersion = 0
local canExecute = false

function _OnInit()
  GameVersion = 0
end

function GetVersion() --Define anchor addresses
  if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
    if ReadString(0x09A92F0,4) == 'KH2J' then --EGS
			GameVersion = 2
			print('EGS v1.0.0.9 Detected - ValorFormOnly')
			Now  = 0x0716DF8
			Save = 0x09A92F0
			UCM = 0x2A71998
			Obj0Pointer = 0x2A24A70
			Obj0 = ReadLong(Obj0Pointer)
			canExecute = true
		elseif ReadString(0x09A9330,4) == 'KH2J' then --EGS v1.0.0.10
			GameVersion = 3
			print('EGS v1.0.0.10 Detected - ValorFormOnly')
			Now  = 0x0716DF8
			Save = 0x09A9330
			UCM = 0x2A719D8
			Obj0Pointer = 0x2A24AB0
			Obj0 = ReadLong(Obj0Pointer)
			canExecute = true
		elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global v1.0.0.1
			GameVersion = 4
			print('Steam GL v1.0.0.1 Detected - ValorFormOnly')
			Now  = 0x0717008
			Save = 0x09A9830
			UCM = 0x2A71ED8
			Obj0 = 0x2A24FB0
			canExecute = true
		elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP v1.0.0.1
			GameVersion = 5
			print('Steam JP v1.0.0.1 Detected - ValorFormOnly')
			Now  = 0x0716008
			Save = 0x09A8830
			UCM = 0x2A70ED8
			Obj0 = 0x2A23FB0
			canExecute = true
		elseif ReadString(0x09A98B0,4) == 'KH2J' then --Steam v1.0.0.2
			GameVersion = 6
			print('Steam v1.0.0.2 Detected - ValorFormOnly')
			Now  = 0x0717008
			Save = 0x09A98B0
			UCM = 0x2A71F58
			Obj0 = 0x2A25030
			canExecute = true
		end
	end
end

function _OnFrame()
	if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end
	
	if canExecute == true then
		if ReadShort(Now+0x00) == 0x0102 and ReadByte(Now+0x08) == 0x34 then --New Game
			WriteByte(Save+0x1CD9, 0x02) --Enable Square Button actions
			WriteByte(Save+0x1CE5, 0x04) --Show Form Gauge
		end
		if ReadByte(Now+0x00) == 0x02 then --Twilight Town
			if ReadByte(Now+0x01) == 0x22 then --Twilight Thorn
				WriteShort(UCM+0x009C, 0x0323) --Roxas -> Roxas (Dual-Wielded)
			else
				WriteShort(UCM+0x009C, 0x0055) --Roxas -> Valor
			end
		end
		if ReadByte(Now+0x00) == 0x0A then --Pride Lands
			if ReadByte(Now+0x01) == 0x0F then --Groundshaker
				WriteShort(UCM+0x06E8, 0x028A) --Valor Form -> Lion Sora
			else
				WriteShort(UCM+0x06E8, 0x0055) --Lion Sora -> Valor Form
			end
		end
		if ReadByte(UCM+0x00) == 0x54 then
			WriteShort(UCM+0x0000, 0x0055) --Sora (Normal)
			WriteShort(UCM+0x00D0, 0x0055) --Roxas (Dual-Wielded)
			WriteShort(UCM+0x0104, 0x0055) --Sora (KH1 Costume)
			WriteShort(UCM+0x0444, 0x03E6) --Sora (Halloween Town)
			WriteShort(UCM+0x0478, 0x0956) --Sora (Christmas Town)
			WriteShort(UCM+0x0680, 0x0669) --Sora (Space Paranoids)
			WriteShort(UCM+0x06B4, 0x066A) --Sora (Timeless River)
			WriteString(Obj0+0x154D0,'F_TT010_SORA.mset\0') --Skateboard (Roxas)
		end
	end
end