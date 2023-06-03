defmodule A2S.MixProject do
  use Mix.Project

  def project do
    [
      app: :a2s,
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: "An implementation of Valve's A2S protocol for Elixir.",
      deps: deps(),
      docs: docs(), # TODO: Do better documentation. Give HexDocs first class parity with hexdocs
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      name: "Elixir_A2S",
      main: "readme",
      source_ref: "main",
      source_url: "https://github.com/Moosieus/elixir-a2s",
      extras: [
        "README.md"
      ],
      groups_for_modules: [
        "Developer Interface": [
          A2S.Client,
          A2S
        ],
        "Response Types": [
          A2S.Info,
          A2S.Players,
          A2S.Rules,
          A2S.Player,
          A2S.Rule,
          A2S.MultiPacketHeader
        ],
        "Client Internals": [
          A2S.Supervisor, A2S.Statem, A2S.UDP
        ]
      ],
    ]
  end

  defp package do
    [
      name: "elixir_a2s",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Moosieus/elixir-a2s"}
    ]
  end
end
