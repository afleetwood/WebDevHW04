defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "operate" do
    assert Calc.operate(["6", "+", "12"], 1, :+) == ["18"]
    assert Calc.operate(["30", "-", "8"], 1, :-) == ["22"]
    assert Calc.operate(["4", "8", "7"], 1, :*) == ["28"]
    assert Calc.operate(["9", "/", "3"], 1, :/) == ["3"]
    assert Calc.operate(["2", "+", "5", "*", "2"], 3, :*) == ["10"]
  end

  test "solve_basic" do
    assert Calc.solve_basic(["1"]) == ["1"]
    assert Calc.solve_basic(["15", "-", "7"]) == ["8"]
    assert Calc.solve_basic(["6", "*", "3", "/", "3"]) == ["6"]
    assert Calc.solve_basic(["10", "-", "2", "*", "3"]) == ["4"]
  end

  test "find_paren_end" do
    assert Calc.find_paren_end(["1", ")"], 1, 0) == 2
    assert Calc.find_paren_end(["(", "86", ")", ")"], 1, 0) == 4
  end

  test "solve_parens" do
    assert Calc.solve_parens(["(", "9", ")"]) == ["9"]
    assert Calc.solve_parens(["(", "7", "/", "7", ")"]) == ["1"]
    assert Calc.solve_parens(["(", "(", "7", "*", "7", ")", "+", "0", ")"]) == ["49"]
  end

  test "solve_AS" do
    assert Calc.solve_AS(["100"]) == ["100"]
    assert Calc.solve_AS(["1", "+", "1"]) == ["2"]
    assert Calc.solve_AS(["1", "+", "2", "-", "3"]) == ["0"]
  end

  test "solve_MD" do
    assert Calc.solve_MD(["42"]) == ["42"]
    assert Calc.solve_MD(["100", "/", "20"]) == ["5"]
    assert Calc.solve_MD(["12", "+", "4", "*", "6"]) == ["12", "+", "24"]
  end

  test "calculate" do
    assert Calc.calculate(["8"]) == ["8"]
    assert Calc.calculate(["6", "*", "6", "+", "1"]) == ["37"]
    assert Calc.calculate(["(", "9", "-", "1", ")", "/", "(", "1", "+", "3", ")"]) == ["2"]
  end

  test "eval" do
    assert Calc.eval("0") == 0
    assert Calc.eval("2 + 3") == 5
    assert Calc.eval("3 - 2") == 1
    assert Calc.eval("6 * 9") == 54
    assert Calc.eval("88 / 11") == 8
    assert Calc.eval("( ( 9 - 1 ) / ( 1 + 3 ) )") == 2
  end
end
 
