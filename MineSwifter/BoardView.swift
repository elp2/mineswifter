import SwiftUI

protocol BoardDelegate {
    var tool: Tool { get }
    func updateMines(_ count: Int)
    func wonGame()
    func lostGame()
}

struct BoardView : View {
    @ObservedObject var vm: BoardViewModel
    let delegate: BoardDelegate
    
    func onCellTapped(row: Int, col: Int) {
        if delegate.tool == .move {
            return
        } else if delegate.tool == .flag {
            vm.flagCell(row: row, col: col)
            delegate.updateMines(vm.mineCount)
        } else if delegate.tool == .reveal {
            vm.revealCell(row: row, col: col)
        }
    }
    
    func onCellDoubleTapped(row: Int, col: Int) {
        if delegate.tool == .reveal {
            vm.revealAdjacent(row: row, col: col)
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0..<vm.board.count, id: \.self) { row in
                HStack {
                    ForEach(0..<vm.board[row].count, id: \.self) { col in
                        CellView(viewModel: vm.board[row][col])
                            .contentShape(Rectangle())
                            .onTapGesture {
                                onCellTapped(row: row, col: col)
                            }
                            .onTapGesture(count: 2) {
                                onCellDoubleTapped(row: row, col: col)
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
