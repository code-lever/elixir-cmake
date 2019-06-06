defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc "Builds native source using CMake"
  use Mix.Task.Compiler

  @cmake_binaries "_cmake"

  @switches [
    verbose: :boolean
  ]

  @doc """
  Runs this task.
  """
  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: @switches)

    project = Mix.Project.config()

    opts = Keyword.merge(project[:cmake_options] || [], opts)

    generator = if(name = Keyword.get(opts, :generator), do: ["-G", name], else: [])
    defs = get_defs(opts)
    envs = get_envs(opts)

    # generate
    {result, _} = System.cmd("cmake", generator ++ defs ++ ["-B", "_cmake", "."], env: envs, stderr_to_stdout: true)
    Mix.shell().info(result)
    
    # build
    {result, _} = cmake_build(:install, stderr_to_stdout: true)
    #Mix.shell().info(result)
    :ok
  end
  
  def clean() do
    {result, _} = cmake_build(:clean, stderr_to_stdout: true)
    #Mix.shell().info(result)
    :ok
  end
  
  defp cmake_build(target, opts \\ []) do
    System.cmd("cmake", ["--build", "_cmake", "--target", Atom.to_string(target)], opts)
  end

  defp get_defs(keywords) do
    Keyword.get(keywords, :define, [])
    |> Enum.map(fn {name, val} -> "-D#{Atom.to_string(name)}=#{val}" end)
  end

  defp get_envs(keywords) do
    Keyword.get(keywords, :env, [])
    |> Enum.map(fn {name, val} -> {Atom.to_string(name), val} end)
  end
end
