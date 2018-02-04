defmodule Calc do
  @moduledoc """
  Documentation for Calc.

  Running Calc.main

  program takes an arithmetic expression containing both int & float as input
  and evaluates the given arithmetic expression to give a float/int output

  """

  def push(stack, e), do: [e|stack]
  def pop([]), do: {nil, nil}
  def pop([e|stack]), do: {e, stack}

  def get_exp do
    IO.gets("> ")
    |> String.replace(~r/\s+/,"")
  end

  def getPrecedence(op) do
    cond do
      op === "+" or op === "-" -> 2
      op === "*" or op === "/" -> 3
      op === "(" or op === ")" -> 1
      true -> IO.puts "Incorrect input #{op}"
    end
  end

  def solve(val1,val2,op) do
    cond do
      op === "+" -> val1 + val2
      op === "-" -> val1 - val2
      op === "*" -> val1 * val2
      op === "/" -> floatToIntFloat(val1 / val2)
      true -> IO.puts "Incorrect input #{op}"
    end
  end

  def rightPLoop([h | opStack],valStack) do
    cond do
      h === "(" -> {opStack,valStack}
      h !== "(" ->
        {val1,valStack} = pop(valStack)
        {val2,valStack} = pop(valStack)
        res = solve(val2,val1,h)
        valStack = push(valStack,res)
        rightPLoop(opStack,valStack)
    end
  end

  def opLoop(thisOp,[h | opStack],valStack) do
    #IO.puts thisOp
    cond do
      getPrecedence(h)<getPrecedence(thisOp) ->
        opStack = push([h|opStack],thisOp)
        {opStack,valStack}
      true ->
        {val1,valStack} = pop(valStack)
        {val2,valStack} = pop(valStack)
        res = solve(val2,val1,h)
        valStack = push(valStack,res)
        opLoop(thisOp,opStack,valStack)
    end
  end

  def opLoop(thisOp,[],valStack) do
    opStack = push([],thisOp)
    {opStack,valStack}
  end

  def floatToIntFloat(x) do
    if x-trunc(x) == 0 do
      trunc(x)
    else
      x
    end
  end

  def eval([h | t],valStack,opStack) do
    cond do
      is_float(h) or is_integer(h) ->
        valStack = push(valStack,h)
        eval(t,valStack,opStack)
      h === "(" ->
        opStack = push(opStack,h)
        eval(t,valStack,opStack)
      h === ")" ->
        {opStack,valStack} = rightPLoop(opStack,valStack)
        eval(t,valStack,opStack)
      h=="+" or h=="-" or h=="*" or h=="/" ->
        {opStack,valStack} = opLoop(h,opStack,valStack)
        eval(t,valStack,opStack)
    end
  end

  def eval([],valStack,[h|opStack]) do
    {val1,valStack} = pop(valStack)
    {val2,valStack} = pop(valStack)
    res = solve(val2,val1,h)
    valStack = push(valStack,res)
    eval([],valStack,opStack)
  end

  def eval([],[result|_],[]) do
    result
  end

  def eval(exp,list) do
    cond do
      exp === "" ->
        list
      Regex.match?(~r/[()+\-*\/]/,String.first(exp)) ->
        list = List.insert_at(list,-1,String.first(exp))
        String.slice(exp,1..-1) |>
          eval(list)
      Float.parse(exp)!=:error ->
        {num,exp} = Float.parse(exp)
        num = floatToIntFloat(num)
        list = List.insert_at(list,-1,num)
        eval(exp,list)
    end
  end

  def eval(exp) do
    list = eval(exp,[])
    result = eval(list,[],[])
    result
  end

  def main() do
    expression = get_exp()
    result = eval(expression)
    IO.puts result
    main()
  end

end
