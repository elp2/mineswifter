import SwiftUI

enum Tool: Hashable { case reveal, flag, move }

struct ContentView: View, TapModeDelegate {
    @State var minesLeft: String = "10"
    @State var seconds: String = "00:00"
    @State var onReset: () -> Void = {}
    @State var tool: Tool = .reveal

    var body: some View {
        VStack(spacing: 16) {
            BoardView(vm: BoardViewModel(), tapModeDelegate: self)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            HStack {
                Label("\(minesLeft)", systemImage: "flag.fill")
                    .labelStyle(.titleAndIcon)		
                    .font(.title3.monospacedDigit())

                Spacer(minLength: 32)

                Button(action: onReset) { Text("💥").font(.title) }

                Spacer(minLength: 32)

                Label("\(seconds)", systemImage: "timer")
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
    }
}

#Preview {
    ContentView()
}
