defmodule Conn.MixProject do
  use Mix.Project

  def project do
    [
      app: :conn,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Conn.Application, []},
      extra_applications: [:logger, :elixir_ami]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:ex_ami, "~> 0.3.3"}
      {:elixir_ami, "~> 0.0.20"},
      {:plug_cowboy, "~> 2.6"},
      {:jason, "~> 1.4"}
    ]
  end
end
