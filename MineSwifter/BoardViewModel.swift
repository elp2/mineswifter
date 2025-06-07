import Foundation

@MainActor final class BoardViewModel: ObservableObject {
    @Published private(set) var board: [[CellViewModel]] = []
    private let model: BoardModel
    
    init(rows: Int = 5, cols: Int = 5, mines: Int = 5, minePositionsTest: [Int]? = nil) {
        self.model = BoardModel(rows: rows, cols: cols, mines: mines, minePositionsTest: minePositionsTest)
        self.refreshBoard()
    }

    func flagCell(row: Int, col: Int) {
        model.flagCell(row: row, col: col)
        self.refreshBoard()
        objectWillChange.send()
    }

    func revealCell(row: Int, col: Int) {
        model.revealCell(row: row, col: col)
        self.refreshBoard()
        objectWillChange.send()
    }
    
    private func refreshBoard() {
        board = model.board.map { row in
            row.map { CellViewModel(model: $0) }
        }
    }
}
