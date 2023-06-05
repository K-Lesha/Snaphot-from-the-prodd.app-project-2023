import SwiftUI

struct AssistantCellView: View {
    @ObservedObject var viewModel: AssistantViewModel
    
    var body: some View {
        VStack {
            if viewModel.isChoised {
                videoPlayer()
            } else {
                previewImage()
            }
        }
        .overlay (
            strokeBorder()
        )
    }
    
    private func previewImage() -> some View {
        ZStack {
            if viewModel.previewImage == nil {
                LoadingView()
            } else {
                viewModel.previewImage!
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                    .clipped()
            }
        }
    }

    private func videoPlayer() -> some View {
        VStack {
            VideoPlayerView(viewModel: viewModel.videoViewModel)
                .overlay(
                    ZStack {
                        title()
                        activeOverlay()
                    }
                )
        }
        .sheet(isPresented: $viewModel.isFullVideo, onDismiss: {
            viewModel.videoViewModel.turnOnThePlayer()
        }) {
            fullScreenPlayer()
        }
    }
    
    private func title() -> some View {
        VStack {
            Spacer()
            Text(viewModel.assistantData.title)
                .font(.title2.bold())
                .foregroundColor(Color.purpleProdd)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
        }
    }
    
    private func strokeBorder() -> some View {
        ZStack {
            if !viewModel.isChoised {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.7))
                    .onTapGesture {
                        viewModel.wasChoosed()
                    }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.purpleProdd, lineWidth: 2)
            }
        }
    }
    
    func activeOverlay() -> some View {
        ZStack {
            if viewModel.isChoised {
                Rectangle()
                    .foregroundColor(.white.opacity(0.001))
                    .onTapGesture {
                        viewModel.isFullVideo.toggle()
                        viewModel.videoViewModel.turnOffThePlayer()
                    }
            }
        }
    }
    
    func fullScreenPlayer() -> some View {
        ZStack {
            if let url = URL(string: viewModel.assistantData.FullVieoURL ?? "") {
                FullScreenVideoPlayer(url: url)
            }
        }
    }
}
