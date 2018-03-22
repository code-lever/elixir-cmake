# CMake compiler for Mix

[![Hex Version](https://img.shields.io/hexpm/v/elixir_cmake.svg "Hex Version")](https://hex.pm/packages/elixir_cmake)

A CMake compiler to help building Ports/NIFs in your Elixir/mix project.

## Installation

Add `elixir_cmake` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_cmake, "~> 0.1.0"}
  ]
end
```

Add `:cmake` to your compilers in `mix.exs`:

```elixir
def project do
  [
    # ...
    compilers: [:cmake] ++ Mix.compilers(),
    # ...
  ]
end
```

## Basic Usage

    TODO

## Configuration Options

    TODO

Be sure to read [the documentation too](http://hexdocs.pm/elixir_cmake).
