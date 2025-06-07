import SwiftUI
import SwiftUICore

struct CellView : View {
    let viewModel: CellViewModel
    
    var body: some View {
        Button(action: {}) {
            switch viewModel.state() {
            case .flagged:
                Text("🚩")
            case .hidden:
                Text("")
            case .revealed(let adjacentMines, let isMine):
                if isMine {
                    Text("M")
                } else {
                    Text("\(adjacentMines)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background {
            switch viewModel.state() {
            case .revealed:
                Color.gray
            case .flagged, .hidden:
                Color.blue
            }
        }
    }
}
