import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @ObservedObject var viewModel: VideoViewModel
    
    var body: some View {
        VStack {
            VideoPlayer(player: viewModel.player)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .onAppear {
            viewModel.turnOnThePlayer()
        }
        .onDisappear {
            viewModel.turnOffThePlayer()
        }
    }

}
