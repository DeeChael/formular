package formular

import std.collection.*
import std.convert.*

class FormulaParser {

    public static func parser(): FormulaParser {
        let parser = FormulaParser()
        parser.registerDefualtOperators()
        parser.registerDefaultFunctions()
        return parser
    }

    private let operators: List<OperatorFormulaToken> = ArrayList()
    private let functions: List<FormulaFunction> = ArrayList()

    func registerDefualtOperators() {
        this.registerOperator(PlusOperatorFormulaToken.INSTANCE)
        this.registerOperator(MinusOperatorFormulaToken.INSTANCE)
        this.registerOperator(UnaryMinusOperatorFormulaToken.INSTANCE)
        this.registerOperator(TimesOperatorFormulaToken.INSTANCE)
        this.registerOperator(DivisionOperatorFormulaToken.INSTANCE)
        this.registerOperator(RemainderOperatorFormulaToken.INSTANCE)
        this.registerOperator(PowerOperatorFormulaToken.INSTANCE)
        this.registerOperator(GreatorOperatorFormulaToken.INSTANCE)
        this.registerOperator(SmallerOperatorFormulaToken.INSTANCE)
    }

    func registerDefaultFunctions() {
        this.registerFunction(SqrtFormulaFunction.INSTANCE)
        this.registerFunction(CbrtFormulaFunction.INSTANCE)
        this.registerFunction(RoundFormulaFunction.INSTANCE)
        this.registerFunction(CeilFormulaFunction.INSTANCE)
        this.registerFunction(FloorFormulaFunction.INSTANCE)
        this.registerFunction(AbsFormulaFunction.INSTANCE)
        this.registerFunction(AcosFormulaFunction.INSTANCE)
        this.registerFunction(AcoshFormulaFunction.INSTANCE)
        this.registerFunction(AsinFormulaFunction.INSTANCE)
        this.registerFunction(AsinhFormulaFunction.INSTANCE)
        this.registerFunction(AtanFormulaFunction.INSTANCE)
        this.registerFunction(Atan2FormulaFunction.INSTANCE)
        this.registerFunction(AtanhFormulaFunction.INSTANCE)
        this.registerFunction(CosFormulaFunction.INSTANCE)
        this.registerFunction(CoshFormulaFunction.INSTANCE)
        this.registerFunction(SinFormulaFunction.INSTANCE)
        this.registerFunction(SinhFormulaFunction.INSTANCE)
        this.registerFunction(TanFormulaFunction.INSTANCE)
        this.registerFunction(TanhFormulaFunction.INSTANCE)
        this.registerFunction(LnFormulaFunction.INSTANCE)
        this.registerFunction(LgFormulaFunction.INSTANCE)
        this.registerFunction(LogFormulaFunction.INSTANCE)
        this.registerFunction(TruncFormulaFunction.INSTANCE)
        this.registerFunction(ClampFormulaFunction.INSTANCE)
        this.registerFunction(MinFormulaFunction.INSTANCE)
        this.registerFunction(MaxFormulaFunction.INSTANCE)
        this.registerFunction(ConditionFormulaFunction.INSTANCE)
    }

    func registerOperator(token: OperatorFormulaToken) {
        this.operators.removeIf { it => it == token}
        this.operators.add(token)
    }

    func registerFunction(token: FormulaFunction) {
        this.functions.removeIf { it => it == token}
        this.functions.add(token)
    }

    func parse(input: String): Formula {
        return Formula(tokenize(input))
    }

    func tokenize(input: String): List<FormulaToken> {
        let tokens: ArrayList<FormulaToken> = ArrayList()
        let reader = FormulaReader(input)
        while (reader.readable()) {
            let token = this.tryParseToken(reader, tokens.last)
            if (token.isNone()) {
                continue
            }
            tokens.add(token.getOrThrow())
        }
        return tokens
    }

