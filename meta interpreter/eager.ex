defmodule Eager do

#evaluate an expression
#return a datastructure given an expression

#atom
#we don't care about the environment, just return the identifier
def eval_expr({:atm, id}, _, prg) do
  {:ok, id}
end

#variable
def eval_expr({:var, id}, env, prg) do
  #see if the id of the variable exists in the environment
  #see if we find a binding
  case Env.lookup(id, env) do
    nil -> :error
    {_, str} -> {:ok, str}  #return the structure
  end
end

#cons - consists of variable and atom or two atoms
#return the structures of both elements in :cons
#does the order in which we evaluate the elements matter?
# -> if we evaluate an element with a loop first and then the other one which have a crash, we will not crash, instead we will go into loop
# -> matters when there is a loop or an error (bottom)
def eval_expr({:cons, head, tail}, env, prg) do
  case eval_expr(head, env, prg) do  #check the first element
    :error -> :error
    {:ok, headStr} ->
      case eval_expr(tail, env, prg) do  #check second element
        :error -> :error
        {:ok, tailStr} -> {:ok , {headStr, tailStr}}
      end
  end
end
#case expression
def eval_expr({:case, expr, clauseList}, env, prg) do
  case eval_expr(expr, env, prg) do
  :error ->
    :error
  {:ok, str} ->
    eval_clause(clauseList, str, env, prg)
  end
end
#clause
def eval_clause([], _, _, _) do
  :error
end
def eval_clause([{:clause, pattern, seq} | clause], str, env, prg) do
  vars = extract_vars(pattern)
  env = Env.remove(vars, env)
  case eval_match(pattern, str, env) do
    :fail ->
      eval_clause(clause, str, env, prg)
    {:ok, env} ->
      eval_seq(seq, env, prg)
  end
end

#pattern matching
#match variable with a structure
#takes a pattern, datastructure and an environment
#we want to bind an expression to another expression
#returns extended environment

#ignore case
def eval_match(:ignore, _, env) do
  {:ok, env}
end
#atom
#atoms do always match for atoms, ignore case where they do not match
def eval_match({:atm, id}, id, env) do
  {:ok, env}
end
#variable
def eval_match({:var, id}, str, env) do
  case Env.lookup(id, env) do
    #if id does not exist in environment, add it
    nil ->
      {:ok, Env.add(id,str,env)}
    #if the structure we get is equal to our structure in the function parameter, just return the environment
    {_, ^str} ->
      {:ok, env}
    #if we got a different structure the patterns did not match
    {_, _} ->
      :fail
  end
end
#cons
#we first want to match headPattern with headStr and then tailPattern to tailStr
def eval_match({:cons, headPattern, tailPattern}, [headStr | tailStr], env) do
  case eval_match(headPattern, headStr, env) do
    :fail ->
      :fail
    {:ok, env} ->
      eval_match(tailPattern, tailStr, env)
  end
end
#if we cannot match the pattern to data structure
def eval_match(_, _, _) do
  :fail
end

#expression
def eval_seq([exp], env, prg) do
  eval_expr(exp, env, prg)
end
def eval_seq([{:match, pattern, expression} | rest], env, prg) do
  #evaluate the expression
  case eval_expr(expression, env, prg) do
    :error ->
      :error
    #if expression exist in environment
    {:ok, str} ->
      vars = extract_vars(pattern)    #get variable from pattern
      env = Env.remove(vars, env)     #remove all variable bindings in env
    case eval_match(pattern, str, env) do   #match structure with our new pattern
      :fail ->    # will we ever get to this cause if we have removed all variables i the env?
        :error
      {:ok, env} ->
        eval_seq(rest, env, prg)
    end
  end
end

#extract the variables from the pattern and put in a list
def extract_vars(pattern) do
  extract_vars(pattern, [])
end
def extract_vars({:atm, _}, vars) do vars end
def extract_vars(:ignore, vars) do vars end
def extract_vars({:var, var}, vars) do
  [var | vars]  #we are only interested in variables
end
#add both head and tail for cons
def extract_vars({:cons, head, tail}, vars) do
  extract_vars(tail, extract_vars(head, vars))
end


end
