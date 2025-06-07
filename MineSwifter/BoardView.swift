import SwiftUI

protocol TapModeDelegate {
    var tool: Tool { get }
}

struct BoardView : View {
    @ObservedObject var vm: BoardViewModel
    let tapModeDelegate: TapModeDelegate
    
    func onCellTapped(_ row: Int, _ col: Int) {
        if tapModeDelegate.tool == .move {
            // Drag interpreted as a tap, ignore.
            print("Drag interpreted as a tap, ignoring at", row, col)
            return
        } else if tapModeDelegate.tool == .flag {
            vm.flagCell(row: row, col: col)
        } else if tapModeDelegate.tool == .reveal {
            vm.revealCell(row: row, col: col)
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
                                onCellTapped(row, col)
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
