package formular

import std.collection.*

func isBlankOrEmpty(value: String): Bool {
    if (value.size == 0) {
        return true
    }
    for (rune in value) {
        if (!rune.isAsciiWhiteSpace()) {
            return false
        }
    }
    return true
}

func isFloat64(value: String): Bool {
    for (rune in value) {
        if (!rune.isAsciiNumber() && Rune(rune) != r'.') {
            return false
        }
    }
    return true
}

func find<T>(predicate: (T) -> Bool): (Iterable<T>) -> Option<T> { 
    return { iterable =>
        for (t in iterable) {
            if (predicate(t)) {
                return t
            }
        }
        return None
    }
}

extend ArrayList<FormulaToken> {

    func indexOfFirstOperatorWithPriority(priority: Int64): Int64 {
        for (i in 0..this.size) {
            if (this[i].tokenType == FormulaTokenType.Operator && (this[i] as OperatorFormulaToken).getOrThrow().priority == priority) {
                return i
            }
        }
        throw FormulaParserException()
    }

}