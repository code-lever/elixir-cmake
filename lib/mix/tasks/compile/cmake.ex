defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc "Builds native source using CMake"
  use Mix.Task

  @default_cmakelists_path ".."
  @default_make_target "all"
  @default_working_dir "cmake"

  @doc """
  Runs this task.
  """
  def run(_args) do
    config = Mix.Project.config()

    working_dir = working_dir(config)
    :ok = File.mkdir_p(working_dir)
    cmd("cmake", [cmake_list], working_dir)
    cmd("make", make_targets, working_dir)
    Mix.Project.build_structure()
    :ok
  end

  @doc """
  Removes compiled artifacts.
  """
  def clean() do
    working_dir =
      Mix.Project.config()
      |> working_dir()

    cmd("make", ["clean"], working_dir)
    :ok
  end

  defp cmd(exec, args, dir) do
    case System.cmd(exec, args, cd: dir, stderr_to_stdout: true) do
      {result, 0} ->
        Mix.shell().info(result)
        :ok

      {result, status} ->
        Mix.raise("Failure running '#{exec}' (status: #{status}).\n#{result}")
    end
  end

  defp working_dir(config) do
    config
    |> Mix.Project.build_path()
    |> Path.join(@default_working_dir)
  end
end
