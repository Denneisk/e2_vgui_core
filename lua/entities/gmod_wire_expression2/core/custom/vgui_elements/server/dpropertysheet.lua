E2VguiCore.RegisterVguiElementType("dpropertysheet.lua",true)

local function isValidDPropertySheet(panel)
	if !istable(panel) then return false end
	if table.Count(panel) != 3 then return false end
	if panel["players"] == nil then return false end
	if panel["paneldata"] == nil then return false end
	if panel["changes"] == nil then return false end
	return true
end

//register this default table creation function so we can use it anywhere
E2VguiCore.AddDefaultPanelTable("dpropertysheet",function(uniqueID,parentPnlID)
	local tbl = {
		["uniqueID"] = uniqueID,
		["parentID"] = parentPnlID,
		["typeID"] = "dpropertysheet",
		["posX"] = 0,
		["posY"] = 0,
		["width"] = 50,
		["height"] = 30,
		["visible"] = true,
		["tabs"] = {},
		["activeTab"] = nil,
		["color"] = nil //set no default color to use the default skin
	}
	return tbl
end)
--6th argument type checker without return,
--7th arguement type checker with return. False for valid type and True for invalid
registerType("dpropertysheet", "xdo", {["players"] = {}, ["paneldata"] = {},["changes"] = {}},
	nil,
	nil,
	function(retval)
		if !istable(retval) then error("Return value is not a table, but a "..type(retval).."!",0) end
		if #retval ~= 3 then error("Return value does not have exactly 3 entries!",0) end
	end,
	function(v)
		return !isValidDPropertySheet(v)
	end
)

E2VguiCore.RegisterTypeWithID("dpropertysheet","xdo")

--[[------------------------------------------------------------
						E2 Functions
------------------------------------------------------------]]--

--- B = B
registerOperator("ass", "xdo", "xdo", function(self, args)
    local op1, op2, scope = args[2], args[3], args[4]
    local      rv2 = op2[1](self, op2)
    self.Scopes[scope][op1] = rv2
    self.Scopes[scope].vclk[op1] = true
    return rv2
end)

--TODO: Check if the entire pnl data is valid
-- if (B)
e2function number operator_is(xdo pnldata)
	return isValidDPropertySheet(pnldata) and  1 or 0
end

-- if (!B)
e2function number operator!(xdo pnldata)
	return isValidDPropertySheet(pnldata) and  0 or 1
end

