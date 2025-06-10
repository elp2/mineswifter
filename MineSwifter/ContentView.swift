import SwiftUI

enum Tool: Hashable { case reveal, flag, move }

class GameTimer: ObservableObject {
    @Published var seconds: Int = 0
    private var timer: Timer?
    
    func start() {
        timer?.invalidate()
        seconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.seconds += 1
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView: View, BoardDelegate {
    @State var tool: Tool = .reveal
    @StateObject private var boardVM = BoardViewModel()
    @StateObject private var gameTimer = GameTimer()

    var body: some View {
        VStack(spacing: 16) {
            BoardView(vm: boardVM, delegate: self)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                Label("\(boardVM.mineCount)", systemImage: "flag.fill")
                    .labelStyle(.titleAndIcon)
                    .font(.title3.monospacedDigit())

                Spacer(minLength: 32)

                Button(action: { newGame() }) { Text("💥").font(.title) }

                Spacer(minLength: 32)

                Label(String(format: "%02d:%02d", gameTimer.seconds / 60, gameTimer.seconds % 60), systemImage: "timer")
                    .labelStyle(.titleAndIcon)
                    .font(.title3.monospacedDigit())
            }
            .padding([.horizontal, .top])
            .background {
                Rectangle()
                    .fill(.thinMaterial)
                    .ignoresSafeArea(edges: .top)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Picker("Tool", selection: $tool) {
                Text("Reveal").tag(Tool.reveal)
                Text("Flag").tag(Tool.flag)
                Text("Move").tag(Tool.move)
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .top])
            .background(.thinMaterial)
        }
        .onAppear {
            newGame()
        }
        .alert("You Won!", isPresented: .constant(boardVM.gameState == .won)) {
            Button("New Game") {
                newGame()
            }
        } message: {
            Text("Congratulations! You found all the mines!")
        }
        .alert("You Lost!", isPresented: .constant(boardVM.gameState == .lost)) {
            Button("New Game") {
                newGame()
            }
        } message: {
            Text("You blew up! Maybe next time!")
        }
    }
    
    func updateMines(_ count: Int) {
    }
    
    private func newGame() {
        boardVM.newGame()
        gameTimer.start()
    }
    
    func wonGame() {
        gameTimer.stop()
    }
    
    func lostGame() {
        gameTimer.stop()
    }
}

#Preview {
    ContentView()
}
