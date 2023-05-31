# A2S

A library for communicating with game servers running [Valve's A2S server query protocol](https://developer.valvesoftware.com/wiki/Server_queries).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `a2s` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:a2s, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/a2s>.

## Usage
There's two general ways to use this library:

### Via `A2S.Client`

This module's intended as an easy to use client that should cover most use-cases. To start, either add `A2S.Client` to your app's supervision tree:
```Elixir
children = [
  {A2S.Client, [name: MyA2SCli]}
]
```
If you'd like to start the client dynamically or in a REPL: 
```Elixir
A2S.Client.start_link([name: MyA2SCli])
```

Once started, querying a gameserver's as simple as:
```Elixir
A2S.Client.query(:info, {{127, 0, 0, 1}, 20000}) # address followed by port
```

### Via `A2S`
This module provides the means form request payloads, solve challenges, and parse responses for the A2S protocol. **It doesn't** handle the networking or handshaking necessary to execute A2S queries.

If you'd like to roll your own networking you can call this module directly. (Todo: Explain caveats)

## Unsupported Games and Features
The features and game servers listed below are unsupported due to disuse and to favor maintainability.

### [Source 2006](https://en.wikipedia.org/wiki/Source_(game_engine)#Source_2006) / "Pre-Orange Box" servers
Would require supporting compression in multipacket responses. Not only adds code complexity, but would require users to have bzip2 installed.

### Other game servers utilizing multi-packet compression
(see above)

### GoldSrc Servers not using the standard protocol
Should impact exceedingly few applications as many GoldSrc servers use the current standard anyway.

### [The Ship](https://steamcharts.com/app/2400)
Uses proprietary fields only worth supporting out of posterity-sake.

### [A2A_PING](https://developer.valvesoftware.com/wiki/Server_queries#A2A_PING)
Considered deprecated by Valve and is unsupported by many if not almost all most engines.

### [A2S_SERVERQUERY_GETCHALLENGE](https://developer.valvesoftware.com/wiki/Server_queries#A2S_SERVERQUERY_GETCHALLENGE)
Only used by a handful of niche games. Normal challenge flow should work anyway.

## Issues
If you'd like to report an issue, please include as much information as possible to reproduce the issue.

## Debugging
`A2S.Client` uses Erlang's [gen_statem](https://www.erlang.org/doc/man/gen_statem.html) behavior to function, and therefore requires the following Logger configuration to report exceptions and crashes:

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

## (Much) Todo:
- Make statem timeouts configurable
- Fix `A2S.Supervisor` startup arguments (currently ignored)
- Fix Registry static name of `:a2s_registry`
- Implement hexdocs, review moduledocs, and readme
  - Explain internals of A2S, design motivations for this library, and a roll-your-own guide.
- Write proper tests
- Test with significant concurrent usage
- Add more typespecs (maybe)
