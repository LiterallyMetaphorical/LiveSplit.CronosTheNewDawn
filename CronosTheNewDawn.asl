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
		{"GameInfo", 					true, "Print Various Game Info",						null},
			{"World",                 false, "Current World",                                "GameInfo"},
			{"MaxAcceleration",       false, "MaxAcceleration",                      "GameInfo"},
			{"LevelStreaming",               true, "LevelStreaming",         				"GameInfo"},
			{"GameplayTag",               true, "GameplayTag",         				"GameInfo"},

		{ "Chapter Splits", true, "Chapter Splits", null },
			{ "THZ_PathfinderDead",                         true,  "THZ PathfinderDead",              			   "Chapter Splits" },
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

		vars.CompletedSplits 	 = new HashSet<string>();
		vars.LastGameplayTags = new List<string>();
		vars.TagDisplay = "No Tags Yet";
		vars.LastTagDisplay = "No Previous Tag Yet";
	}

	init
	{
        //Unreal Engine 5.05
		IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
		IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
		IntPtr fNamePool = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");

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

		#region Text Component
		vars.SetTextIfEnabled = (Action<string, object>)((text1, text2) =>
		{
			if (settings[text1]) vars.SetText(text1, text2); 
			else vars.RemoveText(text1);
		});
		#endregion

		// gEngine - GameViewport(BD0) - World(078) - FName 
		vars.Helper["GWorldName"] = vars.Helper.Make<ulong>(gEngine, 0xBD0, 0x078, 0x18);
		// gEngine - GameViewport(BD0) - World(078) - FName 
		vars.Helper["LevelStreamingName"] = vars.Helper.Make<ulong>(gEngine, 0xBD0, 0x78, 0x88, 0x0, 0x18);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> Character(318) - Movement(6E8) - MaxAcceleration(27C)
 		vars.Helper["MaxAcceleration"] = vars.Helper.Make<float>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x6E8, 0x27C);
		//gEngine - GameViewport(BD0) - GWorld(78) -> GameState(160) -> - PersistentAbilitySystem(338) - PersistentGameplayTagCountMap(1250) (AllocatorInstance)
		vars.Helper["PersistentGameplayTagCountMap"] = vars.Helper.Make<IntPtr>(gEngine, 0xBD0, 0x078, 0x160, 0x338, 0x1250);
		vars.Helper["PersistentGameplayTagCountMapNum"] = vars.Helper.Make<int>(gEngine, 0xBD0, 0x078, 0x160, 0x338, 0x1258);
		// gEngine.TransitionType
		vars.Helper["Pause"] = vars.Helper.Make<bool>(gEngine, 0xD0C);
		// gEngine - GameInstance - bDeathReload[1]
		vars.Helper["DeathLoad"] = vars.Helper.Make<bool>(gEngine, 0x1210, 0x388);

		current.World = "No World Yet";
		current.LevelStreaming = "No Level Streaming Yet";
		current.autostartReady = false;
		current.loadReady = false;
		current.LevelStreamingPretty = "No Level Streaming Yet";
	}

	update
	{
		vars.Helper.Update();
		vars.Helper.MapPointers();

		var World = vars.FNameToString(current.GWorldName);
		if (!string.IsNullOrEmpty(World) && World != "None")
			current.World = World;
		if (old.World != current.World) vars.Log("World: " + old.World + " -> " + current.World);

		var LevelStreaming = vars.FNameToString(current.LevelStreamingName);
		if (!string.IsNullOrEmpty(LevelStreaming) && LevelStreaming != "None")
			current.LevelStreaming = LevelStreaming;
		if (old.LevelStreaming != current.LevelStreaming)
			vars.Log("LevelStreaming: " + old.LevelStreaming + " -> " + current.LevelStreaming);

		var ls = (current.LevelStreaming ?? "").Replace("WorldPartitionLevelStreaming_", "");
		current.LevelStreamingPretty = (ls.Length == 0 || ls == "None") ? "No Level Streaming" : ls.Substring(System.Math.Max(ls.LastIndexOf('_') + 1, 0));

		if (vars.TagDisplay == "_1" || current.World == "Empty")
		{current.loadReady = true;}

		if (current.loadReady == true && old.MaxAcceleration == 2048 && current.MaxAcceleration == 400)
		{current.loadReady = false;}

		#region Gameplay Tag Check
		var currentTags = new List<string>();
		for (int i = 0; i < vars.Helper["PersistentGameplayTagCountMapNum"].Current; i++)
		{
			ulong ReadTagName = vars.Helper.Read<ulong>(vars.Helper["PersistentGameplayTagCountMap"].Current + (i * 0x14));
			var tagName = vars.FNameToString(ReadTagName);
			currentTags.Add(tagName);
		}

			foreach (var tag in currentTags)
			{
				if (!vars.LastGameplayTags.Contains(tag))
				{
					 //store a prettified version in TagDisplay
					 
					var gt = tag ?? "";
					if (gt.StartsWith("Gameplay.Game.State."))
						gt = gt.Substring("Gameplay.Game.State.".Length);
					vars.TagDisplay = (gt.Length == 0 || gt == "None") ? "—" : gt;

					vars.Log("Gameplay Tag " + vars.TagDisplay +  " Added");
				}
			}

		foreach (var tag in vars.LastGameplayTags)
		{
			if (!currentTags.Contains(tag))
			{
				vars.Log("Gameplay Tag " + vars.TagDisplay + " Removed");
			}
		}

    	vars.LastGameplayTags = currentTags;
		#endregion

		vars.SetTextIfEnabled("World",current.World);
		vars.SetTextIfEnabled("MaxAcceleration",current.MaxAcceleration);
		vars.SetTextIfEnabled("GameplayTag",vars.TagDisplay);
		vars.SetTextIfEnabled("LevelStreaming",current.LevelStreamingPretty);
		//vars.Log("Pause: " + vars.TagDisplay);
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
		vars.LastGameplayTags.Clear();
	}

    isLoading
    {
		return current.loadReady || current.DeathLoad || current.MaxAcceleration == 2048;
	}
	
	split
	{
		if (settings.ContainsKey(vars.TagDisplay) && settings[vars.TagDisplay] && !vars.CompletedSplits.Contains(vars.TagDisplay))
		{
			vars.CompletedSplits.Add(vars.TagDisplay);
			return true;
		}
	}

	exit
	{
		timer.IsGameTimePaused = true;
	}

	onReset
	{
		vars.CompletedSplits.Clear();
	}
