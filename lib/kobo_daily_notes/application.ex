defmodule KoboDailyNotes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # children = [
    #   # Starts a worker by calling: KoboDailyNotes.Worker.start_link(arg)
    #   # {KoboDailyNotes.Worker, arg}
    # ]

    # # See https://hexdocs.pm/elixir/Supervisor.html
    # # for other strategies and supported options
    # opts = [strategy: :one_for_one, name: KoboDailyNotes.Supervisor]
    # Supervisor.start_link(children, opts)
    File.write!(
      Path.join([:code.priv_dir(:kobo_daily_notes), "test.txt"]),
      "This is text written from elixir"
    )

    {:error, :no_start}
  end
end
