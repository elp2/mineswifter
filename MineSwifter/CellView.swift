import SwiftUI
import SwiftUICore

struct CellView : View {
    let viewModel: CellViewModel
    
    var body: some View {
        Group {
            switch viewModel.state() {
            case .flagged:
                Image("flag")
                    .resizable()
                    .scaledToFit()
                    .padding(4)
            case .hidden:
                Text("")
            case .revealedAdjacent(let adjacentMines):
                if adjacentMines == 0 {
                    Text("")
                } else {
                    Text("\(adjacentMines)")
                }
            case .revealedMineLost:
                Image("mine_exploded")
                    .resizable()
                    .scaledToFit()
                    .padding(4)
            case .revealedMineWon:
                    Image("mine")
                        .resizable()
                        .scaledToFit()
                        .padding(4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background {
            switch viewModel.state() {
            case .revealedMineWon, .revealedMineLost, .revealedAdjacent:
                Color.gray
            case .flagged, .hidden:
                Color.blue
            }
        }
    }
}
