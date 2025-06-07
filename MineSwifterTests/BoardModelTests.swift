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

}
