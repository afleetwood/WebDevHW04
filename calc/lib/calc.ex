defmodule Calc do

  # Parse through a user's input string and calculate the result
  def eval(expr) do
    # normalize the input expression
    String.replace(expr, "(", "( ")
      |> String.replace(")", " )")
      |> String.split()
      |> calculate()
      |> Enum.at(0)
      |> Integer.parse()
      |> elem(0)
  end


  # Remove parentheses and evaluate the expression
  def calculate(exprList) do
    solve_parens(exprList)
    |> solve_basic()
  end

  # Solves expressions in parentheses and replaces them with solved value
  def solve_parens(expr) do
    start_index = Enum.find_index(expr, 
	fn(char) -> char == "(" end)
    case start_index do
      nil -> 
	expr
      _ ->
	stop_index = expr 
	  |> Enum.split(start_index + 1)
	  |> elem(1)
	  |> find_paren_end(start_index + 1, 0)

	calculation = expr 
	  |> Enum.slice(start_index + 1, stop_index - start_index - 1)
	  |> calculate()

	rest = expr |> Enum.split(stop_index + 1) |> elem(1)

	expr
	|> Enum.split(start_index)
	|> elem(0)
	|> Enum.concat(calculation)
	|> Enum.concat(rest)
	|> solve_parens()
    end
  end

  # Locates and returns the index of the next closing parenthesis
  def find_paren_end(expr, index, acc) do
    if Enum.empty?(expr) do
      exit "Expression has no characters"
    end

    case Enum.at(expr, 0) do
      "(" -> 
	expr 
	|> Enum.split(1) 
	|> elem(1) 
	|> find_paren_end(index + 1, acc + 1)

      ")" -> 
	if acc == 0 do
	  index
	else
	  expr 
	  |> Enum.split(1) 
	  |> elem(1) 
	  |> find_paren_end(index + 1, acc - 1)
        end

      _ ->
	expr
	|> Enum.split(1)
	|> elem(1)
	|> find_paren_end(index + 1, acc)
    end
  end

  # Solves the expression if there are no parens
  def solve_basic(expr) do
    if Enum.count(expr) == 1 do
      expr
    else
      solve_MD(expr)
      |> solve_AS()
    end
  end

  # Solves multiplications and divisions in left-to-right order
  def solve_MD(expr) do
    operator = Enum.find_index(expr, fn(x) -> x == "*" || x == "/" end)
    case operator do
      nil ->
	expr
      _ ->
	calculation = expr 
	  |> operate(operator, String.to_atom(Enum.at(expr, operator)))

	rest = expr 
	  |> Enum.split(operator + 2) 
	  |> elem(1)

	expr
	|> Enum.split(operator - 1)
	|> elem(0)
	|> Enum.concat(calculation)
	|> Enum.concat(rest)
	|> solve_MD()
    end
  end

  # Solves additions and subtractions in left-to-right order
  def solve_AS(expr) do
    operator = Enum.find_index(expr, fn(x) -> x == "+" || x == "-" end)
    case operator do
      nil ->
	expr
      _ ->
	calculation = expr 
	  |> operate(operator, String.to_atom(Enum.at(expr, operator)))

	rest = expr 
	  |> Enum.split(operator + 2) 
	  |> elem(1)

	expr
	|> Enum.split(operator - 1)
	|> elem(0)
	|> Enum.concat(calculation)
	|> Enum.concat(rest)
	|> solve_AS()
    end
  end
 
  # Helper function to run division
  def operate(expr, operator, :/) do
    op1 = expr |> Enum.at(operator - 1) |> Integer.parse() |> elem(0)

    op2 = expr |> Enum.at(operator + 1) |> Integer.parse() |> elem(0)

    [Integer.to_string(div(op1, op2))]
  end

   # Helper function to run multiplication
  def operate(expr, operator, :*) do
    op1 = expr |> Enum.at(operator - 1) |> Integer.parse() |> elem(0)

    op2 = expr |> Enum.at(operator + 1) |> Integer.parse() |> elem(0)

    [Integer.to_string(op1 * op2)]
  end

   # Helper function to run addition
  def operate(expr, operator, :+) do
    op1 = expr |> Enum.at(operator - 1) |> Integer.parse() |> elem(0)

    op2 = expr |> Enum.at(operator + 1) |> Integer.parse() |> elem(0)

    [Integer.to_string(op1 + op2)]
  end

   # Helper function to run subtraction
  def operate(expr, operator, :-) do
    op1 = expr |> Enum.at(operator - 1) |> Integer.parse() |> elem(0)

    op2 = expr |> Enum.at(operator + 1) |> Integer.parse() |> elem(0)

    [Integer.to_string(op1 - op2)]
  end

  # Main function, repeatedly asks for expression to evaluate
  def main() do
    # print a prompt and read one line
    user_input = IO.gets "> "

    # evaluate the line and print it
    output = eval(user_input)
    IO.puts output

    # repeat request
    main()
  end
end
