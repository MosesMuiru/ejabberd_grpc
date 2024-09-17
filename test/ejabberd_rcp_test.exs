defmodule EjabberdRcpTest do
  use ExUnit.Case
  doctest EjabberdRcp

  test "greets the world" do
    assert EjabberdRcp.hello() == :world
  end
end
