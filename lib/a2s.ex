defmodule A2S.ParseError do
  # This is basically a log that says more than just (MatchError) to be repl'd
  # later. Can't do much to remediate invalid data and more defensive errors
  # could mislead here.

  defexception response_type: nil, data: <<>>

  def message(%__MODULE__{response_type: rt}) do
    "Invalid data in #{rt} response"
  end
end

defmodule A2S do
  @moduledoc """
  A set of process-less functions for forming A2S challenges, requests, and parsing responses.
  """

  ## Type Definitions

  defmodule Info do
    @moduledoc """
    Struct representing an [A2S_INFO](https://developer.valvesoftware.com/wiki/Server_queries#Response_Format) response.
    """
    defstruct [
      :protocol,
      :name,
      :map,
      :folder,
      :game,
      :appid,
      :players,
      :max_players,
      :bots,
      :server_type,
      :environment,
      :visibility,
      :vac,
      :version,
      # Extra Data Fields (Not guaranteed)
      :gameport,
      :steamid,
      :spectator_port,
      :spectator_name,
      :keywords,
      :gameid
    ]

    @type t :: %Info{
            protocol: byte,
            name: String.t(),
            map: String.t(),
            folder: String.t(),
            game: String.t(),
            appid: integer,
            players: byte,
            max_players: byte,
            bots: byte,
            server_type: :dedicated | :non_dedicated | :proxy | :unknown,
            environment: :linux | :windows | :mac | :unknown,
            visibility: :public | :private,
            vac: :secured | :unsecured | :unknown,
            # Extra Data Fields
            gameport: :inet.port_number() | nil,
            steamid: integer | nil,
            spectator_port: :inet.port_number() | nil,
            spectator_name: String.t() | nil,
            keywords: String.t() | nil,
            gameid: integer | nil
          }
  end

  defmodule Players do
    @moduledoc """
    Struct representing an [A2S_PLAYER](https://developer.valvesoftware.com/wiki/Server_queries#Response_Format_2) response.
    """
    defstruct [
      :count,
      :players
    ]

    @type t :: %Players{
            count: byte,
            players: list(A2S.Player.t())
          }
  end

  defmodule Player do
    @moduledoc """
    Struct representing a player entry in an [A2S_PLAYER](https://developer.valvesoftware.com/wiki/Server_queries#Response_Format_2) response.
    """
    defstruct [
      :index,
      :name,
      :score,
      :duration
    ]

    @type t :: %Player{
            index: integer,
            name: String.t(),
            score: integer,
            duration: float
          }
  end

  defmodule Rules do
    @moduledoc """
    Struct representing an [A2S_RULES](https://developer.valvesoftware.com/wiki/Server_queries#Response_Format_3) response.
    """
    defstruct [
      :count,
      :rules
    ]

    @type t :: %Rules{
            count: byte,
            rules: list(A2S.Rule.t())
          }
  end

  defmodule Rule do
    @moduledoc """
    Struct representing a rule in an [A2S_RULES](https://developer.valvesoftware.com/wiki/Server_queries#Response_Format_3) response.
    """
    defstruct [
      :name,
      :value
    ]

    @type t :: %Rule{
            name: String.t(),
            value: String.t()
          }
  end

  defmodule MultiPacketHeader do
    @moduledoc """
    Struct representing a [multi-packet response header](https://developer.valvesoftware.com/wiki/Server_queries#Multi-packet_Response_Format).
    """
    defstruct [
      :id,
      :total,
      :index,
      :size
    ]

    @type t :: %MultiPacketHeader{
            id: integer,
            total: byte,
            index: byte,
            size: integer
          }
  end

  ## Constants

  @queries [:info, :players, :rules]

  # <<0xFF, 0xFF, 0xFF, 0xFF>>
  @simple_header <<-1::signed-32-little>>

  # <<0xFF, 0xFF, 0xFF, 0xFE>> (primarily for A2S_RULES)
  @multipacket_header <<-2::signed-32-little>>

  # 0x41
  @challenge_response_header ?A

  # 0x54 / 0x49
  @info_request_header ?T
  @info_response_header ?I

  # 0x55 / 0x44
  @player_request_header ?U
  @player_response_header ?D

  # 0x56 / 0x45
  @rules_challenge_header ?V
  @rules_response_header ?E

  ## Module API

  @doc """
  Returns the challenge request packet for the given query type.
  """
  @spec challenge_request(:info | :players | :rules) :: binary()
  def challenge_request(:info) do
    <<@simple_header, @info_request_header, "Source Engine Query\0">>
  end

  def challenge_request(:players) do
    <<@simple_header, @player_request_header, -1::signed-32-little>>
  end

  def challenge_request(:rules) do
    <<@simple_header, @rules_challenge_header, -1::signed-32-little>>
  end

  def challenge_request(term) do
    raise ArgumentError, """
    Unknown A2S query #{inspect(term)}, expected one of #{inspect(@queries)}.
    """
  end

  @doc """
  Parses a challenge response payload. Some game servers don't implement the challenge flow and will
  immediately respond with the requested data. In that case `:immediate` will be returned with the data.

  If the server returns data immediately, and that data is multipacket, `:multipacket` will be returned.
  """
  @spec parse_challenge(binary()) ::
          {:challenge, binary()}
          | {:immediate, {:info, Info.t()} | {:players, Players.t()} | {:rules, Rules.t()}}
          | {:multipacket, {MultiPacketHeader.t(), binary()}}
          | {:error, {:unknown_packet_header, binary()} | :compression_not_supported}

  def parse_challenge(<<@simple_header, @challenge_response_header, challenge::binary>>) do
    {:challenge, challenge}
  end

  def parse_challenge(<<@simple_header, _::bytes>> = data) do
    {:immediate, parse_response(data)}
  end

  def parse_challenge(<<@multipacket_header, _::bytes>> = data) do
    {:immediate, parse_response(data)}
  end

  def parse_challenge(packet) when is_binary(packet) do
    {:error, {:unknown_packet_header, packet}}
  end

  @spec parse_challenge!(binary()) ::
          {:challenge, binary()}
          | {:immediate,
             {:info, A2S.Info.t()} | {:players, A2S.Players.t()} | {:rules, A2S.Rules.t()}}
          | {:multipacket, {A2S.MultiPacketHeader.t(), binary()}}
  def parse_challenge!(packet) do
    case parse_challenge(packet) do
      {:error, error} -> raise error
      result -> result
    end
  end

  @spec sign_challenge(:info | :players | :rules, challenge :: binary()) :: binary()
  def sign_challenge(:info, challenge) when is_binary(challenge) do
    <<@simple_header, @info_request_header, "Source Engine Query\0", challenge::binary>>
  end

  def sign_challenge(:players, challenge) when is_binary(challenge) do
    <<@simple_header, @player_request_header, challenge::binary>>
  end

  def sign_challenge(:rules, challenge) when is_binary(challenge) do
    <<@simple_header, @rules_challenge_header, challenge::binary>>
  end

  def sign_challenge(term, _challenge) when term not in @queries do
    raise ArgumentError, """
    Unknown A2S query #{inspect(term)}, expected one of #{inspect(@queries)}.
    """
  end

  @spec parse_response(binary()) ::
          {:info, Info.t()}
          | {:players, Player.t()}
          | {:rules, Rules.t()}
          | {:multipacket, {MultiPacketHeader.t(), binary()}}
          | {:error, :compression_not_supported}

  def parse_response(<<@simple_header, type_header::8, payload::bytes>> = data) do
    {query_type, parse_fn} =
      case type_header do
        @info_response_header -> {:info, &parse_info_payload/1}
        @player_response_header -> {:players, &parse_player_payload/1}
        @rules_response_header -> {:rules, &parse_rules_payload/1}
      end

    try do
      {query_type, parse_fn.(payload)}
    rescue
      _ -> {:error, %A2S.ParseError{response_type: query_type, data: data}}
    end
  end

  def parse_response(<<@multipacket_header, payload::bytes>> = data) do
    try do
      case parse_multipacket_part(payload) do
        {:ok, part} -> {:multipacket, part}
        {:error, reason} -> {:error, reason}
      end
    rescue
      _ -> {:error, %A2S.ParseError{response_type: :multipacket_part, data: data}}
    end
  end

  def parse_response(packet) when is_binary(packet) do
    {:error, {:unknown_packet_header, packet}}
  end

  @spec parse_response!(binary()) ::
          {:info, Info.t()}
          | {:players, Player.t()}
          | {:rules, Rules.t()}
          | {:multipacket, {MultiPacketHeader.t(), binary()}}

  def parse_response!(packet) when is_binary(packet) do
    case parse_response(packet) do
      {:error, error} -> raise error
      result -> result
    end
  end

  @spec parse_multipacket_response(list({MultiPacketHeader.t(), binary()})) ::
          {:info, Info.t()}
          | {:players, Player.t()}
          | {:rules, Rules.t()}
          | {:error, any}
  def parse_multipacket_response(packets) when is_list(packets) do
    packets
    |> sort_multipacket()
    |> glue_packets()
    |> parse_response()
  end

  @spec parse_multipacket_response!(list({MultiPacketHeader.t(), binary()})) ::
          {:info, Info.t()}
          | {:players, Player.t()}
          | {:rules, Rules.t()}
  def parse_multipacket_response!(packets) when is_list(packets) do
    case parse_multipacket_response(packets) do
      {:error, reason} -> raise reason
      result -> result
    end
  end

  ## A2S_INFO Parsing

  @spec parse_info_payload(binary) :: Info.t()
  def parse_info_payload(data) when is_binary(data) do
    <<protocol::8, data::bytes>> = data

    {name, data} = read_null_term_string(data)
    {map, data} = read_null_term_string(data)
    {folder, data} = read_null_term_string(data)
    {game, data} = read_null_term_string(data)

    <<
      id::16,
      players::8,
      max_players::8,
      bots::8,
      server_type::8,
      environment::8,
      visibility::8,
      vac::8,
      data::bytes
    >> = data

    {version, data} = read_null_term_string(data)

    {gameport, steamid, spectator_port, spectator_name, keywords, gameid} = parse_edf(data)

    %Info{
      protocol: protocol,
      name: name,
      map: map,
      folder: folder,
      game: game,
      appid: id,
      players: players,
      max_players: max_players,
      bots: bots,
      server_type: parse_server_type(server_type),
      environment: parse_environment(environment),
      visibility: parse_visibility(visibility),
      vac: parse_vac(vac),
      version: version,
      gameport: gameport,
      steamid: steamid,
      spectator_port: spectator_port,
      spectator_name: spectator_name,
      keywords: keywords,
      gameid: gameid
    }
  end

  defp parse_server_type(t) do
    case t do
      ?d -> :dedicated
      ?l -> :non_dedicated
      ?p -> :proxy
      _ -> :unknown
    end
  end

  defp parse_environment(e) do
    case e do
      ?l -> :linux
      ?w -> :windows
      ?m -> :mac
      ?o -> :mac
      _ -> :unknown
    end
  end

  defp parse_visibility(v) do
    case v do
      0 -> :public
      1 -> :private
      _ -> :unknown
    end
  end

  defp parse_vac(0), do: :unsecured
  defp parse_vac(1), do: :secured
  defp parse_vac(_), do: :unknown

  defp parse_edf(<<>>), do: %{}

  defp parse_edf(<<edf::8, data::bytes>>) do
    import Bitwise, only: [&&&: 2]

    {gameport, data} =
      if (edf &&& 0x80) !== 0 do
        <<gameport::16-little, data::bytes>> = data
        {gameport, data}
      else
        {nil, data}
      end

    {steamid, data} =
      if (edf &&& 0x10) !== 0 do
        <<steamid::signed-64-little, data::bytes>> = data
        {steamid, data}
      else
        {nil, data}
      end

    {spec_port, spec_name, data} =
      if (edf &&& 0x40) !== 0 do
        <<port::signed-16-little, data::bytes>> = data
        {name, data} = read_null_term_string(data)
        {port, name, data}
      else
        {nil, nil, data}
      end

    {keywords, data} =
      if (edf &&& 0x20) !== 0 do
        read_null_term_string(data)
      else
        {nil, data}
      end

    gameid =
      if (edf &&& 0x01) !== 0 do
        <<gameid::signed-64-little>> = data
        gameid
      else
        nil
      end

    {gameport, steamid, spec_port, spec_name, keywords, gameid}
  end

  ## A2S_PLAYER Parsing

  @spec parse_player_payload(binary()) :: Players.t()
  defp parse_player_payload(<<count::unsigned-8, data::bytes>>) do
    %Players{
      count: count,
      players: read_players(data)
    }
  end

  @spec read_players(binary()) :: list(Player.t())
  defp read_players(data, players \\ [])
  defp read_players(<<>>, players), do: Enum.reverse(players)

  defp read_players(data, players) do
    <<index::unsigned-8, data::bytes>> = data
    {name, data} = read_null_term_string(data)
    <<score::signed-32-little, data::bytes>> = data
    <<duration::float-32-little, data::bytes>> = data

    player = %Player{
      index: index,
      name: name,
      score: score,
      duration: duration
    }

    read_players(data, [player | players])
  end

  ## A2S_RULES Parsing

  @spec parse_rules_payload(payload :: binary()) :: Rules.t()
  defp parse_rules_payload(<<count::signed-16-little, data::bytes>>) do
    %Rules{
      count: count,
      rules: read_rules(data)
    }
  end

  @spec read_rules(binary()) :: list(Rule.t())
  defp read_rules(data, rules \\ [])
  defp read_rules(<<>>, rules), do: Enum.reverse(rules)

  defp read_rules(data, rules) do
    {name, data} = read_null_term_string(data)
    {value, data} = read_null_term_string(data)

    rule = %Rule{
      name: name,
      value: value
    }

    read_rules(data, [rule | rules])
  end

  @spec parse_multipacket_part(packet :: binary()) ::
          {:ok, {MultiPacketHeader.t(), binary()}}
          | {:error, :compression_not_supported}

  # compressed first packet (not supported) (upgrade this into an exception that provides a full explanation)
  defp parse_multipacket_part(<<1::1-integer, _::bits>>) do
    {:error, :compression_not_supported}
  end

  # first packet, uncompressed (supported)
  defp parse_multipacket_part(<<
         0::1-integer,
         id::signed-31-little,
         total::unsigned-8,
         0::unsigned-8,
         size::signed-16-little,
         rest::bytes
       >>) do
    {:ok, {%MultiPacketHeader{id: id, total: total, index: 0, size: size}, rest}}
  end

  # other packets
  defp parse_multipacket_part(<<
         id::signed-32-little,
         total::unsigned-8,
         index::unsigned-8,
         size::signed-16-little,
         rest::bytes
       >>) do
    {:ok, {%MultiPacketHeader{id: id, total: total, index: index, size: size}, rest}}
  end

  defp parse_multipacket_part(_), do: raise("bad multipacket part")

  ## Helper functions

  # Accumulates bytes from data to the next null terminator returning the resulting string and remainder.
  defp read_null_term_string(data, str \\ [])
  defp read_null_term_string(<<0, rest::bytes>>, str) do
    {str |> IO.iodata_to_binary |> String.replace_invalid(), rest}
  end

  defp read_null_term_string(<<char::8, rest::bytes>>, str) do
    read_null_term_string(rest, [str, char])
  end

  defp glue_packets(packets, acc \\ [])
  defp glue_packets([], acc), do: IO.iodata_to_binary(acc)

  defp glue_packets([{_multipacket_header, payload} | tail], acc) do
    glue_packets(tail, [acc | payload])
  end

  defp sort_multipacket(collected),
    do: Enum.sort(collected, fn {%{index: a}, _}, {%{index: b}, _} -> a < b end)
end
