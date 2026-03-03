package formular

import std.math.*

interface FormulaVariable <: Equatable<FormulaVariable> {

    prop keyword: String

    func get(args: Array<String>): Float64

    override operator func ==(another: FormulaVariable): Bool {
        return this.keyword == another.keyword
    }

}

internal class SimpleFormulaVariable <: FormulaVariable {

    private let _keyword: String
    private let _value: Float64

    public override prop keyword: String {
        get() {
            return this._keyword
        }
    }

    SimpleFormulaVariable(keyword: String, value: Float64) {
        this._keyword = keyword
        this._value = value
    }

    public override func get(_: Array<String>): Float64 {
        return this._value
    }

}

internal class PiFormulaVariable <: FormulaVariable {

    public static let INSTANCE: PiFormulaVariable = PiFormulaVariable()

    public override prop keyword: String {
        get() {
            return "pi"
        }
    }

    private PiFormulaVariable() {
    }

    public override func get(_: Array<String>): Float64 {
        return Float64.getPI()
    }

}

internal class EFormulaVariable <: FormulaVariable {

    public static let INSTANCE: EFormulaVariable = EFormulaVariable()

    public override prop keyword: String {
        get() {
            return "e"
        }
    }

    private EFormulaVariable() {
    }

    public override func get(_: Array<String>): Float64 {
        return Float64.getE()
    }

}