    private func tryParseToken(reader: FormulaReader, lastToken: Option<FormulaToken>): Option<FormulaToken> {
        if (!reader.readable()) {
            return None
        }
        var char = reader.read()
        while (char.isAsciiWhiteSpace()) {
            char = reader.read()
        }
        if (char.isAsciiWhiteSpace()) {
            return None
        }
        if (char == r'(') {
            var moreBrackets = 0
            let formula = StringBuilder()
            var formulaOk = false
            while (reader.readable()) {
                let nextChar = reader.read()
                if (nextChar == r'(')   {
                    moreBrackets += 1
                }
                if (nextChar == r')') {
                    moreBrackets -= 1
                }
                if (moreBrackets == -1) {
                    formulaOk = true
                    break
                }
                formula.append(nextChar)
            }
            let formulaString = formula.toString()
            if (!formulaOk || isBlankOrEmpty(formulaString.toString())) {
                throw FormulaParserException()
            }
            let tokenizedFormula = this.tokenize(formulaString)
            if (tokenizedFormula.size == 1) {
                if (!this.isTokenTypeCorrect(tokenizedFormula[0], [FormulaTokenType.Variable, FormulaTokenType.Constant, FormulaTokenType.Formula, FormulaTokenType.Function])) {
                    throw FormulaParserException()
                }
            }
            let position = reader.position()
            let formulaToken = InternalFormulaFormulaToken(Formula(tokenizedFormula))
            reader.move(position)
            return formulaToken
        }
        for (operatorToken in this.operators) {
            if (char == operatorToken.key && this.isTokenTypeCorrect(lastToken, operatorToken.leftAccept)) {
                return operatorToken
            }
        }
        let literal = char.toString() + reader.readUntilNotVariable()

        if (isBlankOrEmpty(literal)) {
            throw FormulaParserException()
        }

        if (isFloat64(literal)) {
            return InternalConstantFormulaToken(Float64.parse(literal))
        }

        if (!literal.contains(":") && reader.readable()) {
            let fallbackPosition = reader.position()
            var char = reader.read()
            while (char.isAsciiWhiteSpace()) {
                char = reader.read()
            }
            if (char == r'(') {
                var moreBrackets = 0
                let formula = StringBuilder()
                var formulaOk = false
                while (reader.readable()) {
                    let nextChar = reader.read()
                    if (nextChar == r'(')   {
                        moreBrackets += 1
                    }
                    if (nextChar == r')') {
                        moreBrackets -= 1
                    }
                    if (moreBrackets == -1) {
                        formulaOk = true
                        break
                    }
                    formula.append(nextChar)
                }
                let formulaString = formula.toString()
                if (!formulaOk) {
                    throw FormulaParserException()
                }
                let parameters = this.tryParseFunctionParameters(formulaString)
                let function = this.functions |> find { it => it.name == literal && it.args == parameters.size} 
                if (function.isNone()) {
                    reader.move(fallbackPosition)
                } else {
                    return InternalFunctionFormulaToken(function.getOrThrow(), parameters.toArray())
                }
            } else {
                reader.move(fallbackPosition)
            }
        }

        let trimmedLiteral = literal.trimStart { it => it == r':' }.trimEnd { it => it == r':' }
        let variable: String
        let args: Array<String>
        if (trimmedLiteral.contains(":")) {
            let split = trimmedLiteral.split(":", 2)
            variable = split[0]
            args = split[1].split(":", removeEmpty: true)
        } else {
            variable = trimmedLiteral
            args = []
        }
        
        return InternalVariableFormulaToken(variable, args)
    }

    private func tryParseFunctionParameters(input: String): List<FormulaToken> {
        if (isBlankOrEmpty(input)) {
            return ArrayList()
        }
        let tokens: ArrayList<FormulaToken> = ArrayList()
        let reader = FormulaReader(input)
        while (reader.readable()) {
            tokens.add(this.tryParseSingleFunctionParameter(reader))
        }
        return tokens
    }

    private func tryParseSingleFunctionParameter(reader: FormulaReader): FormulaToken {
        var moreBrackets = -1
        let formula = StringBuilder()
        var formulaOk = false
        while (reader.readable()) {
            let nextChar = reader.read()
            if (nextChar == r'(')   {
                moreBrackets += 1
            }
            if (nextChar == r')') {
                moreBrackets -= 1
            }
            if (moreBrackets == -1) {
                if (nextChar == r',') {
                    formulaOk = true
                    break
                }
            }
            formula.append(nextChar)

            if (reader.restReadableAllBlank()) {
                formulaOk = true
            }
        }
        let formulaString = formula.toString()
        if (!formulaOk || isBlankOrEmpty(formulaString)) {
            throw FormulaParserException()
        }
        return InternalFormulaFormulaToken(Formula(this.tokenize(formulaString)))
    }

    private func isTokenTypeCorrect(token: Option<FormulaToken>, tokenType: Option<Array<FormulaTokenType>>): Bool {
        if (tokenType.isNone()) {
            return true
        }
        if (token.isNone()) {
            if (tokenType.getOrThrow().contains(FormulaTokenType.NoToken)) {
                return true
            }
            return false
        }
        return tokenType.getOrThrow().contains(token.getOrThrow().tokenType)
    }

}