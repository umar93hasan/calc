defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "precedence of ( = 1" do
    assert Calc.getPrecedence("(")  == 1
  end

  test "precedence of ) = 1" do
    assert Calc.getPrecedence(")")  == 1
  end

  test "precedence of + = 2" do
    assert Calc.getPrecedence("+")  == 2
  end

  test "precedence of - = 2" do
    assert Calc.getPrecedence("-")  == 2
  end

  test "precedence of * = 3" do
    assert Calc.getPrecedence("*")  == 3
  end

  test "precedence of / = 3" do
    assert Calc.getPrecedence("/")  == 3
  end

  test "solve 1+2=3" do
    assert Calc.solve(1,2,"+") == 3
  end

  test "solve 1-2=-1" do
    assert Calc.solve(1,2,"-") == -1
  end

  test "solve 1*2=2" do
    assert Calc.solve(1,2,"*") == 2
  end

  test "solve 1/2=0.5" do
    assert Calc.solve(1,2,"/") == 0.5
  end

  test "push [2,1],3 = [3,2,1]" do
   assert Calc.push([2,1],3) == [3,2,1]
  end

  test "pop [3,2,1] = {3,[2,1]}" do
   assert Calc.pop([3,2,1]) == {3,[2,1]}
  end

end
