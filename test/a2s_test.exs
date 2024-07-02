defmodule A2STest do
  use ExUnit.Case, async: true

  describe "parse_response/2" do
    test "Hell Let Loose | A2S_INFO" do
      {:ok, info_packet} = File.read("test/samples/hll_info.bin")

      assert A2S.parse_response(info_packet) ===
               {:info,
                %A2S.Info{
                  protocol: 17,
                  name: "Glow's Battlegrounds :: Event Server :: discord.gg/glows",
                  map: "SME",
                  folder: "hlldir",
                  game: "Hell Let Loose",
                  # expected behavior for HLL
                  appid: 0,
                  players: 91,
                  max_players: 100,
                  bots: 0,
                  server_type: :dedicated,
                  environment: :windows,
                  visibility: :private,
                  vac: :secured,
                  version: "0.1.1.0",
                  gameport: 7777,
                  steamid: 90_175_710_618_294_273,
                  spectator_port: nil,
                  spectator_name: nil,
                  keywords:
                    "GS:Ij1rHvaoS722kYAG,CONMETHOD:P2P,P2PADDR:90175710618294273,P2PPORT:7777,SESSIONFLAGS:171,VISIB_i:0",
                  gameid: 686_810
                }}
    end

    test "Squad | A2S_INFO" do
      {:ok, info_packet} = File.read("test/samples/squad_info.bin")

      assert A2S.parse_response(info_packet) ===
               {:info,
                %A2S.Info{
                  protocol: 17,
                  name: "The Potato Fields 1 | New Player Friendly",
                  map: "Lashkar_AAS_v2",
                  folder: "squad",
                  game: "Squad",
                  # expected for Squad (common to UE4?)
                  appid: 0,
                  players: 99,
                  max_players: 100,
                  bots: 0,
                  server_type: :dedicated,
                  environment: :linux,
                  visibility: :public,
                  vac: :unsecured,
                  version: "dev",
                  gameport: 10250,
                  steamid: 90_175_629_439_555_585,
                  spectator_port: nil,
                  spectator_name: nil,
                  keywords:
                    "BUILDID:155155,OWNINGID:90175629439555585,OWNINGNAME:The Potato Fields 1 | New Player Friendly,NUMOPENPRIVCONN:2,NUMPUBCONN:98",
                  gameid: 393_380
                }}
    end

    test "Valheim | A2S_INFO" do
      {:ok, info_packet} = File.read("test/samples/valheim_info.bin")

      assert A2S.parse_response(info_packet) ===
               {:info,
                %A2S.Info{
                  protocol: 17,
                  name: "Jotunheim (discord.gg/WmRVCMMR5f)",
                  map: "Jotunheim (discord.gg/WmRVCMMR5",
                  folder: "valheim",
                  game: "",
                  appid: 0,
                  players: 38,
                  max_players: 150,
                  bots: 0,
                  server_type: :dedicated,
                  environment: :linux,
                  visibility: :private,
                  vac: :unsecured,
                  version: "1.0.0.0",
                  gameport: 10555,
                  steamid: 90_199_620_650_353_684,
                  spectator_port: nil,
                  spectator_name: nil,
                  keywords: "g=0.218.15,n=27,m=",
                  gameid: 892_970
                }}
    end

    test "Valheim | A2S_PLAYER" do
      {:ok, player_packet} = File.read("test/samples/valheim_player.bin")

      assert A2S.parse_response(player_packet) ===
               {:players,
                %A2S.Players{
                  count: 36,
                  players: [
                    %A2S.Player{index: 0, name: "", score: 0, duration: 63715.08984375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 45200.234375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 40075.59375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 38261.9609375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 31906.052734375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 30105.51171875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 25209.091796875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 22037.396484375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 20879.52734375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 17018.029296875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 16371.794921875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 14335.6650390625},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 13077.8115234375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 12733.16796875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 12478.6220703125},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 10511.4951171875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 10340.11328125},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 7786.416015625},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 7429.6484375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 7188.0751953125},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 6826.318359375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 5485.42529296875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 4991.3642578125},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 4917.37744140625},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 4804.9951171875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 4446.9169921875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 3274.19873046875},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 2960.712890625},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 2851.598876953125},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 2708.974609375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 1693.22509765625},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 1561.081298828125},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 1255.704345703125},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 1249.794677734375},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 437.592041015625},
                    %A2S.Player{index: 0, name: "", score: 0, duration: 316.4258728027344}
                  ]
                }}
    end

    test "Garry's Mod | A2S_PLAYER" do
      {:ok, player_packet} = File.read("test/samples/gmod_player.bin")

      assert A2S.parse_response(player_packet) ===
               {:players,
                %A2S.Players{
                  count: 113,
                  players: [
                    %A2S.Player{index: 0, name: "Senkai", score: 9, duration: 33486.859375},
                    %A2S.Player{index: 0, name: "Zodus", score: 20, duration: 27215.33203125},
                    %A2S.Player{
                      index: 0,
                      name: "Kake civilnetworks.net",
                      score: 14,
                      duration: 26185.01953125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "CursedAngel_69",
                      score: 4,
                      duration: 24958.01953125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Bowlcut",
                      score: 10,
                      duration: 24316.662109375
                    },
                    %A2S.Player{index: 0, name: "Hiszpan", score: 6, duration: 23841.439453125},
                    %A2S.Player{
                      index: 0,
                      name: "bing bigd",
                      score: 8,
                      duration: 21383.884765625
                    },
                    %A2S.Player{index: 0, name: "Cece", score: 0, duration: 21262.978515625},
                    %A2S.Player{
                      index: 0,
                      name: "hj10wen civilnetworks.net",
                      score: 8,
                      duration: 21206.796875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "ₓₒₙᵢc",
                      score: 0,
                      duration: 19803.5703125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Ray sanders",
                      score: 2,
                      duration: 16058.431640625
                    },
                    %A2S.Player{index: 0, name: "Judge", score: 1, duration: 14691.494140625},
                    %A2S.Player{
                      index: 0,
                      name: "-=ScoRpioN=-",
                      score: 1,
                      duration: 14189.046875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "zazi_18",
                      score: 4,
                      duration: 12427.4736328125
                    },
                    %A2S.Player{index: 0, name: "Benji", score: 0, duration: 12399.6328125},
                    %A2S.Player{
                      index: 0,
                      name: "AssassinsAim",
                      score: 3,
                      duration: 12367.634765625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Pyrosity",
                      score: 1,
                      duration: 11897.642578125
                    },
                    %A2S.Player{index: 0, name: "Monke", score: 2, duration: 11490.96484375},
                    %A2S.Player{
                      index: 0,
                      name: "Pussyplucker27@civilnetworks.net",
                      score: 6,
                      duration: 11403.4072265625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Thatcher",
                      score: 1,
                      duration: 11168.6123046875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Avery :3",
                      score: 19,
                      duration: 10477.748046875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Sad-Trappy",
                      score: 1,
                      duration: 10220.986328125
                    },
                    %A2S.Player{index: 0, name: "Fuse", score: 2, duration: 10089.4443359375},
                    %A2S.Player{
                      index: 0,
                      name: "Casseno1",
                      score: 0,
                      duration: 9424.5244140625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Kayla1508",
                      score: 0,
                      duration: 9305.1396484375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Archiethegoat",
                      score: 1,
                      duration: 9257.9365234375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Steves Man",
                      score: 18,
                      duration: 9197.0947265625
                    },
                    %A2S.Player{index: 0, name: "Specter", score: 2, duration: 8922.259765625},
                    %A2S.Player{
                      index: 0,
                      name: "Caramelalpaca",
                      score: 3,
                      duration: 8231.103515625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Simmoun civilnetworks.net",
                      score: 0,
                      duration: 8169.78515625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Bedzie Dobrze",
                      score: 20,
                      duration: 8151.47265625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Crusty Moth",
                      score: 1,
                      duration: 8075.392578125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "GHOSTy288",
                      score: 1,
                      duration: 7977.7763671875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Jesse_Soul_",
                      score: 0,
                      duration: 7846.80078125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Crazy_Cain69 civilnetworks.net",
                      score: 0,
                      duration: 7843.5419921875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Bananolas",
                      score: 11,
                      duration: 7731.3583984375
                    },
                    %A2S.Player{index: 0, name: "FnordJ", score: 0, duration: 7380.759765625},
                    %A2S.Player{
                      index: 0,
                      name: "tintinprod173",
                      score: 0,
                      duration: 7235.783203125
                    },
                    %A2S.Player{index: 0, name: "Asura", score: 0, duration: 7145.02099609375},
                    %A2S.Player{
                      index: 0,
                      name: "Lucil Datko",
                      score: 1,
                      duration: 7137.97802734375
                    },
                    %A2S.Player{index: 0, name: "Serrt", score: 0, duration: 7018.69091796875},
                    %A2S.Player{index: 0, name: "DrTaboo", score: 1, duration: 6975.6005859375},
                    %A2S.Player{
                      index: 0,
                      name: "Engallagher",
                      score: 0,
                      duration: 6860.92333984375
                    },
                    %A2S.Player{index: 0, name: "dooper", score: 0, duration: 6816.55859375},
                    %A2S.Player{
                      index: 0,
                      name: "TheCrazyscotsman",
                      score: 4,
                      duration: 6746.26171875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "skuarez civilnetworks.net",
                      score: 3,
                      duration: 6684.15625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Shalaxgun",
                      score: 0,
                      duration: 6444.84619140625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "good D Boi civilnetworks.net",
                      score: 2,
                      duration: 6370.57080078125
                    },
                    %A2S.Player{index: 0, name: "Nuke", score: 0, duration: 6237.458984375},
                    %A2S.Player{
                      index: 0,
                      name: "skdibap civilnetworks.net",
                      score: 4,
                      duration: 6131.86962890625
                    },
                    %A2S.Player{index: 0, name: "beer", score: 3, duration: 5863.708984375},
                    %A2S.Player{
                      index: 0,
                      name: "West [Civilnetworks.net]",
                      score: 18,
                      duration: 5805.84716796875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Lix civilnetworks.net",
                      score: 0,
                      duration: 5746.26220703125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "KingViper115",
                      score: 0,
                      duration: 5474.0986328125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Nugglet",
                      score: 0,
                      duration: 5267.71435546875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Staticmercuary27",
                      score: 1,
                      duration: 5251.1455078125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "tyrone",
                      score: 41,
                      duration: 5090.17138671875
                    },
                    %A2S.Player{index: 0, name: "Tay", score: 3, duration: 4902.75537109375},
                    %A2S.Player{
                      index: 0,
                      name: "civilnetworks.net Chico",
                      score: 3,
                      duration: 4817.6533203125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "reeeeee",
                      score: 8,
                      duration: 4519.41259765625
                    },
                    %A2S.Player{index: 0, name: "heaven12", score: 1, duration: 4515.404296875},
                    %A2S.Player{
                      index: 0,
                      name: "Dampfwalze2011",
                      score: 1,
                      duration: 4474.2646484375
                    },
                    %A2S.Player{index: 0, name: "Thunder", score: 0, duration: 4293.572265625},
                    %A2S.Player{
                      index: 0,
                      name: "Nathski (civilnetworks.net)",
                      score: 0,
                      duration: 4139.3017578125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "toastey!",
                      score: 0,
                      duration: 4063.591552734375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Friendlysmileyman",
                      score: 0,
                      duration: 4016.1513671875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Frosty",
                      score: 1,
                      duration: 3999.300537109375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "SockenBoopin",
                      score: 1,
                      duration: 3977.41259765625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "TinoDino",
                      score: 0,
                      duration: 3935.37353515625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Inkshadow",
                      score: 0,
                      duration: 3678.521240234375
                    },
                    %A2S.Player{index: 0, name: "Jinli", score: 0, duration: 3604.529541015625},
                    %A2S.Player{
                      index: 0,
                      name: "Vlad civilnetworks.net",
                      score: 0,
                      duration: 3440.61474609375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "DeadlyEmu",
                      score: 0,
                      duration: 3380.0361328125
                    },
                    %A2S.Player{index: 0, name: "Chichi", score: 0, duration: 3077.81591796875},
                    %A2S.Player{
                      index: 0,
                      name: "Cheesy",
                      score: 6,
                      duration: 3015.462646484375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Jacob Rothschild",
                      score: 1,
                      duration: 2908.9150390625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "ERav3n",
                      score: 0,
                      duration: 2704.794677734375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Jasperdoit",
                      score: 0,
                      duration: 2689.94873046875
                    },
                    %A2S.Player{index: 0, name: "Ventz", score: 0, duration: 2662.66943359375},
                    %A2S.Player{
                      index: 0,
                      name: "Babagansh civilworks.net",
                      score: 0,
                      duration: 2581.6220703125
                    },
                    %A2S.Player{index: 0, name: "Zulu", score: -1, duration: 2534.182373046875},
                    %A2S.Player{
                      index: 0,
                      name: "Glovano",
                      score: 5,
                      duration: 2522.921630859375
                    },
                    %A2S.Player{index: 0, name: "Prplex", score: 0, duration: 2291.490234375},
                    %A2S.Player{
                      index: 0,
                      name: "DasNexo",
                      score: 0,
                      duration: 2057.87548828125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Lightning_Royalty",
                      score: 0,
                      duration: 2054.926025390625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Swibly_",
                      score: 0,
                      duration: 2039.3209228515625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "ItzPixel",
                      score: 0,
                      duration: 2009.9071044921875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "anmi89to",
                      score: -1,
                      duration: 1866.9471435546875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Pizza Bagaren",
                      score: 0,
                      duration: 1821.325439453125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "drenicaku",
                      score: 0,
                      duration: 1781.027099609375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Tyler16",
                      score: 0,
                      duration: 1652.472900390625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "damdam31",
                      score: 0,
                      duration: 1510.4991455078125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "kastensxxx",
                      score: 0,
                      duration: 1501.5999755859375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "MetallumIsCrazy",
                      score: 0,
                      duration: 1459.293701171875
                    },
                    %A2S.Player{
                      index: 0,
                      name: "TheAverageCheese",
                      score: 0,
                      duration: 1419.1993408203125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "-NoSignalFound-",
                      score: 0,
                      duration: 1326.829345703125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Benny",
                      score: 0,
                      duration: 1314.4576416015625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "ShadowRaider",
                      score: 0,
                      duration: 1204.4727783203125
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Emperor87",
                      score: 0,
                      duration: 1179.98681640625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "civilnetworks.net",
                      score: 0,
                      duration: 1111.5560302734375
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Cooking Brö? fr? fr?",
                      score: 0,
                      duration: 885.465087890625
                    },
                    %A2S.Player{
                      index: 0,
                      name: "Naffen",
                      score: 1,
                      duration: 884.3546142578125
                    },
                    %A2S.Player{index: 0, name: "riley", score: 0, duration: 712.009521484375},
                    %A2S.Player{
                      index: 0,
                      name: "Magnetic",
                      score: 0,
                      duration: 686.1057739257812
                    },
                    %A2S.Player{
                      index: 0,
                      name: "mukkelis",
                      score: 0,
                      duration: 681.5773315429688
                    },
                    %A2S.Player{
                      index: 0,
                      name: "YandereMuffin™",
                      score: 0,
                      duration: 665.6911010742188
                    },
                    %A2S.Player{index: 0, name: "Yeke", score: 0, duration: 644.5908813476562},
                    %A2S.Player{
                      index: 0,
                      name: "lebateur8",
                      score: 0,
                      duration: 457.5916442871094
                    },
                    %A2S.Player{
                      index: 0,
                      name: "guard1234",
                      score: 0,
                      duration: 399.423095703125
                    },
                    %A2S.Player{index: 0, name: "", score: 0, duration: 312.48687744140625},
                    %A2S.Player{
                      index: 0,
                      name: "Huge Fella 12",
                      score: 0,
                      duration: 302.9036560058594
                    },
                    %A2S.Player{
                      index: 0,
                      name: "BoltSive",
                      score: 0,
                      duration: 297.3497009277344
                    },
                    %A2S.Player{index: 0, name: "dope", score: 0, duration: 263.94134521484375}
                  ]
                }}
    end

    test "Garry's Mod | A2S_RULES" do
      {:ok, rules_packet} = File.read("test/samples/gmod_rules.bin")

      assert A2S.parse_response(rules_packet) ===
               {:rules,
                %A2S.Rules{
                  count: 265,
                  rules: [
                    {"ai_disabled", "0"},
                    {"ai_ignoreplayers", "0"},
                    {"cnadvent_25_open_past_25th_enabled", "1"},
                    {"cnadvent_enabled", "0"},
                    {"cnadvent_enable_present_requirement", "1"},
                    {"coop", "0"},
                    {"cuffs_allowbreakout", "1"},
                    {"DavyCrocketAdminOnly", "0"},
                    {"DavyCrockettAllowed", "1"},
                    {"deathmatch", "1"},
                    {"decalfrequency", "10"},
                    {"gred_jets_speed", "0"},
                    {"gred_sv_12mm_he_impact", "1"},
                    {"gred_sv_7mm_he_impact", "1"},
                    {"gred_sv_arti_spawnaltitude", "1000"},
                    {"gred_sv_bullet_dmg", "1"},
                    {"gred_sv_bullet_radius", "1"},
                    {"gred_sv_default_wac_munitions", "0"},
                    {"gred_sv_easyuse", "1"},
                    {"gred_sv_enableenginehealth", "0"},
                    {"gred_sv_enablehealth", "0"},
                    {"gred_sv_fire_effect", "1"},
                    {"gred_sv_fragility", "1"},
                    {"gred_sv_healthslider", "100"},
                    {"gred_sv_lfs_godmode", "0"},
                    {"gred_sv_lfs_healthmultiplier", "1"},
                    {"gred_sv_lfs_healthmultiplier_all", "1"},
                    {"gred_sv_lfs_infinite_ammo", "0"},
                    {"gred_sv_maxforcefield_range", "5000"},
                    {"gred_sv_minricochetangle", "70"},
                    {"gred_sv_multiple_fire_effects", "1"},
                    {"gred_sv_oldrockets", "0"},
                    {"gred_sv_override_hab", "0"},
                    {"gred_sv_resourceprecache", "0"},
                    {"gred_sv_shellspeed_multiplier", "2"},
                    {"gred_sv_shell_apcr_damagemultiplier", "1"},
                    {"gred_sv_shell_ap_damagemultiplier", "1"},
                    {"gred_sv_shell_ap_lowpen_ap_damage", "0"},
                    {"gred_sv_shell_ap_lowpen_maxricochetchance", "1"},
                    {"gred_sv_shell_ap_lowpen_shoulddecreasedamage", "1"},
                    {"gred_sv_shell_ap_lowpen_system", "1"},
                    {"gred_sv_shell_gp_he_damagemultiplier", "1"},
                    {"gred_sv_shell_heat_damagemultiplier", "1"},
                    {"gred_sv_shell_he_damage", "0"},
                    {"gred_sv_shell_he_damagemultiplier", "1"},
                    {"gred_sv_shell_speed_multiplier", "1"},
                    {"gred_sv_shockwave_unfreeze", "0"},
                    {"gred_sv_simfphys_arcade", "1"},
                    {"gred_sv_simfphys_enablecrosshair", "1"},
                    {"gred_sv_simfphys_health_multplier", "1"},
                    {"gred_sv_simfphys_infinite_ammo", "1"},
                    {"gred_sv_simfphys_lesswheels", "1"},
                    {"gred_sv_simfphys_spawnwithoutammo", "0"},
                    {"gred_sv_simfphys_testsuspensions", "0"},
                    {"gred_sv_simfphys_turnrate_multplier", "1"},
                    {"gred_sv_soundspeed_divider", "1"},
                    {"gred_sv_spawnable_bombs", "1"},
                    {"gred_sv_tracers", "5"},
                    {"gred_sv_wac_bombs", "0"},
                    {"gred_sv_wac_explosion", "0"},
                    {"gred_sv_wac_explosion_water", "0"},
                    {"gred_sv_wac_heli_spin", "0"},
                    {"gred_sv_wac_heli_spin_chance", "0"},
                    {"gred_sv_wac_override", "0"},
                    {"gred_sv_wac_radio", "0"},
                    {"guitar_experimental", "0"},
                    {"has_pac3", "1"},
                    {"has_pac3_editor", "1"},
                    {"M9KAmmoDetonation", "1"},
                    {"M9KClientGasDisable", "0"},
                    {"M9KDamageMultiplier", "1"},
                    {"M9KDefaultClip", "-1"},
                    {"M9KDisablePenetration", "0"},
                    {"M9KDynamicRecoil", "1"},
                    {"M9KExplosiveNerveGas", "1"},
                    {"M9KUniqueSlots", "1"},
                    {"M9KWeaponStrip", "0"},
                    {"M9K_Davy_Crockett_Timer", "3"},
                    {"mp_allowNPCs", "1"},
                    {"mp_autocrosshair", "1"},
                    {"mp_fadetoblack", "0"},
                    {"mp_falldamage", "0"},
                    {"mp_flashlight", "1"},
                    {"mp_footsteps", "1"},
                    {"mp_forcerespawn", "1"},
                    {"mp_fraglimit", "0"},
                    {"mp_friendlyfire", "0"},
                    {"mp_teamlist", "hgrunt;scientist"},
                    {"mp_teamplay", "0"},
                    {"mp_timelimit", "0"},
                    {"mp_weaponstay", "0"},
                    {"nextlevel", ""},
                    {"OrbitalStrikeAdminOnly", "0"},
                    {"pac_allow_blood_color", "1"},
                    {"pac_submit_limit", "30"},
                    {"pac_submit_spam", "1"},
                    {"physgun_limited", "0"},
                    {"physgun_maxrange", "4096"},
                    {"r_AirboatViewDampenDamp", "1.0"},
                    {"r_AirboatViewDampenFreq", "7.0"},
                    {"r_AirboatViewZHeight", "0.0"},
                    {"r_JeepViewDampenDamp", "1.0"},
                    {"r_JeepViewDampenFreq", "7.0"},
                    {"r_JeepViewZHeight", "10.0"},
                    {"r_VehicleViewDampen", "0"},
                    {"sbox_bonemanip_misc", "0"},
                    {"sbox_bonemanip_npc", "1"},
                    {"sbox_bonemanip_player", "0"},
                    {"sbox_godmode", "0"},
                    {"sbox_maxballoons", "10"},
                    {"sbox_maxbuttons", "20"},
                    {"sbox_maxcameras", "10"},
                    {"sbox_maxdynamite", "2"},
                    {"sbox_maxeffects", "10"},
                    {"sbox_maxemitters", "5"},
                    {"sbox_maxhoverballs", "20"},
                    {"sbox_maxlamps", "10"},
                    {"sbox_maxlights", "50"},
                    {"sbox_maxnpcs", "5"},
                    {"sbox_maxprops", "1000"},
                    {"sbox_maxragdolls", "10"},
                    {"sbox_maxsents", "20"},
                    {"sbox_maxthrusters", "10"},
                    {"sbox_maxvehicles", "30"},
                    {"sbox_maxwheels", "20"},
                    {"sbox_noclip", "0"},
                    {"sbox_persist", ""},
                    {"sbox_playershurtplayers", "1"},
                    {"sbox_weapons", "1"},
                    {"sensor_debugragdoll", "0"},
                    {"sensor_stretchragdoll", "0"},
                    {"sitting_can_damage_players_sitting", "1"},
                    {"sitting_can_sit_on_players", "0"},
                    {"sitting_can_sit_on_player_ent", "0"},
                    {"sitting_ent_mode", "3"},
                    {"stacker_delay", "0.500000"},
                    {"stacker_force_freeze", "0"},
                    {"stacker_force_nocollide", "0"},
                    {"stacker_force_weld", "0"},
                    {"stacker_improved_force_freeze", "0"},
                    {"stacker_improved_force_nocollide", "0"},
                    {"stacker_improved_force_stayinworld", "1"},
                    {"stacker_improved_force_weld", "0"},
                    {"stacker_max_count", "15"},
                    {"stacker_max_offsetx", "200"},
                    {"stacker_max_offsety", "200"},
                    {"stacker_max_offsetz", "200"},
                    {"stacker_max_total", "-1"},
                    {"stacker_stayinworld", "1"},
                    {"sv_accelerate", "10"},
                    {"sv_airaccelerate", "1000"},
                    {"sv_allowcslua", "0"},
                    {"sv_alltalk", "0"},
                    {"sv_bounce", "0"},
                    {"sv_cheats", "0"},
                    {"sv_contact", ""},
                    {"sv_footsteps", "1"},
                    {"sv_friction", "8"},
                    {"sv_gravity", "600"},
                    {"sv_hl2mp_item_respawn_time", "30"},
                    {"sv_hl2mp_weapon_respawn_time", "20"},
                    {"sv_maxspeed", "10000"},
                    {"sv_maxusrcmdprocessticks", "6.00"},
                    {"sv_noclipaccelerate", "5"},
                    {"sv_noclipspeed", "5"},
                    {"sv_password", "0"},
                    {"sv_pausable", "0"},
                    {"sv_report_client_settings", "0"},
                    {"sv_rollangle", "0"},
                    {"sv_rollspeed", "200"},
                    {"sv_specaccelerate", "5"},
                    {"sv_specnoclip", "1"},
                    {"sv_specspeed", "3"},
                    {"sv_steamgroup", ""},
                    {"sv_stepsize", "18"},
                    {"sv_stopspeed", "10"},
                    {"sv_voiceenable", "1"},
                    {"sv_wateraccelerate", "10"},
                    {"sv_waterfriction", "1"},
                    {"toolmode_allow_advdupe2", "1"},
                    {"toolmode_allow_axis", "1"},
                    {"toolmode_allow_balloon", "1"},
                    {"toolmode_allow_ballsocket", "1"},
                    {"toolmode_allow_button", "1"},
                    {"toolmode_allow_camera", "1"},
                    {"toolmode_allow_colour", "1"},
                    {"toolmode_allow_creator", "1"},
                    {"toolmode_allow_duplicator", "1"},
                    {"toolmode_allow_dynamite", "1"},
                    {"toolmode_allow_editentity", "1"},
                    {"toolmode_allow_elastic", "1"},
                    {"toolmode_allow_emitter", "1"},
                    {"toolmode_allow_example", "1"},
                    {"toolmode_allow_eyeposer", "1"},
                    {"toolmode_allow_faceposer", "1"},
                    {"toolmode_allow_fading_door", "1"},
                    {"toolmode_allow_finger", "1"},
                    {"toolmode_allow_gmtp_setup_tool", "1"},
                    {"toolmode_allow_hoverball", "1"},
                    {"toolmode_allow_hydraulic", "1"},
                    {"toolmode_allow_inflator", "1"},
                    {"toolmode_allow_keepupright", "1"},
                    {"toolmode_allow_keypad_willox", "1"},
                    {"toolmode_allow_lamp", "1"},
                    {"toolmode_allow_leafblower", "1"},
                    {"toolmode_allow_light", "1"},
                    {"toolmode_allow_material", "1"},
                    {"toolmode_allow_motor", "1"},
                    {"toolmode_allow_muscle", "1"},
                    {"toolmode_allow_nocollide", "1"},
                    {"toolmode_allow_paint", "1"},
                    {"toolmode_allow_physprop", "1"},
                    {"toolmode_allow_precision", "1"},
                    {"toolmode_allow_pulley", "1"},
                    {"toolmode_allow_remover", "1"},
                    {"toolmode_allow_rope", "1"},
                    {"toolmode_allow_rtcamera", "1"},
                    {"toolmode_allow_shareprops", "1"},
                    {"toolmode_allow_simfphysduplicator", "1"},
                    {"toolmode_allow_simfphyseditor", "1"},
                    {"toolmode_allow_simfphysgeareditor", "1"},
                    {"toolmode_allow_simfphysmiscsoundeditor", "1"},
                    {"toolmode_allow_simfphyssoundeditor", "1"},
                    {"toolmode_allow_simfphyssuspensioneditor", "1"},
                    {"toolmode_allow_simfphyswheeleditor", "1"},
                    {"toolmode_allow_slider", "1"},
                    {"toolmode_allow_stacker_improved", "1"},
                    {"toolmode_allow_submaterial", "1"},
                    {"toolmode_allow_thruster", "1"},
                    {"toolmode_allow_trails", "1"},
                    {"toolmode_allow_vpermaprops_tool", "1"},
                    {"toolmode_allow_vtextscreen", "1"},
                    {"toolmode_allow_weld", "1"},
                    {"toolmode_allow_wheel", "1"},
                    {"toolmode_allow_winch", "1"},
                    {"ttt_allow_discomb_jump", "0"},
                    {"ttt_credits_starting", "2"},
                    {"ttt_debug_preventwin", "0"},
                    {"ttt_detective_hats", "1"},
                    {"ttt_detective_karma_min", "600"},
                    {"ttt_detective_max", "32"},
                    {"ttt_detective_min_players", "8"},
                    {"ttt_detective_pct", "0.125000"},
                    {"ttt_det_credits_starting", "1"},
                    {"ttt_firstpreptime", "60"},
                    {"ttt_haste", "1"},
                    {"ttt_haste_minutes_per_death", "0.500000"},
                    {"ttt_haste_starting_minutes", "5"},
                    {"ttt_namechange_bantime", "10"},
                    {"ttt_namechange_kick", "1"},
                    {"ttt_no_nade_throw_during_prep", "1"},
                    {"ttt_postround_dm", "0"},
                    {"ttt_posttime_seconds", "30"},
                    {"ttt_preptime_seconds", "30"},
                    {"ttt_ragdoll_pinning", "1"},
                    {"ttt_ragdoll_pinning_innocents", "0"},
                    {"ttt_roundtime_minutes", "10"},
                    {"ttt_round_limit", "6"},
                    {"ttt_teleport_telefrags", "1"},
                    {"ttt_time_limit_minutes", "75"},
                    {"ttt_traitor_max", "32"},
                    {"ttt_traitor_pct", "0.250000"},
                    {"tv_enable", "0"},
                    {"tv_password", "0"},
                    {"tv_relaypassword", "0"}
                  ]
                }}
    end
  end
end
