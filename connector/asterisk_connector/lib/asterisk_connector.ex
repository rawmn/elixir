defmodule AsteriskConnector do
  use GenServer

  @host "127.0.0.1"
  @port 5038
  @username "test"
  @secret "123"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    IO.puts("Trying to connect to Asterisk AMI...")
    # case ExAmi.start(nil, nil) do
    #   {:ok, ami} ->
    #     IO.puts("Connected to Asterisk AMI")

    #     IO.puts("SIPpeers")
    #     ExAmi.send_action(ami, %{"Action" => "SIPpeers"})


    #     ExAmi.register_event_listener(ami, self())
    #     {:ok, %{ami: ami}}

    #   {:error, reason} ->
    #     IO.puts("#{inspect(reason)}")
    #     {:stop, reason}
    # end
  end

  def handle_info({:ami_event, event}, state) do
    IO.puts("Event: #{inspect(event)}")
    {:noreply, state}
  end

  def handle_info({:ami_response, response}, state) do
    IO.puts("Response: #{inspect(response)}")
    {:noreply, state}
  end

  def terminate(_reason, %{ami: ami}) do
    ExAmi.stop(ami)
    IO.puts("откл Asterisk AMI")
  end
end
