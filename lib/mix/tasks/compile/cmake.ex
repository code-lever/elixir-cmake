defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc "Builds native source using CMake"
  use Mix.Task

  def run(_) do
    :ok = File.mkdir_p("_cmake")
    {result, _} = System.cmd("cmake", [".."], cd: "_cmake", stderr_to_stdout: true)
    Mix.shell().info(result)
    {result, _} = System.cmd("make", ["all"], cd: "_cmake", stderr_to_stdout: true)
    Mix.shell().info(result)
    :ok
  end

  def clean() do
    {result, _} = System.cmd("make", ["clean"], cd: "_cmake", stderr_to_stdout: true)
    Mix.shell().info(result)
    :ok
  end
end
