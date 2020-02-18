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

Create your CMakeLists.txt in the root of your project or specify the path to an
existing CMakeLists.txt file in your project config.

```elixir
def project do
  [
    # ...
    cmake_lists: "path/to/CMakeLists.txt",
    # ...
  ]
end
```

The source files can reside anywhere the CMakeLists.txt file has access to.

You will need to copy the contents to your `priv` directory by either specifying
a compile alias or by directing the binary output to `priv/` in your CMakeLists.txt.
file.

In this example we specify a project named`EXAMPLE`, with source files in `src/`:

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
