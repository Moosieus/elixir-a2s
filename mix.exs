defmodule A2S.MixProject do
  use Mix.Project

  def project do
    [
      app: :a2s,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Elixir_A2S",
      source_url: "https://github.com/Moosieus/elixir-a2s"
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

  defp description do
    "An implementation of Valve's A2S protocol for Elixir."
  end

  defp package do
    [
      name: "elixir_a2s",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Moosieus/elixir-a2s"}
    ]
  end
end
