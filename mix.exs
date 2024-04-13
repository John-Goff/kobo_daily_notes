defmodule KoboDailyNotes.MixProject do
  use Mix.Project

  def project do
    [
      app: :kobo_daily_notes,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {KoboDailyNotes.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:burrito, "~> 1.0"}
    ]
  end
end
