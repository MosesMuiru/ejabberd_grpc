defmodule EjabberdRcp.MixProject do
  use Mix.Project

  def project do
    [
      app: :ejabberd_rcp,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        dev: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {EjabberdRcp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:grpc, "~> 0.9"},
      {:cowlib, "~> 2.13", override: true},
      {:ejabberd, "~> 24.7"},
      {:epgsql, "~> 4.7"},
      {:cors_plug, "~> 3.0"},
      {:plug_cowboy, "~> 2.0"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
