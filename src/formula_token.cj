package formular

import std.math.*

enum FormulaTokenType <: Equatable<FormulaTokenType> {
    | Constant | Variable | Operator | Function | NoToken | Formula

    public func getId(): String {
        return match (this) {
            case Constant => "constant"
            case Variable => "variable"
            case Operator => "operator"
            case Function => "function"
            case NoToken => "no_token"
            case Formula => "formula"
        }
    }

    public override operator func ==(another: FormulaTokenType): Bool {
        return this.getId() == another.getId()
    }

}

interface FormulaToken <: ToString & Equatable<FormulaToken> {

    prop tokenType: FormulaTokenType
    prop leftAccept: Option<Array<FormulaTokenType>>
    prop rightAccept: Option<Array<FormulaTokenType>>

}

interface OperatorFormulaToken <: FormulaToken {

    override prop tokenType: FormulaTokenType {
        get() {
            return FormulaTokenType.Operator
        }
    }

    prop key: Rune
    prop priority: Int64
    prop removeLeft: Bool
    prop removeRight: Bool

    func calculate(left: Option<Float64>, right: Option<Float64>): Float64

    override operator func ==(another: FormulaToken): Bool {
        if (!(another is OperatorFormulaToken)) {
            return false
        }
        
        let operatorToken = (another as OperatorFormulaToken).getOrThrow()

        return key == operatorToken.key && leftAccept == operatorToken.leftAccept && rightAccept == operatorToken.rightAccept
    }

}

interface FormulaFormulaToken <: FormulaToken {

    override prop tokenType: FormulaTokenType {
        get() {
            return FormulaTokenType.Formula
        }
    }

    override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    prop formula: Formula

    func calculate(formula: Formula): Float64

    override operator func ==(another: FormulaToken): Bool {
        if (!(another is FormulaFormulaToken)) {
            return false
        }
        return this.formula == (another as FormulaFormulaToken).getOrThrow().formula
    }

    override func toString(): String {
        return "Formula"
    }

}

interface VariableFormulaToken <: FormulaToken {

    override prop tokenType: FormulaTokenType {
        get() {
            return FormulaTokenType.Variable
        }
    }

    override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    prop variable: String
    prop args: Array<String>

    func get(variable: Collection<FormulaVariable>): Float64 

    override operator func ==(another: FormulaToken): Bool {
        if (!(another is VariableFormulaToken)) {
            return false
        }
        let variableToken = (another as VariableFormulaToken).getOrThrow()
        return variable == variableToken.variable && args == variableToken.args && leftAccept == variableToken.leftAccept && rightAccept == variableToken.rightAccept
    }

    override func toString(): String {
        return "Variable"
    }

}

interface ConstantFormulaToken <: FormulaToken {

    override prop tokenType: FormulaTokenType {
        get() {
            return FormulaTokenType.Constant
        }
    }

    override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    prop value: Float64

    override operator func ==(another: FormulaToken): Bool {
        if (!(another is ConstantFormulaToken)) {
            return false
        }
        let constantToken = (another as ConstantFormulaToken).getOrThrow()
        return value == constantToken.value && leftAccept == constantToken.leftAccept && rightAccept == constantToken.rightAccept
    }

    override func toString(): String {
        return "Constant"
    }

}

interface FunctionFormulaToken <: FormulaToken {

    override prop tokenType: FormulaTokenType {
        get() {
            return FormulaTokenType.Function
        }
    }

    override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Operator, FormulaTokenType.NoToken]
        }
    }

    prop name: String
    prop args: Array<FormulaToken>

    func execute(formula: Formula): Float64

    override operator func ==(another: FormulaToken): Bool {
        if (!(another is VariableFormulaToken)) {
            return false
        }
        let functionToken = (another as FunctionFormulaToken).getOrThrow()
        return name == functionToken.name && args == functionToken.args && leftAccept == functionToken.leftAccept && rightAccept == functionToken.rightAccept
    }

    override func toString(): String {
        return "Function"
    }

}

internal class InternalFormulaFormulaToken <: FormulaFormulaToken {

    private let _formula: Formula

    public override prop formula: Formula {
        get() {
            return this._formula
        }
    }

    public InternalFormulaFormulaToken(formula: Formula) {
        this._formula = formula
    }

    public override func calculate(formula: Formula) {
        this._formula.syncVariables(formula)
        return this._formula.calculate()
    }

    public override operator func ==(another: FormulaToken): Bool {
        if (!(another is FormulaFormulaToken)) {
            return false
        }
        return false
    }

}

internal class InternalVariableFormulaToken <: VariableFormulaToken {

    private let _variable: String
    private let _args: Array<String>

    public prop variable: String {
        get() {
            return this._variable
        }
    }

    public prop args: Array<String> {
        get() {
            return this._args
        }
    }

    InternalVariableFormulaToken(variable: String, args: Array<String>) {
        this._variable = variable
        this._args = args
    }

