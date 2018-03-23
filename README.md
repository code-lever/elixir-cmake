# CMake compiler for Mix

[![Build Status](https://api.travis-ci.org/code-lever/elixir-cmake.svg)](https://travis-ci.org/code-lever/elixir-cmake)
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

### CMakeLists.txt

Create your CMakeLists.txt in the root of your project.  The source files can reside anywhere
the CMakeLists.txt file has access to.  Direct the binary output to `priv/`.  A project named
`EXAMPLE`, with source files in `src/`:

```cmake
cmake_minimum_required(VERSION 3.0)
project(EXAMPLE)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/priv)
file(GLOB EXAMPLE_SRC src/*.c)

SET (CMAKE_C_FLAGS "-g -O3 -pedantic -Wall -Wextra -Wno-unused-parameter -std=c99")

include_directories(SYSTEM)

add_executable(example ${EXAMPLE_SRC})
```

Run `mix compile` (or `mix compile.cmake` for just the CMake build) and you should find a compiled
binary in `priv/` afterwards.

## Configuration Options

    TODO

Be sure to read [the documentation too](http://hexdocs.pm/elixir_cmake).
