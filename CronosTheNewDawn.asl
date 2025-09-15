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
			// --- Prologue ---
			{ "SSZ_LivingRoomKey",                         true, "SSZ Living Room Key",                        "Chapter Splits" }, // 
			{ "Fuse01",                                    false, "Fuse 01",                                   "Chapter Splits" }, // 
			{ "SSZ_ShopKey",                               true, "SSZ Shop Key",                               "Chapter Splits" }, // 
			{ "SSZ_TravelerKey",                           true, "SSZ Traveler Key",                           "Chapter Splits" }, // 
			// --- Apartments 1 ---
			{ "EmitterMode",                               true, "Emitter Mode",                               "Chapter Splits" }, // 
			{ "Anchor",                                    false, "Anchor",                                    "Chapter Splits" }, // right after EmitterMode
			{ "ShotgunAmmoRecipe",                         true, "Shotgun",                                    "Chapter Splits" }, // 
			{ "AZHasStoreKey",                             true, "AZ Has Store Key",                          "Chapter Splits" }, // Gameplay tag
			{ "Boltcutter",                                true, "Acquired Boltcutters",                        "Chapter Splits" }, // Gameplay tag
			{ "AZElevatorUnmergFors",                      false, "Riding Apartments Elevator",                "Chapter Splits" }, // Gameplay tag
			//{ "y_25",                                      false, "Y 25",                                      "Chapter Splits" }, // last "item" when kamu entered apartments 2
			// --- Apartments 2 ---
			{ "AZAngelaPictureFound",                      true, "Searched Edwards Apartment",                 "Chapter Splits" }, // Gameplay tag
			{ "AZ_Janitor_Key",                            true, "AZ Has Shelter Key",                         "Chapter Splits" }, // Gameplay tag
			{ "SPBurnIncreasedDamageTaken",                true, "Edwards Souls / End of Apartments 2",        "Chapter Splits" }, // Gameplay tag
			// --- Train station A ---
			{ "Cutscenes.C002.Played",                     false, "Cutscenes C002 Played",                     "Chapter Splits" }, // Gameplay tag
			{ "SSZLightsTechSection1",                     true, "Power Up Tram",                              "Chapter Splits" }, // Gameplay tag
			{ "ScannerMode",                               false, "Scanner Mode",                              "Chapter Splits" }, // 
			{ "SSZLightsTechSection2",                     true, "SSZ Lights Tech Section 2",                 "Chapter Splits" }, // Gameplay tag
			// --- Steelworks 1 ---
			{ "MineAmmoRecipe",                            true, "Pyre",                                       "Chapter Splits" }, // 
			{ "STW_KilledMagAChubby",                      false, "Killed Mag A Chubby",                       "Chapter Splits" }, // Gameplay tag
			{ "FZHallBDoorOpened",                         true, "FZ Hall B Door Opened",                     "Chapter Splits" }, // Gameplay tag
			{ "Handgun02Mode",                             true, "Handgun 02 Mode",                           "Chapter Splits" }, // 
			{ "STW_GravityBootsAcquired",                   true, "STW Gravity Boots Acquired",                "Chapter Splits" }, // Gameplay tag at the same time as GravityBootsMode
			// --- Steelworks 2 ---
			{ "LootPhase.TerrorD_FZ",                      false, "Steelworks Terror Boss Start",             "Chapter Splits" }, // Gameplay tag (Boss start)
			{ "SSZReturnFromFZ",                           true, "Steelworks Terror Boss Dead",               "Chapter Splits" }, // Gameplay tag (Boss end)
			{ "SPHandgunsHeadshotDamage",                  true, "Artur's/Gabriels Soul/End of Steelworks",   "Chapter Splits" }, // Gameplay tag (Souls.Gabriel if other option)
			// --- A-0 / Hospital ---
			{ "IdleSoulLeaksUnlocked",                     true, "A-0 Terminal",                               "Chapter Splits" }, // Gameplay tag
			{ "MachinegunAmmoRecipe",                      true, "Machine Gun",                                "Chapter Splits" }, // 
			{ "HZ_GuardPostKey",                           false, "HZ Guard Post Key",                         "Chapter Splits" }, // 
			{ "HZ_WingB_Open",                             true, "HZ Wing B Open",                            "Chapter Splits" }, // Gameplay tag
			{ "HZ_MorgueLights.Normal",                    false, "HZ Morgue Lights Normal",                   "Chapter Splits" }, // Gameplay tag
			{ "HZ_MorgueKey",                              true, "HZ Morgue Key",                             "Chapter Splits" }, // 
			{ "HZ_MorgueLights.Flicker",                   false,  "HZ Morgue Lights Flicker",                 "Chapter Splits" },
			{ "HZ_DirectorsCard",                           true, "HZ Director's Keycard Acquired",                           "Chapter Splits" },
			{ "HZ_WingA_Open",                              true, "HZ Wing A Open",                                "Chapter Splits" },
			{ "HZ_Chems_PickUp.ChemsA",                     false, "HZ Picked Up Formula Z-5",                      "Chapter Splits" },
			{ "HZ_Chems_PickUp.ChemsB",                     false, "HZ Picked Up Formula C-66",                      "Chapter Splits" },
			{ "HZ_Chems_C",                                 false, "HZ Picked Up Formula X-44",                      "Chapter Splits" },
			{ "HZ_Mixture",                                 true, "HZ Formula Mixed",                               "Chapter Splits" },
			{ "HZ_HeartKilled.ClearElevator",               true, "HZ Heart Killed",                                "Chapter Splits" },
			{ "HZ_HF_BossStart",                            false, "HZ HF Boss Start",                              "Chapter Splits" },
			{ "HZ_HF_BossDead",                             true, "HZ HF Boss Dead",                               "Chapter Splits" },
			{ "HZ_IslandsReturn",                           false, "HZ Islands Return",                             "Chapter Splits" },
			{ "SSZReturnFromHZ",                            true, "SSZ Return From HZ",                            "Chapter Splits" },
			// --- Island ---
			{ "HZ_IslandsReturn.YardLights",                false, "HZ Islands  Yard Lights",                       "Chapter Splits" },
			{ "HZ_IslandsReturn.TeleportFar_2_Forward",     true,  "HZ Islands Teleport 1",                         "Chapter Splits" },
			{ "HZ_IslandsReturn.TeleportFar_3_Forward",     false, "HZ Islands Teleport 2",                         "Chapter Splits" },
			{ "HZ_IslandsReturn.AngelaScene",               false, "HZ Islands Return Angela Scene",                "Chapter Splits" },
			{ "HZ_IslandsReturn.AngelaScene.SpawnUnmerged", false, "HZ Islands Return Angela Scene Spawn Unmerged", "Chapter Splits" },
			{ "HZ_IslandsReturn.PhoneBoothLights",          false, "HZ Islands Return Phone Booth Lights",          "Chapter Splits" },
			{ "HZ_IslandsReturn.QuadScene",                 false, "HZ Islands Return Quad Scene",                  "Chapter Splits" },
			{ "HZ_IslandsReturn.ArturSuicide",              false, "HZ Islands Return Artur Suicide",               "Chapter Splits" },
			{ "HZ_IslandsReturn.TeleportFar_4_Forward",     false, "HZ Islands Return Teleport Far 4 Forward",      "Chapter Splits" },
			{ "HZ_IslandsReturn.WardenScene",               false, "HZ Islands Return Warden Scene",                "Chapter Splits" },
			{ "HZ_IslandsReturn.WeronikaInDark",            false, "HZ Islands Return Weronika In Dark",            "Chapter Splits" },
			{ "HZ_IslandsReturn.ReturnExit",                false, "HZ Islands Return Return Exit",                 "Chapter Splits" },
			{ "Souls.Dawid",                                true, "Dawid's Soul/End of Island",                     "Chapter Splits" },
			{ "SSZConductorCutscene",                       true, "End of Angela Cutscene",                        "Chapter Splits" },
			{ "ConductorMode",                              true, "End of Warden Cutscene",                        "Chapter Splits" },
			{ "SSZSB_FirstPuzzleDone",                      true, "SSZSB First Puzzle Done",                       "Chapter Splits" },
			{ "SSZSB_Generator_I_Active",                   true, "SSZSB Generator I Active",                      "Chapter Splits" },
			{ "SSZSB_Generator_II_Active",                  true, "SSZSB Generator II Active",                     "Chapter Splits" },
			{ "CCZRoadReached",                             true, "CCZ Road Reached",                              "Chapter Splits" },
			{ "CCZAbbeyReached",                            true, "CCZ Abbey Reached (Abbey Fight Skip)",           "Chapter Splits" },
			{ "CCZAbbeyPowerRestored",                      true, "CCZ Abbey Power Restored",                      "Chapter Splits" },
			{ "CCZCatacombsOpen",                           true, "CCZ Catacombs Open",                            "Chapter Splits" },
			{ "CCZ_Statuette_3_Child",                      true, "CCZ Child Statuette",                           "Chapter Splits" },
			{ "CCZ_Statuette_5_Trident",                    true, "CCZ Trident Statuette",                          "Chapter Splits" },
			{ "CCZCourtyardReached",                        true, "CCZ Courtyard Reached",                         "Chapter Splits" },
			{ "CCZ_Statuette_2_Sword",                      true, "CCZ Sword Statuette",                          "Chapter Splits" },
			{ "CCZ_Statuette_6_Cauldron",                   true, "CCZ Cauldron Statuette",                        "Chapter Splits" },
			{ "LootPhase.Eliza",                            false, "CCZ Start Eliza Fight",                         "Chapter Splits" },
			{ "CCZRoadBackTag",                             true, "CCZ Elisa Dead",                                "Chapter Splits" },
			{ "SSZReturnFromCCZ",                           true, "SSZ Return From CCZ",                           "Chapter Splits" },
			// --- SSZ Again ---
			{ "SSZ_MilitiaStationKey",                      true, "SSZ Militia Station Key",                        "Chapter Splits" },
			{ "THZCorridorGlitch",                          true, "THZ Corridor Glitch",                           "Chapter Splits" },
			{ "THZ_Centi_Killed",                           false, "THZ Centi Killed",              				   "Chapter Splits" },
			{ "THZHDComplete",                              true, "THZ HD Complete",                               "Chapter Splits" },
			{ "THZ_PathfinderSpawn",                        false, "THZ PathfinderSpawn",              			   "Chapter Splits" },
			{ "THZ_PathfinderDead",                         true,  "THZ PathfinderDead",              			   "Chapter Splits" },

			{ "CollectedCats.CollectedCat01",               false, "Collected Cat 01",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat02",               false, "Collected Cat 02",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat03",               false, "Collected Cat 03",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat04",               false, "Collected Cat 04",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat05",               false, "Collected Cat 05",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat06",               false, "Collected Cat 06",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat07",               false, "Collected Cat 07",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat08",               false, "Collected Cat 08",               "Chapter Splits" },
			{ "CollectedCats.CollectedCat09",               false, "Collected Cat 09",               "Chapter Splits" },

		{"GameInfo", 					true, "Print Various Game Info",						null},
			{"World",                 false, "Current World",                                "GameInfo"},
			{"camTarget",               false, "Current Camera Target",         				"GameInfo"},
			{"playerPos",       false, "playerPos",                      "GameInfo"},
			{"MaxAcceleration",       false, "MaxAcceleration",                      "GameInfo"},
			{"LastItem",               true, "Last item picked up",         				"GameInfo"},
			{"LevelStreaming",               true, "LevelStreaming",         				"GameInfo"},
			{"GameplayTag",               true, "GameplayTag",         				"GameInfo"},
		{"Debug", 					    false, "Print Debug Info",    							null},
			{"Debug Desktop Data Dump",       false, "Debug Desktop Data Dump",                      "Debug"},
			{"placeholder",       false, "placeholder",                      "Debug"},
			{"loadReady",       false, "loadReady",                      "Debug"},
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
		vars.LastInventoryItems = new List<string>();
		vars.LastGameplayTags = new List<string>();
		vars.ItemsCollected = new HashSet<string>();
		vars.ItemDisplay = "";
		vars.TagDisplay = "";
		vars.LastItemDisplay = "";
		vars.LastTagDisplay = "";
	}

	init
	{
        //Unreal Engine 5.05
		IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
		IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
		IntPtr fNamePool = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");
		IntPtr gSyncLoadCount = vars.Helper.ScanRel(5, "89 43 60 8B 05 ?? ?? ?? ??");
		

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
		// gEngine - GameViewport(BD0) - World(078) - FName 
		vars.Helper["LevelStreamingName"] = vars.Helper.Make<ulong>(gEngine, 0xBD0, 0x78, 0x88, 0x0, 0x18);
		// gEngine -> GameInstance(1210) -> Subsystems(108)
		vars.Helper["Subsystems"] = vars.Helper.Make<IntPtr>(gEngine, 0x1210, 0x108);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> Character(318) - CapsuleComponent(358) - RelativeLocationX(128)
 		vars.Helper["playerPosX"] = vars.Helper.Make<double>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x358, 0x128);
		vars.Helper["playerPosY"] = vars.Helper.Make<double>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x358, 0x130);
		vars.Helper["playerPosZ"] = vars.Helper.Make<double>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x358, 0x138);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> Character(318) - Movement(6E8) - MaxAcceleration(27C)
 		vars.Helper["MaxAcceleration"] = vars.Helper.Make<float>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x318, 0x6E8, 0x27C);
		//gEngine - GameViewport(BD0) - GWorld(78) -> GameState(160) -> - PersistentAbilitySystem(338) - PersistentGameplayTagCountMap(1250) (AllocatorInstance)
		vars.Helper["PersistentGameplayTagCountMap"] = vars.Helper.Make<IntPtr>(gEngine, 0xBD0, 0x078, 0x160, 0x338, 0x1250);
		vars.Helper["PersistentGameplayTagCountMapNum"] = vars.Helper.Make<int>(gEngine, 0xBD0, 0x078, 0x160, 0x338, 0x1258);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> PlayerCameraManager(380) -> ViewTarget.Target(360) -> FNameIndex
		vars.Helper["camTargetName"]  = vars.Helper.Make<ulong>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x380, 0x360, 0x18);
		// gEngine.TransitionType
		vars.Helper["Pause"] = vars.Helper.Make<bool>(gEngine, 0xD0C);
		// gEngine - GameInstance - bDeathReload[1]
		vars.Helper["DeathLoad"] = vars.Helper.Make<bool>(gEngine, 0x1210, 0x388);
		// gEngine - GameViewport(BD0) - World(078) - AuthorityGameMode(158) - MenuController(368) - StateWidgetsAllocatorInstance(E8) - NameKey(0)
		vars.Helper["StateWidget"] = vars.Helper.Make<ulong>(gEngine, 0xBD0, 0x078, 0x158, 0x368, 0xE8, 0x0);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370) - Items(728) - CollectedItemsAllocatorInstance(1D8) - 0x0
		vars.Helper["Items"] = vars.Helper.Make<IntPtr>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x370, 0x728, 0x1D8);
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370) - Items(728) - CollectedItemsAllocatorInstance(1D8) - 0x0
		vars.Helper["ItemsCount"] = vars.Helper.Make<uint>(gEngine, 0x1210, 0x38, 0x0, 0x30, 0x370, 0x728, 0x1E0);
		
		//Incomplete or unused paths
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370)
		// gEngine -> GameInstance(1210) -> Subsystems(108) - BTGameObjectivesSystem (140)
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> MyHUD(378) - HUDWidget(690) - ObjectivesLogWidget(450) - MainObjectiveContainer(2D0) - Slots(168) - 0 - content(30) - QuestNameTextBlock(2D0), 18
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> AcknowledgedPawn(370) - UIComponent(758) - GameplayFocusWidget(150) - DesiredWidgetName(28C)
		// gEngine -> GameInstance(1210) -> DeathReload (388)
		// gEngine -> GameInstance(1210) -> LocalPlayers[0](38) -> Dereference(0) -> PlayerController(30) -> MyHUD(378) - HUDWidget(690) - ObjectivesLogWidget(450) - TaskCompletedStatusOverlay(330)
		// gEngine - GameViewport(BD0) - World(078) - LevelsAllocatorInstance(178) - 0 - 18
		// gEngine - GameViewport(BD0) - World(078) - AuthorityGameMode(158) - MenuController(368) - StateWidgetsAllocatorInstance(E8) - NameKey(0)

		current.World = "";
		current.camTarget = "";
		current.LevelStreaming = "";
		current.autostartReady = false;
		current.loadReady = false;
		current.placeholderTest = "";
		current.playerPosXPretty = "";
		current.playerPosYPretty = "";
		current.playerPosZPretty = "";
		current.LevelStreamingPretty = "";
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

		var LevelStreaming = vars.FNameToString(current.LevelStreamingName);
		if (!string.IsNullOrEmpty(LevelStreaming) && LevelStreaming != "None")
			current.LevelStreaming = LevelStreaming;
		if (old.LevelStreaming != current.LevelStreaming)
			vars.Log("LevelStreaming: " + old.LevelStreaming + " -> " + current.LevelStreaming);

		var placeholder = vars.FNameToString(current.GWorldName);
		if (!string.IsNullOrEmpty(placeholder) && placeholder != "None")
			current.placeholderTest = placeholder;
		if (old.placeholderTest != current.placeholderTest)
			vars.Log("placeholderTest: " + old.placeholderTest + " -> " + current.placeholderTest);

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

		#region Item Check
        var currentItems = new List<string>();
        for (int i = 0; i < vars.Helper["ItemsCount"].Current; i++)
        {
            ulong ReadItemName = vars.Helper.Read<ulong>(vars.Helper["Items"].Current + (i * 0x14));
            var itemName = vars.FNameToString(ReadItemName);
            currentItems.Add(itemName);
        }

        foreach (var item in currentItems)
        {
            if (!vars.LastInventoryItems.Contains(item))
            {
                vars.Log("Item: " + item + " Added To Inventory");
                vars.ItemDisplay = item;
            }
        }

        foreach (var item in vars.LastInventoryItems)
        {
            if (!currentItems.Contains(item))
            {
                vars.Log("Item: " + item + " Removed From Inventory");
            }
        }

        vars.LastInventoryItems = currentItems;
		#endregion
	
		#region Prettifying Data
		current.playerPosXPretty = (double.IsNaN(current.playerPosX) || double.IsInfinity(current.playerPosX)) ? "—" : current.playerPosX.ToString("F2", System.Globalization.CultureInfo.InvariantCulture);
		current.playerPosYPretty = (double.IsNaN(current.playerPosY) || double.IsInfinity(current.playerPosY)) ? "—" : current.playerPosY.ToString("F2", System.Globalization.CultureInfo.InvariantCulture);
		current.playerPosZPretty = (double.IsNaN(current.playerPosZ) || double.IsInfinity(current.playerPosZ)) ? "—" : current.playerPosZ.ToString("F2", System.Globalization.CultureInfo.InvariantCulture);

		var ls = (current.LevelStreaming ?? "").Replace("WorldPartitionLevelStreaming_", "");
		current.LevelStreamingPretty = (ls.Length == 0 || ls == "None") ? "No Level Streaming" : ls.Substring(System.Math.Max(ls.LastIndexOf('_') + 1, 0));
		#endregion

		vars.SetTextIfEnabled("placeholder",current.placeholderTest);
		vars.SetTextIfEnabled("playerPos",current.playerPosXPretty + " " + current.playerPosYPretty + " " + current.playerPosZPretty);
		vars.SetTextIfEnabled("World",current.World);
		vars.SetTextIfEnabled("camTarget",current.camTarget);
		vars.SetTextIfEnabled("MaxAcceleration",current.MaxAcceleration);
		vars.SetTextIfEnabled("GameplayTag",vars.TagDisplay);
		vars.SetTextIfEnabled("LastItem",vars.ItemDisplay);
		vars.SetTextIfEnabled("LevelStreaming",current.LevelStreamingPretty);
		vars.SetTextIfEnabled("loadReady",current.loadReady);
		
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
		vars.LastInventoryItems.Clear();
		vars.LastGameplayTags.Clear();
	}

    isLoading
    {
		return current.loadReady || current.DeathLoad || current.MaxAcceleration == 2048;
	}

	//WIP taken from 
	//https://raw.githubusercontent.com/Arkhamfan69/My-Splitters-Load-Removers/refs/heads/main/Autosplitters/Papao.asl
	//https://github.com/Arkhamfan69/My-Splitters-Load-Removers/blob/main/Xml%20Settings/Papao_Settings.xml
	
	split
	{
		if (settings.ContainsKey(vars.TagDisplay) && settings[vars.TagDisplay] && !vars.CompletedSplits.Contains(vars.TagDisplay))
		{
			vars.CompletedSplits.Add(vars.TagDisplay);
			return true;
		}

		if (settings.ContainsKey(vars.ItemDisplay) && settings[vars.ItemDisplay] && !vars.CompletedSplits.Contains(vars.ItemDisplay))
		{
			vars.CompletedSplits.Add(vars.ItemDisplay);
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

/*
STW_WarehouseKey 
*/
