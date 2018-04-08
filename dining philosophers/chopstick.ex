#chopstick module
#state is either available or gone

defmodule Chopstick do

def start do
  stick = spawn_link(fn -> available() end)
end

#when a chopstick is available
def available() do
  receive do
  {:request, from} -> #from is a philosophers process id
    send(from, :granted)
    gone()
  :quit -> :ok
  end
end

#a chopstick has been taken
def gone() do
  receive do
  :return -> available()
  :quit -> :ok
  end
end

#when a philosopher request a chopstick
def request(stick) do
  send(stick, {:request, self()})   #send request to chopstick
  receive do
  :granted -> :ok
  end
end

# return a chopstick
def return(stick) do
  send(stick, :return)
end

def quit(stick) do
  send(stick, :quit)
end

end
