# formular
一个用仓颉语言编写的公式解析器。

## 安装说明
将以下行添加到您的 `cjpm.toml` 配置文件
```toml
"formular" = "1.0.0"
```
然后在终端中运行此命令
```shell
cjpm update
```
完成。

## 使用方法

### 基础数学运算
解析普通数学公式
```cangjie
let parser = FormulaParser.parser() // 创建默认解析器
let formula = parser.parse("10 - 1 + 9 * 2 + 4 / 2") // 解析公式
println(formula.calculate()) // 计算并打印结果，结果应为 29
```

### 变量使用
在公式中使用变量
```cangjie
let formula = FormulaParser.parser().parse("test + 100 * 8")
formula.set("test", 123.0) // 设置变量的值
println(formula.calculate()) // 结果应为 923
```

### 括号控制运算顺序
使用括号控制运算顺序
```cangjie
let formula = FormulaParser.parser().parse("(test + 100) * 8")
formula.set("test", 123.0)
println(formula.calculate()) // 结果应为 1784
```

### 内置常量（PI 和 e）
启用数学常量
```cangjie
let formula1 = FormulaParser.parser().parse("ln(e)")
formula1.enablePIAndE()
println(formula1.calculate()) // 结果应为 1

let formula2 = FormulaParser.parser().parse("sqrt(sin(pi) ^ 2 + cos(pi) ^ 2)")
formula2.enablePIAndE()
println(formula2.calculate()) // 结果应为 1
```

### 数学函数
使用数学函数 sin、cos、sqrt 等
```cangjie
let formula = FormulaParser.parser().parse("sqrt(sin(pi) ^ 2 + cos(pi) ^ 2)")
formula.enablePIAndE()
println(formula.calculate()) // 结果应为 1
```

### 条件函数
使用 condition 实现 if-then-else 逻辑
```cangjie
let formula = FormulaParser.parser().parse("condition(x > 15, 111, 222)")
formula.set("x", 14.0)
println(formula.calculate()) // 结果应为 222

formula.set("x", 17.0)
println(formula.calculate()) // 结果应为 111
```

### 自定义函数
注册您自己的自定义函数
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
println(formula.calculate()) // 结果应为 -1
```

## 内置函数

以下函数默认内置，可直接使用：

### 数学函数

| 函数 | 参数数量 | 功能描述 |
|------|----------|----------|
| `sqrt(x)` | 1 | x 的平方根 |
| `cbrt(x)` | 1 | x 的立方根 |
| `abs(x)` | 1 | x 的绝对值 |
| `round(x)` | 1 | 将 x 四舍五入到最近的整数 |
| `ceil(x)` | 1 | 将 x 向上取整 |
| `floor(x)` | 1 | 将 x 向下取整 |
| `trunc(x)` | 1 | 截断 x 的小数部分 |

### 三角函数

| 函数 | 参数数量 | 功能描述 |
|------|----------|----------|
| `sin(x)` | 1 | x 的正弦值（x 为弧度） |
| `cos(x)` | 1 | x 的余弦值（x 为弧度） |
| `tan(x)` | 1 | x 的正切值（x 为弧度） |
| `asin(x)` | 1 | x 的反正弦值 |
| `acos(x)` | 1 | x 的反余弦值 |
| `atan(x)` | 1 | x 的反正切值 |
| `atan2(y, x)` | 2 | 双参数反正切 |
| `sinh(x)` | 1 | x 的双曲正弦值 |
| `cosh(x)` | 1 | x 的双曲余弦值 |
| `tanh(x)` | 1 | x 的双曲正切值 |
| `asinh(x)` | 1 | 反双曲正弦值 |
| `acosh(x)` | 1 | 反双曲余弦值 |
| `atanh(x)` | 1 | 反双曲正切值 |

### 对数函数

| 函数 | 参数数量 | 功能描述 |
|------|----------|----------|
| `ln(x)` | 1 | 自然对数（以 e 为底） |
| `lg(x)` | 1 | 常用对数（以 10 为底） |
| `log(x, base)` | 2 | 自定义底数的对数 |

### 实用函数

| 函数 | 参数数量 | 功能描述 |
|------|----------|----------|
| `min(a, b)` | 2 | 返回两个值中的较小值 |
| `max(a, b)` | 2 | 返回两个值中的较大值 |
| `clamp(x, min, max)` | 3 | 将 x 限制在 [min, max] 范围内 |
| `condition(cond, true_val, false_val)` | 3 | 如果 cond 不为 0，返回 true_val，否则返回 false_val |

### 常量（需要调用 `enablePIAndE()`）

| 常量 | 值 | 描述 |
|------|-----|------|
| `pi` | π | 圆周率（约 3.14159） |
| `π` | π | 圆周率（约 3.14159） |
| `Π` | π | 圆周率（约 3.14159） |
| `e` | e | 自然常数（约 2.71828） |
