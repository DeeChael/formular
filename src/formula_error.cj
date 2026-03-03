package formular

open class FormulaException <: Exception {

    public init() {
        super("Formula error occurs")
    }

    public init(message: String) {
        super(message)
    }

    public open override func getClassName(): String {
        "FormulaException"
    }

}

class FormulaParserException <: FormulaException {

    public init() {
        super("Something went wrong when parsing formula")
    }

    public override func getClassName(): String {
        "FormulaParserException"
    }

}

class FormulaCalculationException <: FormulaException {

    public init() {
        super("Failed to calculate")
    }

    public override func getClassName(): String {
        "FormulaCalculationException"
    }

}

class FormulaNoValueException <: FormulaException {

    public init() {
        super("Operator requires value")
    }

    public override func getClassName(): String {
        "FormulaNoValueException"
    }

}

class FormulaVariableException <: FormulaException {

    public init() {
        super("Variable has issues")
    }

    public override func getClassName(): String {
        "FormulaVariableException"
    }

}

class FormulaFunctionParameterException <: FormulaException {

    public init() {
        super("Function parameters has issues")
    }

    public override func getClassName(): String {
        "FormulaFunctionParameterException"
    }

}

class FormulaFunctionNotFoundException <: FormulaException {

    public init() {
        super("Function not found")
    }

    public override func getClassName(): String {
        "FormulaFunctionNotFoundException"
    }

}