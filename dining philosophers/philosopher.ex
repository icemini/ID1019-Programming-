# a philosopher is either dreaming, waiting or eating

defmodule Philosopher do

  def start(hunger, right, left, name, ctrl) do
    dreaming(hunger, right, left, name, ctrl)
  end

#a philosopher has finished eating
def dreaming(0, _, _, _, ctrl) do
  send(ctrl, :done)
end

#a philosopher dreams a random amount of time
def dreaming(hunger, right, left, name, ctrl) do
  sleep(3000)
  IO.puts("#{name} is dreaming!")
  waiting(hunger, right, left, name, ctrl)
end

#it then requests chopsticks
def waiting(hunger, right, left, name, ctrl) do
  case Chopstick.request(left) do
    :ok ->
      IO.puts("#{name} received left chopstick!")
      case Chopstick.request(right) do
        :ok ->
          IO.puts("#{name} received right chopstick!")
          eating(hunger, right, left, name, ctrl)
      end
  end
end

#a philosopher then eats
def eating(hunger, right, left, name, ctrl) do
  IO.puts("#{name} is eating!")
  sleep(3000)
  Chopstick.return(left)
  IO.puts("#{name} returned left chopstick!")
  Chopstick.return(right)
  IO.puts("#{name} returned right chopstick!")
  dreaming(hunger-1, right, left, name, ctrl)
end

# make process sleep for a random time
def sleep(t) do
  :timer.sleep(:rand.uniform(t))
end

end
