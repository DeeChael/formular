# formular
A formula parser written in Cangjie.

## Installation
Add this line to your `cjpm.toml` configuration file
```toml
"formular" = "1.0.0"
```
Then run this command in your terminal
```shell
cjpm update
```
Done.

## Usage
Parse a normal math formula
```cangjie
let parser = FormulaParser.parser() // create a default parser
let formula = parser.parse("10 - 1 + 9 * 2 + 4 / 2") // parse a formula
println(formula.calculate()) // calculate and print result, result should be 29
```
