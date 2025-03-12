defmodule Asd do
  def asd() do
    {:ok, socket} = :gen_tcp.connect(~c"127.0.0.1", 5038, [:binary, active: true, packet: :line])

    IO.inspect(socket)

    # Логин в AMI
    :gen_tcp.send(
      socket,
      "Action: Login\r\nUsername: test\r\nSecret: 123\r\n\r\n"
    )




    receive do
      {:tcp, _socket, data} -> IO.puts("Response for elixir_connector: #{data}")
      response -> IO.puts(response)
    after
      2000 -> IO.puts("No response from Asterisk for elixir_connector")
    end

    #:timer.sleep(20000)
    # После успешного логина отправляем команду Ping
    :gen_tcp.send(socket, "Action: Ping\r\n\r\n")

    receive do
      {:tcp, _socket, data} -> IO.puts("Response for Ping: #{data}")
    after
      20000 -> IO.puts("No response from Asterisk for Ping")
    end
  end
end

Asd.asd()
