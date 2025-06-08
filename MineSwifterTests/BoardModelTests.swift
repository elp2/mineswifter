import Testing
@testable import MineSwifter

struct BoardModelTests {

    @Test func testCenterMine() async throws {
        let boardModel = BoardModel(rows: 3, cols: 3, mines: 1, minePositionsTest: [4])
        #expect(boardModel.board.count == 3)
        #expect(boardModel.board[0].count == 3)
        #expect(boardModel.board[1][1].isMine)
        for i in 0..<3 {
            for j in 0..<3 {
                #expect(boardModel.board[i][j].isMine == (i == 1 && j == 1))
                #expect(boardModel.board[i][j].isRevealed == false)
                #expect(boardModel.board[i][j].adjacentMines == ((i == 1 && j == 1) ? 0 : 1))
            }
        }
    }

    @Test func test3x3RevealPartial() async throws {
        let boardModel = BoardModel(rows: 3, cols: 3, mines: 3, minePositionsTest: [2, 4, 6])
        let revealResult = boardModel.revealCell(row: 0, col: 0)
        #expect(revealResult == .revealed(cellsRevealed: 1))
        for i in 0..<3 {
            for j in 0..<3 {
                #expect(boardModel.board[i][j].isRevealed == (i == 0 && j == 0))
            }
        }
    }

    @Test func test5x5RevealPartial() async throws {
        let boardModel = BoardModel(rows: 5, cols: 5, mines: 5, minePositionsTest: [4, 8, 12, 16, 22])
        let revealResult = boardModel.revealCell(row: 0, col: 0)
        #expect(revealResult == .revealed(cellsRevealed: 8))
        #expect(boardModel.board[0][0].isRevealed)
        #expect(boardModel.board[0][1].isRevealed)
        #expect(boardModel.board[0][2].isRevealed)
        #expect(boardModel.board[1][0].isRevealed)
        #expect(boardModel.board[2][0].isRevealed)
        #expect(boardModel.board[1][1].isRevealed)
        #expect(boardModel.board[2][1].isRevealed)
        #expect(boardModel.board[1][2].isRevealed)
    }

    @Test func testWins3x3() async throws {
        let boardModel = BoardModel(rows: 3, cols: 3, mines: 1, minePositionsTest: [2])
        let revealResult = boardModel.revealCell(row: 0, col: 0)
        #expect(revealResult == .won)
    }

    @Test func testLoses3x3() async throws {
        let boardModel = BoardModel(rows: 3, cols: 3, mines: 1, minePositionsTest: [0])
        let revealResult = boardModel.revealCell(row: 0, col: 0)
        #expect(revealResult == .lost)
    }

}
