local Lobby = luiglobals.Lobby
local SystemLinkJoinMenu = LUI.mp_menus.SystemLinkJoinMenu

if (not SystemLinkJoinMenu) then
	return
end

game:addlocalizedstring("MENU_NUMPLAYERS", "Players")
game:addlocalizedstring("MENU_PING", "Ping")
game:addlocalizedstring("SERVERLIST_PLAYER_COUNT", "&&1 Players")
game:addlocalizedstring("SERVERLIST_SERVER_COUNT", "&&1 Servers")

game:addlocalizedstring("SERVERLIST_ADD_TO_FAVOURITES", "Add to favourites")
game:addlocalizedstring("SERVERLIST_ADD_TO_BLACKLIST", "Add to blacklist")
game:addlocalizedstring("SERVERLIST_REMOVE_FROM_FAVOURITES", "Remove from favourites")
game:addlocalizedstring("SERVERLIST_REMOVE_FROM_BLACKLIST", "Remove frome blacklist")

game:addlocalizedstring("LUI_MENU_BLACKLIST", "Blacklist")
game:addlocalizedstring("LUI_MENU_PUBLIC", "Public")
game:addlocalizedstring("LUI_MENU_FAVOURITES", "Favourites")
game:addlocalizedstring("LUI_MENU_SETTINGS", "Settings")

game:addlocalizedstring("LUA_MENU_SERVERTYPE", "TYPE")
game:addlocalizedstring("LUA_MENU_SERVERTYPE_DESC", "Type of server to show on the server list")


local columns = {
	{
		offset = 40,
		text = "@MENU_HOST_NAME",
		dataindex = 0
	},
	{
		offset = 500,
		text = "@MENU_MAP",
		dataindex = 1
	},
	{
		offset = 700,
		text = "@MENU_TYPE1",
		dataindex = 3
	},
	{
		offset = 900,
		text = "@MENU_NUMPLAYERS",
		dataindex = 2
	},
	{
		offset = 1050,
		text = "@MENU_PING",
		dataindex = 4
	},
	{
		offset = 10,
		image = "s1_icon_locked",
		customelement = function(value, offset)
			return LUI.UIImage.new({
				leftAnchor = true,
				topAnchor = true,
				height = 20,
				width = 20,
				left = offset,
				top = 2,
				material = RegisterMaterial(CoD.Material.RestrictedIcon),
				alpha = value == "1" and 1 or 0,
				color = {
					r = 1,
					b = 1,
					g = 1
				}
			})
		end,
		dataindex = 5
	},
	{
		offset = 1100,
		image = CoD.Material.Star,
		customelement = function(value, offset)
			return LUI.UIImage.new({
				leftAnchor = true,
				topAnchor = true,
				height = 20,
				width = 20,
				left = offset,
				top = 2,
				material = RegisterMaterial(CoD.Material.Star),
				alpha = lines_as_hashmap("players2/favourites.txt")[value] ~= nil and 0.9 or 0,
				color = {
					r = 1,
					b = 1,
					g = 1
				}
			})
		end,
		dataindex = 6
	}
}

function textlength(text, font, height)
	local _, _, width = luiglobals.GetTextDimensions(text, font, height)
	return width
end

