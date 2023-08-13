# Elixir A2S

A library for communicating with game servers running [Valve's A2S server query protocol](https://developer.valvesoftware.com/wiki/Server_queries).

## Installation
Add `:elixir_a2s` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_a2s, "~> 0.3.3"}
  ]
end
```

Documentation is available on [HexDocs](https://hexdocs.pm/elixir_a2s/readme.html) and may also be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).

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

See [Using A2S Directly](pages/using-a2s-directly.md) guide for further details.

## Configuration
The following configuration options are available for `A2S.Client`:

`:name` - Required, used as the `name` of the top-level supervisor for `A2S.Client`

`:port` - Port on which to open the UDP socket for communicating with game servers. Defaults to `20850`.

`:idle_timeout` - Under the hood, `A2S.Client` spins up one `:gen_statem` processes per address queried. These serve two purposes - to handle all the hand-shaking and packet wrangling necessary to complete A2S queries, and to ensure queries are executed sequentially. After an address hasn't been queried for an extended period, these processes should terminate to free their memory. Defaults to `120_000` (2 minutes, expressed in milliseconds).

`:recv_timeout` - Deadline to receive a response packet for each packet sent in the query sequence. Defaults to `3000` (3 seconds, expressed in milliseconds).

## Unsupported Games/Features
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
