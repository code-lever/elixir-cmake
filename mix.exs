defmodule ElixirCmake.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_cmake,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env() == :prod,
      source_url: "https://github.com/code-lever/elixir-cmake",
      homepage_url: "https://github.com/code-lever/elixir-cmake",
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
    ]
  end
end
