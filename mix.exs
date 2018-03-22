defmodule ElixirCmake.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_cmake,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/code-lever/elixir-cmake",
      homepage_url: "https://github.com/code-lever/elixir-cmake",
      deps: deps()
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
    ]
  end
end
