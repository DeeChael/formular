package formular

import std.math.*

interface FormulaFunction <: Equatable<FormulaFunction> {

    prop name: String
    prop args: Int64

    func execute(args: Array<Float64>): Float64

    override operator func ==(another: FormulaFunction): Bool {
        return this.name == another.name && this.args == another.args
    }

}

internal class SqrtFormulaFunction <: FormulaFunction {

    public static let INSTANCE: SqrtFormulaFunction = SqrtFormulaFunction()

    private SqrtFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "sqrt"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return sqrt(args[0])
    }

}

internal class CbrtFormulaFunction <: FormulaFunction {

    public static let INSTANCE: CbrtFormulaFunction = CbrtFormulaFunction()

    private CbrtFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "cbrt"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return cbrt(args[0])
    }

}

internal class RoundFormulaFunction <: FormulaFunction {

    public static let INSTANCE: RoundFormulaFunction = RoundFormulaFunction()

    private RoundFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "round"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return round(args[0])
    }

}

internal class CeilFormulaFunction <: FormulaFunction {

    public static let INSTANCE: CeilFormulaFunction = CeilFormulaFunction()

    private CeilFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "ceil"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return ceil(args[0])
    }

}

internal class FloorFormulaFunction <: FormulaFunction {

    public static let INSTANCE: FloorFormulaFunction = FloorFormulaFunction()

    private FloorFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "floor"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return floor(args[0])
    }

}

internal class AbsFormulaFunction <: FormulaFunction {

    public static let INSTANCE: AbsFormulaFunction = AbsFormulaFunction()

    private AbsFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "abs"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return abs(args[0])
    }

}

internal class AcosFormulaFunction <: FormulaFunction {

    public static let INSTANCE: AcosFormulaFunction = AcosFormulaFunction()

    private AcosFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "acos"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return acos(args[0])
    }

}

internal class AcoshFormulaFunction <: FormulaFunction {

    public static let INSTANCE: AcoshFormulaFunction = AcoshFormulaFunction()

    private AcoshFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "acosh"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return acosh(args[0])
    }

}

internal class AsinFormulaFunction <: FormulaFunction {

    public static let INSTANCE: AsinFormulaFunction = AsinFormulaFunction()

    private AsinFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "asin"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return asin(args[0])
    }

}

internal class AsinhFormulaFunction <: FormulaFunction {

    public static let INSTANCE: AsinhFormulaFunction = AsinhFormulaFunction()

    private AsinhFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "asinh"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return asinh(args[0])
    }

}

internal class AtanFormulaFunction <: FormulaFunction {

    public static let INSTANCE: AtanFormulaFunction = AtanFormulaFunction()

    private AtanFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "atan"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return atan(args[0])
    }

}

internal class Atan2FormulaFunction <: FormulaFunction {

    public static let INSTANCE: Atan2FormulaFunction = Atan2FormulaFunction()

    private Atan2FormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "atan2"
        }
    }

    public override prop args: Int64 {
        get() {
            return 2
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return atan2(args[0], args[1])
    }

}

internal class AtanhFormulaFunction <: FormulaFunction {

    public static let INSTANCE: AtanhFormulaFunction = AtanhFormulaFunction()

    private AtanhFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "atanh"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return atanh(args[0])
    }

}

internal class CosFormulaFunction <: FormulaFunction {

    public static let INSTANCE: CosFormulaFunction = CosFormulaFunction()

    private CosFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "cos"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return cos(args[0])
    }

}

internal class CoshFormulaFunction <: FormulaFunction {

    public static let INSTANCE: CoshFormulaFunction = CoshFormulaFunction()

    private CoshFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "cosh"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return cosh(args[0])
    }

}

internal class SinFormulaFunction <: FormulaFunction {

    public static let INSTANCE: SinFormulaFunction = SinFormulaFunction()

    private SinFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "sin"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return sin(args[0])
    }

}

internal class SinhFormulaFunction <: FormulaFunction {

    public static let INSTANCE: SinhFormulaFunction = SinhFormulaFunction()

    private SinhFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "sinh"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return sinh(args[0])
    }

}

internal class TanFormulaFunction <: FormulaFunction {

    public static let INSTANCE: TanFormulaFunction = TanFormulaFunction()

    private TanFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "tan"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return tan(args[0])
    }

}

internal class TanhFormulaFunction <: FormulaFunction {

    public static let INSTANCE: TanhFormulaFunction = TanhFormulaFunction()

    private TanhFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "tanh"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return tanh(args[0])
    }

}

internal class LnFormulaFunction <: FormulaFunction {

    public static let INSTANCE: LnFormulaFunction = LnFormulaFunction()

    private LnFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "ln"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return log(args[0])
    }

}

internal class LgFormulaFunction <: FormulaFunction {

    public static let INSTANCE: LgFormulaFunction = LgFormulaFunction()

    private LgFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "lg"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return log10(args[0])
    }

}

internal class LogFormulaFunction <: FormulaFunction {

    public static let INSTANCE: LogFormulaFunction = LogFormulaFunction()

    private LogFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "log"
        }
    }

    public override prop args: Int64 {
        get() {
            return 2
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return logBase(args[0], args[1])
    }

}

internal class TruncFormulaFunction <: FormulaFunction {

    public static let INSTANCE: TruncFormulaFunction = TruncFormulaFunction()

    private TruncFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "trunc"
        }
    }

    public override prop args: Int64 {
        get() {
            return 1
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return trunc(args[0])
    }

}

internal class ClampFormulaFunction <: FormulaFunction {

    public static let INSTANCE: ClampFormulaFunction = ClampFormulaFunction()

    private ClampFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "clamp"
        }
    }

    public override prop args: Int64 {
        get() {
            return 3
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return clamp(args[0], args[1], args[2])
    }

}

internal class MinFormulaFunction <: FormulaFunction {

    public static let INSTANCE: MinFormulaFunction = MinFormulaFunction()

    private MinFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "min"
        }
    }

    public override prop args: Int64 {
        get() {
            return 2
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return min(args[0], args[1])
    }

}

internal class MaxFormulaFunction <: FormulaFunction {

    public static let INSTANCE: MaxFormulaFunction = MaxFormulaFunction()

    private MaxFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "max"
        }
    }

    public override prop args: Int64 {
        get() {
            return 2
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        return max(args[0], args[1])
    }

}

internal class ConditionFormulaFunction <: FormulaFunction {

    public static let INSTANCE: ConditionFormulaFunction = ConditionFormulaFunction()

    private ConditionFormulaFunction() {
    }

    public override prop name: String {
        get() {
            return "condition"
        }
    }

    public override prop args: Int64 {
        get() {
            return 3
        }
    }

    public override func execute(args: Array<Float64>): Float64 {
        if (args[0] != 0.0) {
            return args[1]
        } else {
            return args[2]
        }
    }

}