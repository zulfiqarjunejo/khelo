import SwiftUI

struct ContentView: View {
    @State private var message = "Hello, Zulfiqar!"

    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .font(.largeTitle)

            Button("Change Message") {
                message = "You pressed the button! 🎉"
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
