defmodule A2S.MixProject do
  use Mix.Project

  @version "0.4.3"
  @source_url "https://github.com/Moosieus/elixir-a2s"

  def project do
    [
      app: :elixir_a2s,
      version: @version,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      description: "An implementation of Valve's A2S protocol for Elixir.",
      deps: deps(),
      docs: docs(),
      package: package()
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
      {:ex_doc, "~> 0.34.1", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      name: "Elixir A2S",
      main: "readme",
      source_ref: "main",
      source_url: @source_url,
      extras: [
        "README.md",
        "pages/using-a2s-directly.md",
        "notebooks/passive_example.livemd"
      ],
      assets: %{"pages/assets" => "assets"},
      groups_for_extras: [
        Guides: [
          "pages/using-a2s-directly.md"
        ],
        Livebooks: [
          "notebooks/passive_example.livemd"
        ]
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
        ]
      ],
      before_closing_head_tag: &before_closing_head_tag/1
    ]
  end

  defp before_closing_head_tag(:html) do
    """
    <style>
      .dark img[src$=".svg"] {
        filter: invert(93%) hue-rotate(180deg);
      }
    </style>
    """
  end

  defp before_closing_head_tag(:epub), do: ""

  defp package do
    [
      name: "elixir_a2s",
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
