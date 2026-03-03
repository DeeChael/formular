package formular_test

internal class TestFormulaFunction <: FormulaFunction {

    public static let INSTANCE: TestFormulaFunction = TestFormulaFunction()

    private TestFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "always1"
        }
    }

    public override prop args: Int64 {
        get() {
            return 0
        }
    }

    public override func execute(_: Array<Float64>): Float64 {
        return 1.0
    }


}

main() {
    test0()
    test1()
    test2()
    test3()
    test4()
    test5()
    test6()
    test7()
    test8()
}

func test0() {
    let parser = FormulaParser.parser()
    parser.registerFunction(TestFormulaFunction.INSTANCE)
    let formula = parser.parse("-always1()")
    println(formula.calculate())
}

func test1() {
    let formula = FormulaParser.parser().parse("100 * 8")
    println(formula.calculate())
}

func test2() {
    let formula = FormulaParser.parser().parse("test + 100 * 8")
    formula.set("test", 123.0)
    println(formula.calculate())
}

func test3() {
    let formula = FormulaParser.parser().parse("(test + 100) * 8")
    formula.set("test", 123.0)
    println(formula.calculate())
}

func test4() {
    let formula = FormulaParser.parser().parse("(test + 100) * 8 + (8 * (2 + 3))")
    formula.set("test", 123.0)
    println(formula.calculate())
}

func test5() {
    let formula = FormulaParser.parser().parse("ln(e)")
    formula.enablePIAndE()
    println(formula.calculate())
}

func test6() {
    let formula = FormulaParser.parser().parse("sqrt(sin(pi) ^ 2 + cos(pi) ^ 2)")
    formula.enablePIAndE()
    println(formula.calculate())
}

func test7() {
    let formula = FormulaParser.parser().parse("condition(x > 15, 111, 222)")
    formula.set("x", 14.0)
    println("first value: ${formula.calculate()}")
    formula.set("x", 17.0)
    println("second value: ${formula.calculate()}")
}

func test8() {
    let formula = FormulaParser.parser().parse("""
    condition(
        x > 15,
        111, 
        222
    )
    """)
    formula.set("x", 14.0)
    println("first value: ${formula.calculate()}")
    formula.set("x", 17.0)
    println("second value: ${formula.calculate()}")
}