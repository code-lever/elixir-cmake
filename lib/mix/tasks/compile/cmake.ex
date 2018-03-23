defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc "Builds native source using CMake"
  use Mix.Task

  @default_cmakelists_path ".."
  @default_make_target "all"
  @default_working_dir "_cmake"

  @doc """
  Runs this task.
  """
  def run(_args) do
    :ok = File.mkdir_p(@default_working_dir)
    cmd("cmake", [@default_cmakelists_path])
    cmd("make", [@default_make_target])
    :ok
  end

  @doc """
  Removes compiled artifacts.
  """
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
