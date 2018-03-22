defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc "Builds native source using CMake"
  use Mix.Task

  @default_working_dir "_cmake"

  def run(_) do
    :ok = File.mkdir_p(@default_working_dir)
    cmd("cmake", [".."])
    cmd("make", ["all"])
    :ok
  end

  def clean() do
    cmd("make", ["clean"])
    :ok
  end

  defp cmd(exec, args, dir \\ @default_working_dir) do
    case System.cmd(exec, args, cd: dir, stderr_to_stdout: true) do
      {result, 0} ->
        Mix.shell().info(result)
        :ok

      {result, status} ->
        Mix.raise("Failure running '#{exec}' (status: #{status}).\n#{result}")
    end
  end
end
