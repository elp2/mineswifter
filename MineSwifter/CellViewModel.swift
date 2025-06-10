import Foundation

enum CellState : Equatable {
    case hidden
    case flagged
    case revealedAdjacent(adjacentMines: Int)
    case revealedMineLost
    case revealedMineWon
}

struct CellViewModel : Identifiable {
    let id = UUID()
    var model: CellModel
    var boardState: BoardState
    
    func state() -> CellState {
        if model.isRevealed {
            if model.isMine {
                return boardState == .lost ? .revealedMineLost : .revealedMineWon
            } else {
                return .revealedAdjacent(adjacentMines: model.adjacentMines)
            }
        } else if model.isFlagged {
            return .flagged
        } else {
            return .hidden
        }
    }
}
