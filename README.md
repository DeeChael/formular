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

### Basic Math
Parse a normal math formula
```cangjie
let parser = FormulaParser.parser() // create a default parser
let formula = parser.parse("10 - 1 + 9 * 2 + 4 / 2") // parse a formula
println(formula.calculate()) // calculate and print result, result should be 29
```

### Variables
Use variables in formulas
```cangjie
let formula = FormulaParser.parser().parse("test + 100 * 8")
formula.set("test", 123.0) // set variable value
println(formula.calculate()) // result should be 923
```

### Parentheses
Control order of operations with parentheses
```cangjie
let formula = FormulaParser.parser().parse("(test + 100) * 8")
formula.set("test", 123.0)
println(formula.calculate()) // result should be 1784
```

### Built-in Constants (PI and e)
Enable mathematical constants
```cangjie
let formula1 = FormulaParser.parser().parse("ln(e)")
formula1.enablePIAndE()
println(formula1.calculate()) // result should be 1

let formula2 = FormulaParser.parser().parse("sqrt(sin(pi) ^ 2 + cos(pi) ^ 2)")
formula2.enablePIAndE()
println(formula2.calculate()) // result should be 1
```

### Conditional Function
Use condition for if-then-else logic
```cangjie
let formula = FormulaParser.parser().parse("condition(x > 15, 111, 222)")
formula.set("x", 14.0)
println(formula.calculate()) // result should be 222

formula.set("x", 17.0)
println(formula.calculate()) // result should be 111
```

### Custom Functions
Register your own custom functions
```cangjie
class AlwaysOneFunction <: FormulaFunction {
    public static let INSTANCE: AlwaysOneFunction = AlwaysOneFunction()
    
    private AlwaysOneFunction() {}
    
    public override prop name: String {
        get() { return "always1" }
    }
    
    public override prop args: Int64 {
        get() { return 0 }
    }
    
    public override func execute(_: Array<Float64>): Float64 {
        return 1.0
    }
}

let parser = FormulaParser.parser()
parser.registerFunction(AlwaysOneFunction.INSTANCE)
let formula = parser.parse("-always1()")
println(formula.calculate()) // result should be -1
```

## Built-in Functions

The following functions are built-in and available by default:

### Mathematical Functions

| Function | Parameters | Description |
|----------|-----------|-------------|
| `sqrt(x)` | 1 | Square root of x |
| `cbrt(x)` | 1 | Cube root of x |
| `abs(x)` | 1 | Absolute value of x |
| `round(x)` | 1 | Round x to nearest integer |
| `ceil(x)` | 1 | Round x up to nearest integer |
| `floor(x)` | 1 | Round x down to nearest integer |
| `trunc(x)` | 1 | Truncate decimal part of x |

### Trigonometric Functions

| Function | Parameters | Description |
|----------|-----------|-------------|
| `sin(x)` | 1 | Sine of x (x in radians) |
| `cos(x)` | 1 | Cosine of x (x in radians) |
| `tan(x)` | 1 | Tangent of x (x in radians) |
| `asin(x)` | 1 | Arc sine of x |
| `acos(x)` | 1 | Arc cosine of x |
| `atan(x)` | 1 | Arc tangent of x |
| `atan2(y, x)` | 2 | Two-argument arc tangent |
| `sinh(x)` | 1 | Hyperbolic sine of x |
| `cosh(x)` | 1 | Hyperbolic cosine of x |
| `tanh(x)` | 1 | Hyperbolic tangent of x |
| `asinh(x)` | 1 | Inverse hyperbolic sine |
| `acosh(x)` | 1 | Inverse hyperbolic cosine |
| `atanh(x)` | 1 | Inverse hyperbolic tangent |

### Logarithmic Functions

| Function | Parameters | Description |
|----------|-----------|-------------|
| `ln(x)` | 1 | Natural logarithm (base e) |
| `lg(x)` | 1 | Common logarithm (base 10) |
| `log(x, base)` | 2 | Logarithm with custom base |

### Utility Functions

| Function | Parameters | Description |
|----------|-----------|-------------|
| `min(a, b)` | 2 | Minimum of two values |
| `max(a, b)` | 2 | Maximum of two values |
| `clamp(x, min, max)` | 3 | Clamp x to range [min, max] |
| `condition(cond, true_val, false_val)` | 3 | If cond != 0, returns true_val, else false_val |

### Constants (requires `enablePIAndE()`)

| Constant | Value | Description |
|----------|-------|-------------|
| `pi` | π | Mathematical constant π (~3.14159) |
| `π` | π | Mathematical constant π (~3.14159) |
| `Π` | π | Mathematical constant π (~3.14159) |
| `e` | e | Mathematical constant e (~2.71828) |
