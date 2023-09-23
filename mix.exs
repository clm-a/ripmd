defmodule Ripmd.MixProject do
  use Mix.Project

  def project do
    [
      app: :ripmd,
      version: "0.1.0-dev",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def escript() do
    [
      main_module: Ripmd.CLI
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:livebook, "~> 0.10.0"},
      {:earmark, "~> 1.4"},
      {:ansi_to_html, "~> 0.5.2"},
      {:makeup, "~> 1.1"},
      {:makeup_elixir, "~> 0.16.1"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
