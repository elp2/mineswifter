import SwiftUI

struct BoardView : View {
    @ObservedObject var vm: BoardViewModel
    
    var body: some View {
        VStack {
            ForEach(0..<vm.board.count, id: \.self) { row in
                HStack {
                    ForEach(0..<vm.board[row].count, id: \.self) { col in
                        CellView(viewModel: vm.board[row][col])
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
