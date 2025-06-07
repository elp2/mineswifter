class BoardModel {
    var board: [[CellModel]] = []
    var mines: Int = 0
    var rows: Int = 0
    var cols: Int = 0
    var minePositionsTest: [Int] = []

    init(rows: Int, cols: Int, mines: Int, minePositionsTest: [Int]? = nil) {
        self.rows = rows
        self.cols = cols
        self.mines = mines
        self.minePositionsTest = minePositionsTest ?? []
        for _ in 0..<rows {
            var row: [CellModel] = []
            for _ in 0..<cols {
                row.append(CellModel())
            }
            board.append(row)
        }
        self.reset()
    }

    func reset() {
        for row in board {
            for cell in row {
                cell.isMine = false
                cell.isFlagged = false
                cell.isRevealed = false
                cell.adjacentMines = 0
            }
        }

        for minePosition in minePositions() {
            let row = minePosition / cols
            let col = minePosition % cols
            addMineAt(row: row, col: col)
        }
    }

    private func minePositions() -> [Int] {
        if minePositionsTest.count != 0 {
            assert(minePositionsTest.count == mines)
            return minePositionsTest
        }
        var minePositions = Array(0..<rows * cols)
        minePositions.shuffle()
        return Array(minePositions.prefix(mines))
    }

    private func addMineAt(row: Int, col: Int) {
        board[row][col].isMine = true
        for i in (-1 + row)...(1 + row) {
            for j in (-1 + col)...(1 + col) {
                if i == row && j == col || i < 0 || i >= rows || j < 0 || j >= cols {
                    continue
                }
                board[i][j].adjacentMines += 1
            }
        }
    }
}
