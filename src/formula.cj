package formular

import std.collection.*

class Formula <: Equatable<Formula> {

    private let tokens: ArrayList<FormulaToken> = ArrayList()
    private let variables: ArrayList<FormulaVariable> = ArrayList()

    private var internalVariables: Bool = false

    public Formula(tokens: Collection<FormulaToken>) {
        this.tokens.add(all: tokens)
    }

    public func enablePIAndE() {
        this.internalVariables = true
    }

    public func disablePIAndE() {
        this.internalVariables = false
    }

    public func set(variable: FormulaVariable) {
        this.variables.add(variable)
    }

    public func set(variable: String, value: Float64) {
        this.variables.add(SimpleFormulaVariable(variable, value))
    }

    public func syncVariables(from: Formula) {
        this.variables.add(all: from.variables)
    }

    public func calculate(): Float64 {
        if (this.internalVariables) {
            this.variables.add(PiFormulaVariable.INSTANCE)
            this.variables.add(GreekLowercasePiFormulaVariable.INSTANCE)
            this.variables.add(GreekUppercasePiFormulaVariable.INSTANCE)
            this.variables.add(EFormulaVariable.INSTANCE)
        }
        let copiedTokens = this.tokens.clone()
        for (priority in [5, 4, 3, 2, 1]) {
            while ((copiedTokens |> any { it => it.tokenType == FormulaTokenType.Operator && (it as OperatorFormulaToken).getOrThrow().priority == priority})) {
                var tokenIndex = copiedTokens.indexOfFirstOperatorWithPriority(priority)
                let operatorToken = (copiedTokens[tokenIndex] as OperatorFormulaToken).getOrThrow()
                if (!this.isTokenTypeCorrect(copiedTokens.get(tokenIndex - 1), operatorToken.leftAccept)) {
                    throw FormulaCalculationException()
                }
                if (!this.isTokenTypeCorrect(copiedTokens.get(tokenIndex + 1), operatorToken.rightAccept)) {
                    throw FormulaCalculationException()
                }
                let valueToken = InternalConstantFormulaToken(
                    operatorToken.calculate(
                        this.getUnsafeValue(copiedTokens.get(tokenIndex - 1)),
                        this.getUnsafeValue(copiedTokens.get(tokenIndex + 1))
                    )
                )
                if (operatorToken.removeLeft && tokenIndex > 0) {
                    copiedTokens.remove(at: tokenIndex - 1)
                    tokenIndex = tokenIndex - 1
                }
                if (operatorToken.removeRight && (tokenIndex + 1) < copiedTokens.size) {
                    copiedTokens.remove(at: tokenIndex + 1)
                }
                copiedTokens[tokenIndex] = valueToken
            }
        }
        if (copiedTokens.size != 1) {
            throw FormulaCalculationException()
        }
        let finalValue = this.getValue(copiedTokens[0])
        this.variables.clear()
        return finalValue
    }

    public func getValue(token: FormulaToken): Float64 {
        return match (token.tokenType) {
            case FormulaTokenType.Function => (token as FunctionFormulaToken).getOrThrow().execute(this)
            case FormulaTokenType.Formula => (token as FormulaFormulaToken).getOrThrow().calculate(this)
            case FormulaTokenType.Constant => (token as ConstantFormulaToken).getOrThrow().value
            case FormulaTokenType.Variable => (token as VariableFormulaToken).getOrThrow().get(this.variables)
            case _ => throw FormulaCalculationException()
        }
    }

    public override operator func ==(another: Formula): Bool {
        return this.tokens == another.tokens
    }

    private func getUnsafeValue(token: Option<FormulaToken>): Option<Float64> {
        return if (token.isSome()) {
            match (token.getOrThrow().tokenType) {
                case FormulaTokenType.Function => (token.getOrThrow() as FunctionFormulaToken).getOrThrow().execute(this)
                case FormulaTokenType.Formula => (token.getOrThrow() as FormulaFormulaToken).getOrThrow().calculate(this)
                case FormulaTokenType.Constant => (token.getOrThrow() as ConstantFormulaToken).getOrThrow().value
                case FormulaTokenType.Variable => (token.getOrThrow() as VariableFormulaToken).getOrThrow().get(this.variables)
                case _ => return None
            }
        } else {
            return None
        }
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