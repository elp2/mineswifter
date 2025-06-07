import Foundation

enum CellState : Equatable {
    case hidden
    case flagged
    case revealed(adjacentMines: Int, isMine: Bool)
}

struct CellViewModel : Identifiable {
    let id = UUID()
    var model: CellModel
    
    func state() -> CellState {
        if model.isRevealed {
            return .revealed(
                adjacentMines: model.adjacentMines,
                isMine: model.isMine
            )
        } else if model.isFlagged {
            return .flagged
        } else {
            return .hidden
        }
    }
}
