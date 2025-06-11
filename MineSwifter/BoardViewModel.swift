import Foundation

enum GameState {
    case playing
    case won
    case lost
}

@MainActor final class BoardViewModel: ObservableObject {
    @Published private(set) var board: [[CellViewModel]] = []
    @Published private(set) var mineCount: Int = 0
    @Published private(set) var gameState: GameState = .playing
    private let model: BoardModel
    
    init(rows: Int = 5, cols: Int = 5, mines: Int = 5, minePositionsTest: [Int]? = nil) {
        self.model = BoardModel(rows: rows, cols: cols, mines: mines, minePositionsTest: minePositionsTest)
        self.refreshBoard()
        self.mineCount = mines
    }
    
    func newGame() {
        model.reset()
        self.refreshBoard()
        self.mineCount = model.mines
        self.gameState = .playing
    }
    
    func flagCell(row: Int, col: Int) {
        guard gameState == .playing else { return }
        model.flagCell(row: row, col: col)
        self.refreshBoard()
        let flagCount = model.board.flatMap { $0 }.filter { $0.isFlagged }.count
        self.mineCount = model.mines - flagCount
        objectWillChange.send()
    }

    func revealCell(row: Int, col: Int) {
        guard gameState == .playing else { return }
        let result = model.revealCell(row: row, col: col)
        refreshBoard()
        
        switch result {
        case .won:
            gameState = .won
        case .lost:
            gameState = .lost
        default:
            break
        }
        objectWillChange.send()
    }
    
    func revealAdjacent(row: Int, col: Int) {
        guard gameState == .playing else { return }
        let result = model.revealAdjacent(row: row, col: col)
        refreshBoard()
        
        switch result {
        case .won:
            gameState = .won
        case .lost:
            gameState = .lost
        default:
            break
        }
        objectWillChange.send()
    }
    
    private func refreshBoard() {
        board = model.board.map { row in
            row.map { CellViewModel(model: $0, boardState: model.boardState) }
        }
    }
}
