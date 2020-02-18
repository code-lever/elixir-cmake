defmodule Mix.Tasks.Compile.CmakeTest do
  use ExUnit.Case

  import Mix.Tasks.Compile.Cmake, only: [run: 1]
  import ExUnit.CaptureIO

  @fixture_project Path.expand("fixtures/sample_app", __DIR__)

  setup do
    in_fixture(fn ->
      File.rm_rf!("_build")
      File.rm_rf!("CMakeLists.txt")
    end)

    :ok
  end

  test "running without a CMakeLists.txt" do
    msg = ~r/does not appear to contain CMakeLists.txt/

    in_fixture(fn ->
      File.rm_rf!("CMakeLists.txt")

      capture_io(fn ->
        assert_raise Mix.Error, msg, fn -> run([]) end
      end)
    end)
  end

  defp in_fixture(fun) do
    File.cd!(@fixture_project, fun)
  end
end
