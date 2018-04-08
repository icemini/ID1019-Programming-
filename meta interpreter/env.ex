#a module for the environment
#an environment is a list of key-value tuples that contains variable bindings
#{x/foo, y/bar} -> [{:x, :foo}, {:y, :bar}]

defmodule Env do

  #returns an empty environment
  def new() do [] end

  #return an environment
  #the binding of variable id to the structure str has been added to the environment env
  def add(id, str, env) do
    [{id, str} | env]
  end

  #lookup an id in the environment
  #return {id, str} if variable id was bound or nil
  def lookup(id, []) do nil end
  def lookup(id, [{id, str} | rest]) do
    {id, str}
  end
  def lookup(id, [{other, _} | rest]) do
    lookup(id, rest)
  end

  #returns an environment where all bindings for variabels in the list ids have been removed
  def remove([], env) do env end  #when we have gone through the list of ids
  def remove([id|rest], env) do
    newEnv = List.keydelete(env, id, 0)    #removes tuples containing id, returns the new environment
    remove(rest, newEnv)
  end

  #create new environment from a list of variable identifiers and an existing environment


end