    public override func get(variables: Collection<FormulaVariable>): Float64 {
        for (variable in variables) {
            if (variable.keyword == this._variable) {
                return variable.get(this._args)
            }
        }
        throw FormulaVariableException()
    }

}

internal class InternalConstantFormulaToken <: ConstantFormulaToken {

    private let _value: Float64

    public prop value: Float64 {
        get() {
            return this._value
        }
    }

    InternalConstantFormulaToken(value: Float64) {
        this._value = value
    }

}

internal class InternalFunctionFormulaToken <: FunctionFormulaToken {

    private let _function: FormulaFunction
    private let _args: Array<FormulaToken>

    public prop name: String {
        get() {
            return this._function.name
        }
    }

    public prop args: Array<FormulaToken> {
        get() {
            return this._args
        }
    }

    InternalFunctionFormulaToken(function: FormulaFunction, args: Array<FormulaToken>) {
        this._function = function
        this._args = args
    }

    public override func execute(formula: Formula): Float64 {
        return this._function.execute(this._args.map { it => formula.getValue(it)})
    }

}

internal class PlusOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: PlusOperatorFormulaToken = PlusOperatorFormulaToken()

    private PlusOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'+'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 1
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        return left.getOrThrow { => FormulaNoValueException()} + right.getOrThrow { => FormulaNoValueException()};
    }

    public override func toString(): String {
        return "Plus"
    }
    
}

internal class MinusOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: MinusOperatorFormulaToken = MinusOperatorFormulaToken()

    private MinusOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'-'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 1
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        return left.getOrThrow { => FormulaNoValueException()} - right.getOrThrow { => FormulaNoValueException()};
    }

    public override func toString(): String {
        return "Minus"
    }
    
}

internal class UnaryMinusOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: UnaryMinusOperatorFormulaToken = UnaryMinusOperatorFormulaToken()

    private UnaryMinusOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.NoToken]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'-'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 1
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return false
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(_: Option<Float64>, right: Option<Float64>): Float64 {
        return -right.getOrThrow { => FormulaNoValueException()};
    }

    public override func toString(): String {
        return "UnaryMinus"
    }
    
}

internal class TimesOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: TimesOperatorFormulaToken = TimesOperatorFormulaToken()

    private TimesOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'*'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 2
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        return left.getOrThrow { => FormulaNoValueException()} * right.getOrThrow { => FormulaNoValueException()};
    }

    public override func toString(): String {
        return "Times"
    }
    
}

internal class DivisionOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: DivisionOperatorFormulaToken = DivisionOperatorFormulaToken()

    private DivisionOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'/'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 2
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        return left.getOrThrow { => FormulaNoValueException()} / right.getOrThrow { => FormulaNoValueException()};
    }

    public override func toString(): String {
        return "Division"
    }
    
}

internal class RemainderOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: RemainderOperatorFormulaToken = RemainderOperatorFormulaToken()

    private RemainderOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'%'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 2
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        return fmod(left.getOrThrow { => FormulaNoValueException()}, right.getOrThrow { => FormulaNoValueException()})
    }

    public override func toString(): String {
        return "Remainder"
    }
    
}

internal class PowerOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: PowerOperatorFormulaToken = PowerOperatorFormulaToken()

    private PowerOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'^'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 3
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        return left.getOrThrow { => FormulaNoValueException()} ** right.getOrThrow { => FormulaNoValueException()};
    }

    public override func toString(): String {
        return "Power"
    }
    
}

internal class GreatorOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: GreatorOperatorFormulaToken = GreatorOperatorFormulaToken()

    private GreatorOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'>'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 5
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        if (left.getOrThrow { => FormulaNoValueException()} > right.getOrThrow { => FormulaNoValueException() }) {
            return 1.0;
        } else {
            return 0.0;
        }
    }

    public override func toString(): String {
        return "Greator"
    }
    
}

internal class SmallerOperatorFormulaToken <: OperatorFormulaToken {

    public static let INSTANCE: SmallerOperatorFormulaToken = SmallerOperatorFormulaToken()

    private SmallerOperatorFormulaToken() {}

    public override prop leftAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop rightAccept: Option<Array<FormulaTokenType>> {
        get() {
            return [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function]
        }
    }

    public override prop key: Rune {
        get() {
            return r'<'
        }
    }

    public override prop priority: Int64 {
        get() {
            return 5
        }
    }

    public override prop removeLeft: Bool {
        get() {
            return true
        }
    }

    public override prop removeRight: Bool {
        get() {
            return true
        }
    }

    public override func calculate(left: Option<Float64>, right: Option<Float64>): Float64 {
        if (left.getOrThrow { => FormulaNoValueException()} < right.getOrThrow { => FormulaNoValueException() }) {
            return 1.0;
        } else {
            return 0.0;
        }
    }

    public override func toString(): String {
        return "Smaller"
    }
    
}