function trimtext(text, font, height, maxwidth)
	if (maxwidth < 0) then
		return text
	end

	while (textlength(text, font, height) > maxwidth) do
		text = text:sub(1, #text - 1)
	end

	return text
end

SystemLinkJoinMenu.AddHeaderButton = function(menu, f12_arg1, width)
	local state = CoD.CreateState(0, f12_arg1, nil, nil, CoD.AnchorTypes.TopLeft)
	state.width = width
	local element = LUI.UIElement.new(state)
	local button = SystemLinkJoinMenu.CreateButton("header", 24)
	menu.header = button

	button:addElement(LUI.Divider.new(CoD.CreateState(nil, 0, nil, nil, CoD.AnchorTypes.TopLeftRight), 40,
	LUI.Divider.Grey))
	button:makeNotFocusable()
	button:addElement(LUI.Divider.new(CoD.CreateState(nil, 0, nil, nil, CoD.AnchorTypes.BottomLeftRight), 40,
		LUI.Divider.Grey))

	button.m_eventHandlers = {}

	for i = 1, #columns do
		if (columns[i].text) then
			local el = SystemLinkJoinMenu.MakeText(button.textHolder, columns[i].offset, Engine.Localize(columns[i].text), nil)
		elseif (columns[i].image) then
			local image = LUI.UIImage.new({
				leftAnchor = true,
				topAnchor = true,
				height = 20,
				width = 20,
				top = 2,
				left = columns[i].offset,
				material = RegisterMaterial(columns[i].image)
			})
			button.textHolder:addElement(image)
		end
	end

	element:addElement(button)
	menu:addElement(element)
end

SystemLinkJoinMenu.AddServerButton = function(menu, controller, index)

	local button = SystemLinkJoinMenu.CreateButton(index or "header", 23)
	button:makeFocusable()
	button.index = index

	button:addEventHandler("button_action", SystemLinkJoinMenu.OnJoinGame)

	button:addEventHandler("button_left", function (button, menu)
		local type = Engine.GetDvarString("ui_server_type")
		local controller = menu.controller
		if not button then
			controller = Engine.GetFirstActiveController()
		end
		local address = Lobby.GetServerData(controller, button.index, 6)
		if type == "public" then
			local slist = lines_as_hashmap("players2/blacklisted.txt")
			if slist[address] == nil then
				local file = io.open("players2/blacklisted.txt", "a")
				file:write(address .. "\n")
				file:close()
				Engine.PlaySound( CoD.SFX.PopupAppears )
				Lobby.RefreshServerList( controller )
			else
				Engine.PlaySound( CoD.SFX.DenySelect )
			end
		elseif type == "favourites" then
			local servers = ""
			for line in io.lines("players2/favourites.txt") do
				if line ~= address then
					servers = servers .. line .. "\n"
				end
			end
			local file = io.open("players2/favourites.txt", "w")
			file:write(servers .. "\n")
			file:close()

			Lobby.RefreshServerList( controller )
			Engine.PlaySound( CoD.SFX.H1TabChange )
		end
	end)

	button:addEventHandler("button_right", function (button, menu)
		local type = Engine.GetDvarString("ui_server_type")
		local controller = menu.controller
		if not button then
			controller = Engine.GetFirstActiveController()
		end

		local address = Lobby.GetServerData(controller, button.index, 6)
		if type == "public" then
			local slist = lines_as_hashmap("players2/favourites.txt")
			if slist[address] == nil then
				local file = io.open("players2/favourites.txt", "a")
				file:write(address .. "\n")
				file:close()
				Engine.PlaySound( CoD.SFX.PopupAppears )
				Lobby.RefreshServerList( controller )
			else
				Engine.PlaySound( CoD.SFX.DenySelect )
			end
		elseif type == "blacklisted" then
			local servers = ""
			for line in io.lines("players2/blacklisted.txt") do
				if line ~= address then
					servers = servers .. line .. "\n"
				end
			end
			local file = io.open("players2/blacklisted.txt", "w")
			file:write(servers .. "\n")
			file:close()

			button:close()
			Lobby.RefreshServerList( controller )
			Engine.PlaySound( CoD.SFX.H1TabChange )
		end
	end)

	local gettext = function(i)
		local text = Lobby.GetServerData(controller, index, columns[i].dataindex)
		if (columns[i].customelement) then
			text = columns[i].customelement(text)
		end

		local islast = not columns[i + 1]
		local end_ = islast and 1130 or columns[i + 1].offset
		local maxlength = end_ - columns[i].offset

		if (maxlength < 0) then
			maxlength = columns[i].offset - end_
		end

		if (not islast) then
			maxlength = maxlength - 50
		end

		return trimtext(text, CoD.TextSettings.TitleFontSmall.Font, 14, maxlength)
	end

	for i = 1, #columns do
		if (columns[i].customelement) then
			local value = Lobby.GetServerData(controller, index, columns[i].dataindex)
			local element = columns[i].customelement(value, columns[i].offset)
			button.textHolder:addElement(element)
		else
			SystemLinkJoinMenu.MakeText(button.textHolder, columns[i].offset, gettext(i), luiglobals.Colors.h1.medium_grey)
		end
	end

	menu.list:addElement(button)
	return button
end

SystemLinkJoinMenu.BuildList = function( menu, controller )

	menu.list:show()
	menu.header:show()

	if menu.addtoblacklist then
		menu.addtoblacklist:close()
	end

	if menu.removefromblacklist then
		menu.removefromblacklist:close()
	end

	if menu.addtofavourites then
		menu.addtofavourites:close()
	end

	if menu.removefromfavourites then
		menu.removefromfavourites:close()
	end

	menu.list:closeChildren()
	local type = Engine.GetDvarString("ui_server_type")
	if type == "favourites" then
		menu.removefromfavourites = menu:AddHelp({
			name = "add_button_helper_text",
			button_ref = "button_left",
			helper_text = Engine.Localize("@SERVERLIST_REMOVE_FROM_FAVOURITES"),
			side = "right",
			clickable = true,
			priority = -1000
		}, nil, nil, true)
		local servers = lines_as_hashmap("players2/favourites.txt")
		for index = 0, menu.serverCount - 1, 1 do
			local ip = Lobby.GetServerData(controller, index, 6)
			if servers[ip] ~= nil then
				SystemLinkJoinMenu.AddServerButton(menu, controller, index)
			end 
		end
	elseif type == "blacklisted" then
		menu.removefromblacklist = menu:AddHelp({
			name = "add_button_helper_text",
			button_ref = "button_right",
			helper_text = Engine.Localize("@SERVERLIST_REMOVE_FROM_BLACKLIST"),
			side = "right",
			clickable = true,
			priority = -1000
		}, nil, nil, true)
		local servers = lines_as_hashmap("players2/blacklisted.txt")
		for index = 0, menu.serverCount - 1, 1 do
			local ip = Lobby.GetServerData(controller, index, 6)
			if servers[ip] ~= nil then
				SystemLinkJoinMenu.AddServerButton(menu, controller, index)
			end 
		end
	elseif type == "local" then
		menu.list:hide()
		menu.header:hide()
		menu.textCounter:hide()
	
	else
		menu.addtofavourites = menu:AddHelp({
			name = "add_button_helper_text",
			button_ref = "button_left",
			helper_text = Engine.Localize("@SERVERLIST_ADD_TO_BLACKLIST"),
			side = "right",
			clickable = true,
			priority = -1000
		}, nil, nil, true)

		menu.addtoblacklist = menu:AddHelp({
			name = "add_button_helper_text",
			button_ref = "button_right",
			helper_text = Engine.Localize("@SERVERLIST_ADD_TO_FAVOURITES"),
			side = "right",
			clickable = true,
			priority = -1000
		}, nil, nil, true)
	
		local servers = lines_as_hashmap("players2/blacklisted.txt")
		for index = 0, menu.serverCount - 1, 1 do
			local ip = Lobby.GetServerData(controller, index, 6)
			if servers[ip] == nil then
				SystemLinkJoinMenu.AddServerButton(menu, controller, index)
			end
		end
	end
	
	if menu.serverCount > 0 then
		menu.list:registerEventHandler( LUI.FormatAnimStateFinishEvent( "default" ), function ( element, event )
			ListPaging.InitList( menu.list, 18, nil, nil, nil, {
				enabled = false
			} )
		end )
		menu.list:animateToState( "default" )
	end
end


SystemLinkJoinMenu.OnJoinGame =  function ( server, menu )
	local ConnectTo = Lobby.JoinServer
	local controller = menu.controller
	if not controller then
		controller = Engine.GetFirstActiveController()
	end
	
	ConnectTo( controller, server.index )
end

SystemLinkJoinMenu.MakeText = function(menu, f5_arg1, text, color)
	local state = CoD.CreateState(f5_arg1, nil, f5_arg1 + 200, nil, CoD.AnchorTypes.Left)
	state.font = CoD.TextSettings.TitleFontSmall.Font
	state.top = -6
	state.height = 14
	state.alignment = nil
	state.glow = LUI.GlowState.None
	state.color = color

	local el = LUI.UIText.new(state)
	el:registerAnimationState("focused", {
		color = luiglobals.Colors.white
	})

	el:registerEventHandler("focused", function(element, event)
		element:animateToState("focused", 1)
	end)

	el:registerEventHandler("unfocused", function(element, event)
		element:animateToState("default", 1)
	end)

	el:setText(text)
	menu:addElement(el)

	return el
end


function menu_systemlink_join(f19_arg0, f19_arg1)
	if not file_exists("players2/favourites.txt") then
		local file = io.open("players2/favourites.txt", "w")
		file:close()
	end

	if not file_exists("players2/blacklisted.txt") then
		local file = io.open("players2/blacklisted.txt", "w")
		file:close()
	end

	Engine.SetDvarFromString("ui_server_type", "public")
	local width = 1145
	local menu = LUI.MenuTemplate.new(f19_arg0, {
		menu_title = "@PLATFORM_SYSTEM_LINK_TITLE",
		menu_width = width,
		menu_top_indent = 44,
		disableDeco = true,
		spacing = 1
	})

	local tabs = LUI.MenuBuilder.BuildRegisteredType( "MFTabManager", {
		defState = {
			leftAnchor = true,
			topAnchor = true,
			rightAnchor = true,
			top = 10
		},
		numOfTabs = 4,
		vPadding = 28,
		forceStringBasedTabWidth = true,
		forceShowTabs = false
	} )

	tabs:keepRightBumperAlignedToHeader( true )
	menu.tabManager = tabs
	tabs.tabContentPane = menu

	local serverTypes = {
		{
			menu = showOnlyBlacklistedServers,
			name = Engine.ToUpperCase( Engine.Localize( "LUI_MENU_BLACKLIST" ) ),
			type = "BLACKLIST"
		},
		{
			menu = showOnlyPublicServers,
			name = Engine.ToUpperCase( Engine.Localize( "LUI_MENU_PUBLIC" ) ),
			type = "PUBLIC"
		},
		{
			menu = showOnlyFavouritesServers,
			name = Engine.Localize( "LUI_MENU_FAVOURITES" ),
			type = "FAVOURITES"
		},
	}

	for i = 1, #serverTypes, 1 do
		tabs:addTab( f19_arg0, serverTypes[i].name, serverTypes[i].menu )
	end

	local tmp = LUI.FlowManager.GetMenuScopedDataFromElement( menu )
	tabs.tabSelected = tmp.paneIndex or 2
	tabs.parentContainer = menu
	tabs:refreshTab( menu )

	menu:addElement( tabs );
	
	SystemLinkJoinMenu.AddHeaderButton(menu, 114, width)
	SystemLinkJoinMenu.AddLowerCounter(menu, width)
	SystemLinkJoinMenu.UpdateCounterText(menu, nil)

	local playercount = LUI.UIText.new({
		rightAnchor = true,
		topAnchor = true,
		height = 18,
		bottom = 58,
		font = CoD.TextSettings.BodyFont.Font,
		width = 300,
		alignment = LUI.Alignment.Right,
	})
	menu:addElement(playercount)

	local servercount = LUI.UIText.new({
		rightAnchor = true,
		topAnchor = true,
		height = 18,
		bottom = 58 - 25,
		font = CoD.TextSettings.BodyFont.Font,
		width = 300,
		alignment = LUI.Alignment.Right,
	})
	menu:addElement(servercount)

	menu.list:registerEventHandler(LUI.UIScrollIndicator.UpdateEvent, function(element, event)
		SystemLinkJoinMenu.UpdateCounterText(menu, event)

		playercount:setText(Engine.Localize("@SERVERLIST_PLAYER_COUNT", serverlist:getplayercount()))
		servercount:setText(Engine.Localize("@SERVERLIST_SERVER_COUNT", serverlist:getservercount()))
	end)

	Lobby.BuildServerList(Engine.GetFirstActiveController())

	SystemLinkJoinMenu.UpdateGameList(menu)
	menu:registerEventHandler("updateGameList", SystemLinkJoinMenu.UpdateGameList)

	LUI.ButtonHelperText.ClearHelperTextObjects(menu.help, {
		side = "all"
	})

	menu:AddHelp({
		name = "add_button_helper_text",
		button_ref = "button_alt1",
		helper_text = Engine.Localize("@MENU_SB_TOOLTIP_BTN_REFRESH"),
		side = "right",
		clickable = true,
		priority = -1000
	}, function(f21_arg0, f21_arg1)
		SystemLinkJoinMenu.RefreshServers(menu, menu, menu)
	end)

	menu:AddHelp({
		name = "add_button_helper_text",
		button_ref = "button_action",
		helper_text = Engine.Localize("@MENU_JOIN_GAME1"),
		side = "left",
		clickable = false,
		priority = -1000
	}, nil, nil, true)


	menu:AddBackButton()
	Lobby.RefreshServerList(Engine.GetFirstActiveController())

	return menu
end

function showOnlyPublicServers()
	Engine.SetDvarFromString("ui_server_type", "public")
	local ui = LUI.UIElement.new({})

	local root = Engine.GetLuiRoot()
	root:processEvent( {
		name = "button_alt1",
		dispatchChildren = true
	} )

	return ui
end

function showOnlyLocalServers()
	Engine.SetDvarFromString("ui_server_type", "local")
	local ui = LUI.UIElement.new({})

	local root = Engine.GetLuiRoot()
	root:processEvent( {
		name = "button_alt1",
		dispatchChildren = true
	} )

	return ui
end

function showOnlyFavouritesServers()
	Engine.SetDvarFromString("ui_server_type", "favourites")
	local ui = LUI.UIElement.new({})

	local root = Engine.GetLuiRoot()
	root:processEvent( {
		name = "button_alt1",
		dispatchChildren = true
	} )

	return ui
end

function showOnlyBlacklistedServers()
	Engine.SetDvarFromString("ui_server_type", "blacklisted")
	local ui = LUI.UIElement.new({})

	local root = Engine.GetLuiRoot()
	root:processEvent( {
		name = "button_alt1",
		dispatchChildren = true
	} )

	return ui
end

LUI.MenuBuilder.m_types_build["menu_systemlink_join"] = menu_systemlink_join

function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end
function lines_as_hashmap(file)
	if not file_exists(file) then return {} end
	local lines = {}
	for line in io.lines(file) do
	  lines[line] = 1
	end
	return lines
end