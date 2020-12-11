defmodule ContentDock.Email do
  def send(to, subject, body) do
    IO.puts("To: #{to}")
    IO.puts("Subject: #{subject}")
    IO.puts("Body: #{body}")
  end
end
