enum RevealResult : Equatable {
    case won
    case lost
    case flagged
    case revealed(cellsRevealed: Int)
}

enum BoardState : Equatable {
    case ongoing
    case won
    case lost
}

class BoardModel {
    var board: [[CellModel]] = []
    var mines: Int = 0
    var totalRevealed: Int = 0
    var rows: Int = 0
    var cols: Int = 0
    var minePositionsTest: [Int] = []
    var boardState: BoardState = .ongoing

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
        boardState = .ongoing
        totalRevealed = 0
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

    func flagCell(row: Int, col: Int) {
        board[row][col].isFlagged = !board[row][col].isFlagged
    }

    func revealCell(row: Int, col: Int) -> RevealResult {
        if board[row][col].isFlagged {
            return .flagged
        } else if board[row][col].isRevealed {
            return .revealed(cellsRevealed: 0)
        }
        
        if board[row][col].isMine {
            revealAllItems()
            boardState = .lost
            return .lost
        }
        
        var cellsRevealed = 0
        var queue = [(row, col)] as [(Int, Int)]
        while !queue.isEmpty {
            let (r, c) = queue.removeFirst()
            assert(!board[r][c].isMine)
            
            // Skip if already revealed
            if board[r][c].isRevealed {
                continue
            }
            
            board[r][c].isRevealed = true
            cellsRevealed += 1
            totalRevealed += 1
            if totalRevealed == (rows * cols - mines) {
                boardState = .won
                revealAllItems()
                return .won
            }
            // If it's empty (no adjacent mines), add adjacent cells to queue
            if board[r][c].adjacentMines == 0 {
                for i in (-1 + r)...(1 + r) {
                    for j in (-1 + c)...(1 + c) {
                        if (i == r && j == c) || i < 0 || i >= rows || j < 0 || j >= cols {
                            continue
                        }
                        queue.append((i, j))
                    }
                }
            }
        }
        
        return .revealed(cellsRevealed: cellsRevealed)
    }
    
    func revealAdjacent(row: Int, col: Int) -> RevealResult {
        if !board[row][col].isRevealed {
            return .revealed(cellsRevealed: 0)
        }
        if board[row][col].adjacentMines == 0 {
            return .revealed(cellsRevealed: 0)
        }
        var adjacentEmpty : [(Int, Int)] = []
        var adjacentFlags = 0
        for i in (-1 + row)...(1 + row) {
            for j in (-1 + col)...(1 + col) {
                if (i == row && j == col) || i < 0 || i >= rows || j < 0 || j >= cols {
                    continue
                }
                if board[i][j].isFlagged {
                    adjacentFlags += 1
                } else {
                    adjacentEmpty.append((i, j))
                }
            }
        }
        if adjacentFlags != board[row][col].adjacentMines {
            return .revealed(cellsRevealed: 0)
        }
        var revealedCells = 0
        for (nr, nc) in adjacentEmpty {
            let rr = revealCell(row: nr, col: nc)
            switch rr {
            case .won:
                return .won
            case .lost:
                return .lost
            case .flagged:
                preconditionFailure("Flagged cells found when revealing adjacent cells.")
            case .revealed(cellsRevealed: let c):
                revealedCells += c
            }
        }
        return .revealed(cellsRevealed: revealedCells)
    }
    
    func revealAllItems() {
        for i in 0..<rows {
            for j in 0..<cols {
                board[i][j].isRevealed = true
            }
        }
    }
}
