defmodule AsteriskConnector.Application do
  use Application

  def start(_type, _args) do
    children = [
      {AsteriskConnector, []}
    ]

    opts = [strategy: :one_for_one, name: AsteriskConnector.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
