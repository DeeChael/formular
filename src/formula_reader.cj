package formular

class FormulaReader {
    
    private var input: String
    private var cursor: Int64 = 0

    public FormulaReader(input: String) {
        this.input = input
    }

    func readUntilNotVariable(): String {
        let builder = StringBuilder()
        while (this.readable() && this.isVariableRune(this.peek())) {
            builder.append(this.read())
        }
        return builder.toString()
    }
    
    /*
    func skip() {
        this.cursor += 1
    }
    */

    func read(): Rune {
        let result = this.input[this.cursor]
        this.cursor += 1
        return Rune(result)
    }

    func peek(): Rune {
        return Rune(this.input[this.cursor])
    }

    func readable(): Bool {
        return this.input.size > this.cursor
    }

    func restReadableAllBlank(): Bool {
        for (i in this.cursor..this.input.size) {
            if (!isBlankOrEmpty(this.input[i].toString())) {
                return false
            }
        }
        return true
    }

    func position(): Int64 {
        return this.cursor
    }

    func move(position: Int64) {
        this.cursor = position
    }

    private func isVariableRune(rune: Rune) {
        return rune.isAsciiNumberOrLetter() || rune == r'_' || rune == r':' || rune == r'.'
    }

}