--- B == B --check if the names match
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator==(xdo ldata, xdo rdata)
	if !isValidDPropertySheet(ldata) then return 0 end
	if !isValidDPropertySheet(rdata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 1 or 0
end

--- B == number --check if the uniqueID matches
e2function number operator==(xdo ldata, n index)
	if !isValidDPropertySheet(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 1 or 0
end

--- number == B --check if the uniqueID matches
e2function number operator==(n index,xdo rdata)
	if !isValidDPropertySheet(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 1 or 0
end


--- B != B
--TODO: Check if the entire pnl data is equal (each attribute of the panel)
e2function number operator!=(xdo ldata, xdo rdata)
	if !isValidDPropertySheet(ldata) then return 1 end
	if !isValidDPropertySheet(rdata) then return 1 end
	return ldata["paneldata"]["uniqueID"] == rdata["paneldata"]["uniqueID"] and 0 or 1
end


--- B != number --check if the uniqueID matches
e2function number operator!=(xdo ldata, n index)
	if !isValidDPropertySheet(ldata) then return 0 end
	return ldata["paneldata"]["uniqueID"] == index and 0 or 1
end

--- number != B --check if the uniqueID matches
e2function number operator!=(n index,xdo rdata)
	if !isValidDPropertySheet(rdata) then return 0 end
	return rdata["paneldata"]["uniqueID"] == index and 0 or 1
end

--[[-------------------------------------------------------------------------
	Desc: Creates a dpropertysheet element
	Args:
	Return: dpropertysheet
---------------------------------------------------------------------------]]


e2function dpropertysheet dpropertysheet(number uniqueID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dpropertysheet",uniqueID,nil),
		["changes"] = {}
	}
end

e2function dpropertysheet dpropertysheet(number uniqueID,number parentID)
	local players = {self.player}
	if self.entity.e2_vgui_core_default_players != nil and self.entity.e2_vgui_core_default_players[self.entity:EntIndex()] != nil then
		players = self.entity.e2_vgui_core_default_players[self.entity:EntIndex()]
	end
	return {
		["players"] =  players,
		["paneldata"] = E2VguiCore.GetDefaultPanelTable("dpropertysheet",uniqueID,parentID),
		["changes"] = {}
	}
end

do--[[setter]]--
	e2function void dpropertysheet:setPos(number posX,number posY)
		E2VguiCore.registerAttributeChange(this,"posX", posX)
		E2VguiCore.registerAttributeChange(this,"posY", posY)
	end

	e2function void dpropertysheet:setPos(vector2 pos)
		E2VguiCore.registerAttributeChange(this,"posX", pos[1])
		E2VguiCore.registerAttributeChange(this,"posY", pos[2])
	end

	e2function void dpropertysheet:setSize(number width,number height)
		E2VguiCore.registerAttributeChange(this,"width", width)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dpropertysheet:setSize(vector2 pnlSize)
		E2VguiCore.registerAttributeChange(this,"width", pnlSize[1])
		E2VguiCore.registerAttributeChange(this,"height", pnlSize[2])
	end

	e2function void dpropertysheet:setWidth(number width)
		E2VguiCore.registerAttributeChange(this,"width", width)
	end

	e2function void dpropertysheet:setHeight(number height)
		E2VguiCore.registerAttributeChange(this,"height", height)
	end

	e2function void dpropertysheet:setVisible(number visible)
		local vis = visible > 0
		E2VguiCore.registerAttributeChange(this,"visible", vis)
	end

	e2function void dpropertysheet:dock(number dockType)
		E2VguiCore.registerAttributeChange(this,"dock", dockType)
	end

	e2function void dpropertysheet:addSheet(string name,xdp panel,string icon)
		E2VguiCore.registerAttributeChange(this,"addsheet",{["name"] = name,["panelID"] = panel["paneldata"]["uniqueID"],["icon"] = icon})
	end
-- setter
end

do--[[getter]]--
	e2function vector2 dpropertysheet:getPos()
		return {this["paneldata"]["posX"] or 0,this["paneldata"]["posY"] or 0}
	end

	e2function vector2 dpropertysheet:getSize()
		return {this["paneldata"]["width"] or 0,this["paneldata"]["height"] or 0}
	end

	e2function number dpropertysheet:getWidth()
		return this["paneldata"]["width"] or 0
	end

	e2function number dpropertysheet:getHeight()
		return this["paneldata"]["height"] or 0
	end
	--TODO: look up catch color
	e2function vector dpropertysheet:getColor()
		local col = this["paneldata"]["color"]
		if col == nil then
			return {0,0,0}
		end
		return {col.r,col.g,col.b}
	end

	e2function vector4 dpropertysheet:getColor4()
		local col = this["paneldata"]["color"]
		if col == nil then
			return {100,100,100,255}
		end
		return {col.r,col.g,col.b,col.a}
	end

	e2function string dpropertysheet:getText()
		return this["paneldata"]["text"] or ""
	end

	e2function number dpropertysheet:isVisible()
		return this["paneldata"]["visible"] and 1 or 0
	end
-- getter
end

do--[[utility]]--
	e2function void dpropertysheet:create()
		E2VguiCore.CreatePanel(self,this)
	end

	--TODO: make it update it child panels when the parent is modified ?
	e2function void dpropertysheet:modify()
		E2VguiCore.ModifyPanel(self,this)
	end

	e2function void dpropertysheet:closePlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dpropertysheet:closeAll()
		for _,ply in pairs(this["players"]) do
			E2VguiCore.RemovePanel(self.entity:EntIndex(),this["paneldata"]["uniqueID"],ply)
		end
	end

	e2function void dpropertysheet:addPlayer(entity ply)
		if IsValid(ply) and ply:IsPlayer() then
			//check for redundant players will be done in CreatePanel or ModifyPanel
			//maybe change that ?
			table.insert(this["players"],ply)
		end
	end

	e2function void dpropertysheet:removePlayer(entity ply)
		for k,v in pairs(this["players"]) do
			if ply == v then
				table.remove(this["players"],k)
			end
		end
	end
-- utility
end
