# A2S

<!-- MDOC !-->

A library for communicating with game servers running [Valve's A2S server query protocol](https://developer.valvesoftware.com/wiki/Server_queries).

## Installation

The package can be installed by adding `a2s` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:a2s, "~> 0.2.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc) and published on [HexDocs](https://hexdocs.pm/elixir_a2s/readme.html).

## Usage
There's two general ways to use this library:

### Via `A2S.Client`

An easy to use client that should cover most use-cases. Add `A2S.Client` to your app's supervision tree:
```Elixir
children = [
  {A2S.Client, [name: MyA2SCli]}
]
```
Or start the client dynamically: 
```Elixir
A2S.Client.start_link([name: MyA2SCli])
```

Afterwards querying a game server's as simple as:
```Elixir
A2S.Client.query(:info, {{127, 0, 0, 1}, 20000}) # ipv4 address followed by port
```

### Via `A2S`
This module provides the means form requests, sign challenges, and parse responses for the A2S protocol. You can utilize this module directly in your application for tighter integration, but in turn you'll have to handle the networking or handshaking necessary to execute A2S queries.

See the [roll your own](pages/roll-your-own.md) guide and the internals of `A2S.Client` may serve as a good reference in that regard.

## Unsupported Games and Features
The features and game servers listed below are unsupported due to disuse and to favor maintainability.

#### [Source 2006](https://en.wikipedia.org/wiki/Source_(game_engine)#Source_2006) / "Pre-Orange Box" servers
Would require supporting compression in multipacket responses. Not only adds code complexity, but would require users to have bzip2 installed.

#### Other game servers utilizing multi-packet compression
(see above)

#### GoldSrc Servers not using the standard protocol
Should impact exceedingly few applications as many GoldSrc servers use the current standard anyway.

#### [The Ship](https://steamcharts.com/app/2400)
Uses proprietary fields only worth supporting out of posterity-sake.

#### [A2A_PING](https://developer.valvesoftware.com/wiki/Server_queries#A2A_PING)
Considered deprecated by Valve and is unsupported by many if not almost all most engines.

#### [A2S_SERVERQUERY_GETCHALLENGE](https://developer.valvesoftware.com/wiki/Server_queries#A2S_SERVERQUERY_GETCHALLENGE)
Only used by a handful of niche games. Normal challenge flow should work anyway.

## Issues
If you'd like to report an issue, please include as much information as possible to reproduce the issue.

## Debugging
`A2S.Client` uses Erlang's [gen_statem](https://www.erlang.org/doc/man/gen_statem.html) behavior to function and therefore requires the following `Logger` configuration to report exceptions and crashes:

```Elixir
config :logger,
  handle_otp_reports: true,
  handle_sasl_reports: true
```
or in a REPL:
```Elixir
Logger.configure(handle_otp_reports: true)
Logger.configure(handle_sasl_reports: true)
```

<!-- MDOC !-->

## (Much) Todo:
- Make statem timeouts configurable
- Fix `A2S.DynamicSupervisor` startup arguments (currently ignored)
- Fix Registry static name of `:a2s_registry`
- Add table-driven unit tests for the `A2S` module
- Add concurrency-driven tests for `A2S.Client`
- Internals guide/design motivations/roll-your-own
- Addc more typespecs and document startup opts
