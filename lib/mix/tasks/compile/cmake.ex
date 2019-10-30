defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc """
  Builds native source using CMake
  Runs `cmake` in the current project (followed by `make`) .

  This task runs `cmake` in the current project; any output coming from `cmake` is
  printed in real-time on stdout.

  ## Configuration

  This compiler can be configured through the return value of the `project/0`
  function in `mix.exs`; for example:
      def project() do
        [
          # ...
          compilers: [:cmake] ++ Mix.compilers,
          # ...
        ]
      end

   The following options are available:
    * `:cmake_env` - (map of binary to binary) it's a map of extra environment
      variables to be passed to `cmake`. You can also pass a function in here in
      case `make_env` needs access to things that are not available during project
      setup; the function should return a map of binary to binary. Many default
      environment variables are set, see section below

  ## Default environment variables
  There are also several default environment variables set:
    * `MIX_TARGET`
    * `MIX_ENV`
    * `MIX_BUILD_PATH` - same as `Mix.Project.build_path/0`
    * `MIX_APP_PATH` - same as `Mix.Project.app_path/0`
    * `MIX_COMPILE_PATH` - same as `Mix.Project.compile_path/0`
    * `MIX_CONSOLIDATION_PATH` - same as `Mix.Project.consolidation_path/0`
    * `MIX_DEPS_PATH` - same as `Mix.Project.deps_path/0`
    * `MIX_MANIFEST_PATH` - same as `Mix.Project.manifest_path/0`
    * `ERL_EI_LIBDIR`
    * `ERL_EI_INCLUDE_DIR`
    * `ERTS_INCLUDE_DIR`
    * `ERL_INTERFACE_LIB_DIR`
    * `ERL_INTERFACE_INCLUDE_DIR`
  These may also be overwritten with the `cmake_env` option.
  ## Compilation artifacts and working with priv directories
  Generally speaking, compilation artifacts are written to the `priv`
  directory, as that the only directory, besides `ebin`, which are
  available to Erlang/OTP applications.
  However, note that Mix projects supports the `:build_embedded`
  configuration, which controls if assets in the `_build` directory
  are symlinked (when `false`, the default) or copied (`true`).
  In order to support both options for `:build_embedded`, it is
  important to follow the given guidelines:
    * The "priv" directory must not exist in the source code
    * The Makefile should copy any artifact to `$MIX_APP_PATH/priv`
      or, even better, to `$MIX_APP_PATH/priv/$MIX_TARGET`
    * If there are static assets, the Makefile should copy them over
      from a directory at the project root (not named "priv")

  """
  use Mix.Task

  @recursive true

  @default_cmakelists_path ".."
  @default_make_target "all"
  @default_working_dir "_cmake"

  @doc """
  Runs this task.
  """
  def run(_args) do
    config = Mix.Project.config()

    env = Keyword.get(config, :cmake_env, %{})
    env = if is_function(env), do: env.(), else: env
    env = default_env(config, env)

    :ok = File.mkdir_p(@default_working_dir)
    cmd("cmake", [@default_cmakelists_path], env)
    cmd("make", [@default_make_target], env)
    Mix.Project.build_structure()
    :ok
  end

  @doc """
  Removes compiled artifacts.
  """
  def clean() do
    cmd("make", ["clean"])
    File.rm_rf(@default_working_dir)
    :ok
  end

  defp cmd(exec, args, env \\ %{}, dir \\ @default_working_dir) do
    case System.cmd(exec, args, cd: dir, stderr_to_stdout: true, env: env) do
      {result, 0} ->
        Mix.shell().info(result)
        :ok

      {result, status} ->
        Mix.raise("Failure running '#{exec}' (status: #{status}).\n#{result}")
    end
  end

  defp default_env(config, default_env) do
    root_dir = :code.root_dir()
    erl_interface_dir = Path.join(root_dir, "usr")
    erts_dir = Path.join(root_dir, "erts-#{:erlang.system_info(:version)}")
    erts_include_dir = Path.join(erts_dir, "include")
    erl_ei_lib_dir = Path.join(erl_interface_dir, "lib")
    erl_ei_include_dir = Path.join(erl_interface_dir, "include")

    Map.merge(
      %{
        # Don't use Mix.target/0 here for backwards compatability
        "MIX_TARGET" => env("MIX_TARGET", "host"),
        "MIX_ENV" => to_string(Mix.env()),
        "MIX_BUILD_PATH" => Mix.Project.build_path(config),
        "MIX_APP_PATH" => Mix.Project.app_path(config),
        "MIX_COMPILE_PATH" => Mix.Project.compile_path(config),
        "MIX_CONSOLIDATION_PATH" => Mix.Project.consolidation_path(config),
        "MIX_DEPS_PATH" => Mix.Project.deps_path(config),
        "MIX_MANIFEST_PATH" => Mix.Project.manifest_path(config),

        # Rebar naming
        "ERL_EI_LIBDIR" => env("ERL_EI_LIBDIR", erl_ei_lib_dir),
        "ERL_EI_INCLUDE_DIR" => env("ERL_EI_INCLUDE_DIR", erl_ei_include_dir),

        # erlang.mk naming
        "ERTS_INCLUDE_DIR" => env("ERTS_INCLUDE_DIR", erts_include_dir),
        "ERL_INTERFACE_LIB_DIR" => env("ERL_INTERFACE_LIB_DIR", erl_ei_lib_dir),
        "ERL_INTERFACE_INCLUDE_DIR" => env("ERL_INTERFACE_INCLUDE_DIR", erl_ei_include_dir)
      },
      default_env
    )
  end

  defp env(var, default) do
    System.get_env(var) || default
  end
end
