defmodule Conn.Router do
  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)

  post "/ping" do
    case Conn.Client.ping() do
      %ElixirAmi.Response{keys: %{"ping" => response}} ->
        Logger.info("Получен ping от клиента — ответ: #{inspect(response)}")
        send_resp(conn, 200, Jason.encode!(%{response: response}))
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
