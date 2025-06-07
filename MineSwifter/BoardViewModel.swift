import Foundation

@MainActor final class BoardViewModel: ObservableObject {
    @Published private(set) var board: [[CellViewModel]] = []
    private let model: BoardModel
    
    init(rows: Int = 5, cols: Int = 5, mines: Int = 5, minePositionsTest: [Int]? = nil) {
        self.model = BoardModel(rows: rows, cols: cols, mines: mines, minePositionsTest: minePositionsTest)
        self.board = model.board.map { row in
            row.map { CellViewModel(model: $0) }
        }
    }
}   
