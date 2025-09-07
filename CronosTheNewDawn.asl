	state("Cronos-Win64-Shipping") 
	{
	}

	startup
	{
		Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
		vars.Helper.GameName = "Cronos: The New Dawn";
		vars.Helper.AlertLoadless();

		#region setting creation
		//Autosplitter Settings Creation
		dynamic[,] _settings =
		{
		{ "Chapter Splits", true, "Chapter Splits", null },
			{ "Outbreak_Persistent",         true, "Outbreak",			"Chapter Splits" },
		{"GameInfo", 					true, "Print Various Game Info",						null},
			{"World",                 false, "Current World",                                "GameInfo"},
			{"camTarget",               true, "Current Camera Target",         				"GameInfo"},
			{"playerPos",       true, "playerPos",                      "GameInfo"},
			{"MaxAcceleration",       false, "MaxAcceleration",                      "GameInfo"},
			{"LastItem",               true, "Last item picked up",         				"GameInfo"},
		{"Debug", 					    false, "Print Debug Info",    							null},
			{"placeholder",       true, "placeholder",                      "Debug"},
			{"loadRemovalReady",       false, "loadRemovalReady",                      "Debug"},
			{"movementCheckLoad",       false, "movementCheckLoad",                      "Debug"},
			{"AcknowledgedPawn",       true, "AcknowledgedPawn",                      "Debug"},
		};
		vars.Helper.Settings.Create(_settings);
		#endregion

		#region TextComponent
		vars.lcCache = new Dictionary<string, LiveSplit.UI.Components.ILayoutComponent>();
		vars.SetText = (Action<string, object>)((text1, text2) =>
		{
			const string FileName = "LiveSplit.Text.dll";
			LiveSplit.UI.Components.ILayoutComponent lc;

			if (!vars.lcCache.TryGetValue(text1, out lc))
			{
				lc = timer.Layout.LayoutComponents.Reverse().Cast<dynamic>()
					.FirstOrDefault(llc => llc.Path.EndsWith(FileName) && llc.Component.Settings.Text1 == text1)
					?? LiveSplit.UI.Components.ComponentManager.LoadLayoutComponent(FileName, timer);

				vars.lcCache.Add(text1, lc);
			}

			if (!timer.Layout.LayoutComponents.Contains(lc)) timer.Layout.LayoutComponents.Add(lc);
			dynamic tc = lc.Component;
			tc.Settings.Text1 = text1;
			tc.Settings.Text2 = text2.ToString();
		});
		vars.RemoveText = (Action<string>)(text1 =>
		{
			LiveSplit.UI.Components.ILayoutComponent lc;
			if (vars.lcCache.TryGetValue(text1, out lc))
			{
				timer.Layout.LayoutComponents.Remove(lc);
				vars.lcCache.Remove(text1);
			}
		});
		#endregion

		vars.splitstoComplete = new HashSet<string>();
		vars.CompletedSplits 	 = new HashSet<string>();
		vars.Inventory = new Dictionary<ulong, int>();
	}

	init
	{
        //Unreal Engine 5.05
		IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
		IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
		IntPtr fNamePool = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");
		IntPtr gSyncLoadCount = vars.Helper.ScanRel(5, "89 43 60 8B 05 ?? ?? ?? ??");
		
		if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero || fNamePool == IntPtr.Zero || gSyncLoadCount == IntPtr.Zero)
		{
			const string Msg = "Not all required addresses could be found by scanning.";
			throw new Exception(Msg);
		}

		vars.FNameToString = (Func<ulong, string>)(fName =>
		{
			var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
			var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
			var number = (fName & 0xFFFFFFFF00000000) >> 0x20;

			// IntPtr chunk = vars.Helper.Read<IntPtr>(fNamePool + 0x10 + (int)chunkIdx * 0x8);
			IntPtr chunk = vars.Helper.Read<IntPtr>(fNamePool + 0x10 + (int)chunkIdx * 0x8);
			IntPtr entry = chunk + (int)nameIdx * sizeof(short);

			int length = vars.Helper.Read<short>(entry) >> 6;
			string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

			return number == 0 ? name : name + "_" + number;
		});

		vars.FNameToShortString2 = (Func<ulong, string>)(fName =>
		{
			string name = vars.FNameToString(fName);

			int under = name.LastIndexOf('_');

			return name.Substring(0, under);
		});

		#region Text Component
		vars.SetTextIfEnabled = (Action<string, object>)((text1, text2) =>
		{
			if (settings[text1]) vars.SetText(text1, text2); 
			else vars.RemoveText(text1);
		});
		#endregion

		// GSync
		vars.Helper["GSync"] = vars.Helper.Make<bool>(gSyncLoadCount); 
		// gEngine - GameViewport(BD0) - World(078) - FName 
		vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gEngine, 0xBD0, 0x078, 0x18);
		// gEngine - LevelScriptActorClassName.SubPathString 
		vars.Helper["LevelSubPathName"] = vars.Helper.MakeString(gEngine, 0x2C0);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370)
		vars.Helper["AcknowledgedPawnPtr"] = vars.Helper.Make<IntPtr>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x370);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370)
		vars.Helper["AcknowledgedPawnName"] = vars.Helper.Make<ulong>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x370, 0x18);
		// gEngine -> GameInstance(1210) -> Subsystems(108)
		vars.Helper["Subsystems"] = vars.Helper.Make<IntPtr>(gEngine, 0x1210, 0x108);
		// gEngine -> GameInstance(1210) -> Subsystems(108) - BTGameObjectivesSystem (140)
		vars.Helper["BTGameObjectivesSystem"] = vars.Helper.Make<ulong>(gEngine, 0x1210, 0x108, 0x20, 0x8);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> Character(318) - CapsuleComponent(358) - RelativeLocationX(128)
 		vars.Helper["playerPosX"] = vars.Helper.Make<double>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x358, 0x128);
		vars.Helper["playerPosY"] = vars.Helper.Make<double>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x358, 0x130);
		vars.Helper["playerPosZ"] = vars.Helper.Make<double>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x358, 0x138);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> Character(318) - Movement(6E8) - MaxAcceleration(27C)
 		vars.Helper["MaxAcceleration"] = vars.Helper.Make<float>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x6E8, 0x27C);


		
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> MyHUD(378) -
		vars.Helper["NullLoad"]  = vars.Helper.Make<bool>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x378, 0x1B0);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> PlayerCameraManager(380) -> ViewTarget.Target(360) -> FNameIndex
		vars.Helper["camTargetName"]  = vars.Helper.Make<ulong>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x380, 0x360, 0x18);

		// gEngine.TransitionType
		vars.Helper["Pause"] = vars.Helper.Make<bool>(gEngine, 0xD0C);
		// gEngine - GameInstance - bDeathReload[1]
		vars.Helper["DeathLoad"] = vars.Helper.Make<bool>(gEngine, 0x1210, 0x388);
		
		// gEngine - GameViewport(BD0) - World(078) - AuthorityGameMode(158) - MenuController(368) - StateWidgetsAllocatorInstance(E8) - NameKey(0)
		vars.Helper["StateWidget"] = vars.Helper.Make<ulong>(gEngine, 0xBD0, 0x078, 0x158, 0x368, 0xE8, 0x0);

		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370) - Items(728) - CollectedItemsAllocatorInstance(1D8) - 0x0
		vars.Helper["Items"] = vars.Helper.Make<IntPtr>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x370, 0x728, 0x1D8, 0x0);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370) - Items(728) - CollectedItemsAllocatorInstance(1D8) - 0x0
		vars.Helper["ItemCount"] = vars.Helper.Make<uint>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x370, 0x728, 0x1D8, 0x8);

		
		
		//Incomplete or not useful paths
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> MyHUD(378) - HUDWidget(690) - ObjectivesLogWidget(450) - MainObjectiveContainer(2D0) - Slots(168) - 0 - content(30) - QuestNameTextBlock(2D0), 18
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370) - UIComponent(758) - GameplayFocusWidget(150) - DesiredWidgetName(28C)
		// gEngine -> GameInstance(1210) -> DeathReload (388)
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> MyHUD(378) - HUDWidget(690) - ObjectivesLogWidget(450) - TaskCompletedStatusOverlay(330)
		// gEngine - GameViewport(BD0) - World(078) - LevelsAllocatorInstance(178) - 0 - 18
		// gEngine - GameViewport(BD0) - World(078) - AuthorityGameMode(158) - MenuController(368) - StateWidgetsAllocatorInstance(E8) - NameKey(0)

		current.World = "";
		current.AcknowledgedPawn = "";
		current.camTarget = "";
		current.LocalPlayer = "";
		current.autostartReady = false;
		current.placeholderTest = "";
		current.loadRemovalReady = false;
		current.movementCheckLoad = false;
		current.playerPosXPretty = "";
		current.playerPosYPretty = "";
		current.playerPosZPretty = "";
		current.LastItemText = "";
		current.ItemSetting = "";
		current.loadReady = false;
	}

	update
	{
		vars.Helper.Update();
		vars.Helper.MapPointers();

		var World = vars.FNameToString(current.GWorldName);
		if (!string.IsNullOrEmpty(World) && World != "None")
			current.World = World;
		if (old.World != current.World) vars.Log("World: " + old.World + " -> " + current.World);

		var camTarget = vars.FNameToShortString2(current.camTargetName);
		if (!string.IsNullOrEmpty(camTarget) && camTarget != "None")
			current.camTarget = camTarget;
		if (old.camTarget != current.camTarget)
			vars.Log("camTarget: " + old.camTarget + " -> " + current.camTarget);

		var AcknowledgedPawn = vars.FNameToShortString2(current.AcknowledgedPawnName);
		if (!string.IsNullOrEmpty(AcknowledgedPawn) && AcknowledgedPawn != "None")
			current.AcknowledgedPawn = AcknowledgedPawn;
		if (old.AcknowledgedPawn != current.AcknowledgedPawn)
			vars.Log("AcknowledgedPawn: " + old.AcknowledgedPawn + " -> " + current.AcknowledgedPawn);

		var placeholder = vars.FNameToString(current.StateWidget);
		if (!string.IsNullOrEmpty(placeholder) && placeholder != "None")
			current.placeholderTest = placeholder;
		if (old.placeholderTest != current.placeholderTest)
			vars.Log("placeholderTest: " + old.placeholderTest + " -> " + current.placeholderTest);

		if (current.NullLoad == null || current.World == "Empty")
		{current.loadReady = true;}

		if (current.loadReady == true && old.MaxAcceleration == 2048 && current.MaxAcceleration == 400)
		{current.loadReady = false;}

		#region Item Check
		const string ItemFormat = "[{0}] {1} ({2})";

				for (int i = 0; i < current.ItemCount; i++)
				{
					ulong item   = vars.Helper.Read<ulong>(current.Items + 0xC * i);
					int   amount = vars.Helper.Read<int>(current.Items + 0x8 + 0xC * i);

					int oldAmount;
					if (vars.Inventory.TryGetValue(item, out oldAmount))
					{
					}
					else
					{
						current.ItemSetting = string.Format(ItemFormat, '+', vars.FNameToString(item), '!');
						vars.splitstoComplete.Add(current.ItemSetting);
					}
					vars.Inventory[item] = amount;
				}
		#endregion
	
		#region Prettifying Coordinates
		current.playerPosXPretty = (double.IsNaN(current.playerPosX) || double.IsInfinity(current.playerPosX)) ? "—" : current.playerPosX.ToString("F2", System.Globalization.CultureInfo.InvariantCulture);
		current.playerPosYPretty = (double.IsNaN(current.playerPosY) || double.IsInfinity(current.playerPosY)) ? "—" : current.playerPosY.ToString("F2", System.Globalization.CultureInfo.InvariantCulture);
		current.playerPosZPretty = (double.IsNaN(current.playerPosZ) || double.IsInfinity(current.playerPosZ)) ? "—" : current.playerPosZ.ToString("F2", System.Globalization.CultureInfo.InvariantCulture);
		#endregion

		vars.SetTextIfEnabled("placeholder",current.Pause);
		vars.SetTextIfEnabled("movementCheckLoad",current.movementCheckLoad);
		vars.SetTextIfEnabled("loadRemovalReady",current.loadRemovalReady);
		vars.SetTextIfEnabled("playerPos",current.playerPosXPretty + " " + current.playerPosYPretty + " " + current.playerPosZPretty);
		vars.SetTextIfEnabled("World",current.World);
		vars.SetTextIfEnabled("AcknowledgedPawn",current.AcknowledgedPawn);
		vars.SetTextIfEnabled("camTarget",current.camTarget);
		vars.SetTextIfEnabled("MaxAcceleration",current.MaxAcceleration);
		vars.SetTextIfEnabled("LastItem",current.ItemSetting);

		//vars.Log("Pause: " + current.Pause);
	}

    start
    {
        if (current.World != "Main_Menu" && old.World == "Main_Menu" || current.World == "Cronos" && old.World == "Empty") {current.autostartReady = true;}

		if (current.autostartReady == true && old.MaxAcceleration == 2048 && current.MaxAcceleration == 400)
		{
			current.autostartReady =  false;
			return true;
		}
    }

	onStart
	{
		vars.CompletedSplits.Clear();
		vars.CompletedSplits.Clear();
		vars.Inventory.Clear();
		current.LastItemText = "";
	}

    isLoading
    {
		return current.loadReady || current.AcknowledgedPawnPtr == null || current.DeathLoad || current.MaxAcceleration == 2048;
	}

	exit
	{
		timer.IsGameTimePaused = true;
	}

	onReset
	{
		vars.CompletedSplits.Clear();
	}