defmodule A2STest do
  use ExUnit.Case, async: true

  test "parse Hell Let Loose info response" do
    {:ok, info_packet} = File.read("test/samples/hll_info.bin")

    resp = A2S.parse_response(info_packet)

    assert resp === {:info, %A2S.Info{
      protocol: 17,
      name: "Glow's Battlegrounds :: Event Server :: discord.gg/glows",
      map: "SME",
      folder: "hlldir",
      game: "Hell Let Loose",
      appid: 0, # expected behavior for HLL
      players: 91,
      max_players: 100,
      bots: 0,
      server_type: :dedicated,
      environment: :windows,
      visibility: :private,
      vac: :secured,
      version: "0.1.1.0",
      gameport: 7777,
      steamid: 90175710618294273,
      spectator_port: nil,
      spectator_name: nil,
      keywords: "GS:Ij1rHvaoS722kYAG,CONMETHOD:P2P,P2PADDR:90175710618294273,P2PPORT:7777,SESSIONFLAGS:171,VISIB_i:0",
      gameid: 686810
    }}
  end

  test "parse Squad info response" do
    {:ok, info_packet} = File.read("test/samples/squad_info.bin")

    resp = A2S.parse_response(info_packet)

    assert resp === {:info, %A2S.Info{
      protocol: 17,
      name: "The Potato Fields 1 | New Player Friendly",
      map: "Lashkar_AAS_v2",
      folder: "squad",
      game: "Squad",
      appid: 0, # expected for Squad (common to UE4?)
      players: 99,
      max_players: 100,
      bots: 0,
      server_type: :dedicated,
      environment: :linux,
      visibility: :public,
      vac: :unsecured,
      version: "dev",
      gameport: 10250,
      steamid: 90175629439555585,
      spectator_port: nil,
      spectator_name: nil,
      keywords: "BUILDID:155155,OWNINGID:90175629439555585,OWNINGNAME:The Potato Fields 1 | New Player Friendly,NUMOPENPRIVCONN:2,NUMPUBCONN:98",
      gameid: 393380
    }}
  end
end
