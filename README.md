# Elixir A2S
A library for communicating with game servers running [Valve's A2S server query protocol](https://developer.valvesoftware.com/wiki/Server_queries).

## Installation
Add `:elixir_a2s` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_a2s, "~> 0.4.1"}
  ]
end
```

Documentation is available on [HexDocs](https://hexdocs.pm/elixir_a2s/readme.html) and may also be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

## Usage
There's two general ways to use this library:

### `A2S.Client`
An easy to use client that should cover most use cases.

Add `A2S.Client` to your app's supervision tree:
```elixir
children = [
  {A2S.Client, []}
]
```
Or start the client dynamically: 
```elixir
A2S.Client.start_link()
```

Afterwards, querying a game server's as simple as:
```elixir
A2S.Client.query(:info, {{127, 0, 0, 1}, 20000}) # ipv4 address followed by the query port
```

#### Notes:
* `A2S.Client` assumes a singleton pattern by default.

* For configuring multiple instances, see `A2S.Client.start_link/1` and `A2S.Client.query/3`.

### `A2S`
This module provides functions form requests, sign challenges, and parse responses for the A2S protocol. You can utilize this module directly in your application for tighter integration, but in turn you'll have to roll your own packet assembly. See [Using A2S Directly](pages/using-a2s-directly.md) guide for further details.

## Unsupported games and features

#### [Source 2006](https://en.wikipedia.org/wiki/Source_(game_engine)#Source_2006) (aka "Pre-Orange Box") servers
Most source games are running on newer versions of the engine.

#### GoldSrc servers not using the standard protocol
Many GoldSrc servers use the current standard, so this should impact few games.

#### [The Ship](https://steamcharts.com/app/2400)
Uses proprietary fields only worth supporting for posterity-sake.

#### [A2A_PING](https://developer.valvesoftware.com/wiki/Server_queries#A2A_PING)
Considered deprecated by Valve and is unsupported by almost all most games.

#### [A2S_SERVERQUERY_GETCHALLENGE](https://developer.valvesoftware.com/wiki/Server_queries#A2S_SERVERQUERY_GETCHALLENGE)
Only used by a handful of niche games, and the normal challenge flow should work anyway.

## Debugging
By default [Elixir will ignore `:gen_statem` crashes](https://elixirforum.com/t/why-does-logger-translator-ignore-gen-statem-reports/37418). To receive them, add the following to your application:
```elixir
Logger.add_translator({A2S.StateMachineTranslator, :translate})
```
