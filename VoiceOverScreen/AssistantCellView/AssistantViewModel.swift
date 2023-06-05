import Foundation
import SwiftUI
import Alamofire

class AssistantViewModel: ObservableObject, Identifiable {
    
    var parentPresenter: AssistantsViewPresenter
    
    @Published var assistantData: AssistantData
    
    @Published var previewImage: Image?
    @Published var videoViewModel: VideoViewModel
    @Published var isFullVideo: Bool = false
    @Published var isChoised: Bool = false {
        didSet {
            if isChoised {
                videoViewModel.turnOnThePlayer()
            } else {
                videoViewModel.turnOffThePlayer()
            }
        }
    }

    init(assistantData: AssistantData, parentPresenter: AssistantsViewPresenter) {
        self.parentPresenter = parentPresenter
        self.assistantData = assistantData
        self.videoViewModel = VideoViewModel(url: assistantData.videoURLToShowAsPreview)
        self.downloadPreviewImage()
    }
    
    func wasChoosed() {
        parentPresenter.chooseOneViewModel(viewModel: self)
    }
    
    func downloadPreviewImage() {
        let url = assistantData.previewImageURL

        Alamofire.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let uiPreviewImage = UIImage(data: data) {
                    self.previewImage = Image(uiImage: uiPreviewImage)
                } else {
                    print("Failed to create UIImage")
                }
            case .failure(let error):
                print("Failed to download image: \(error.localizedDescription)")
            }
        }
    }
}
