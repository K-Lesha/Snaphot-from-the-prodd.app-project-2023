import Foundation

enum AssistantType {
    case sound
    case videoAssistant
}

class AssistantsViewPresenter: ObservableObject {
    
    @Published var assistantViewModels: [AssistantViewModel] = []
    var type: AssistantType
    
    var choosedViewModel: AssistantViewModel? {
        didSet {
            if let id = choosedViewModel?.assistantData.voiceOverID {
                DraftService.shared.add(voiceover: choosedViewModel?.assistantData)
                NotificationCenter.default.post(name: Notification.Name("calcVoiceoverOrder"), object: nil)
            }
        }
    }
     
    init(type: AssistantType) {
        self.type = type
        fetchViewModels()
    }
    
    func chooseFirstViewModel() {
        guard let firstViewModel = assistantViewModels.first else {
            return
        }
        chooseViewModel(viewModel: firstViewModel)
        for otherViewModel in assistantViewModels.dropFirst() {
            unchooseViewModel(viewModel: otherViewModel)
        }
    }
    
    func chooseOneViewModel(viewModel: AssistantViewModel) {
        assistantViewModels.forEach { viewModelFromArray in
            if viewModel.id == viewModelFromArray.id {
                chooseViewModel(viewModel: viewModelFromArray)
            } else {
                unchooseViewModel(viewModel: viewModelFromArray)
            }
        }
    }
    
    private func chooseViewModel(viewModel: AssistantViewModel) {
        viewModel.isChoised = true
        choosedViewModel = viewModel
    }
    
    private func unchooseViewModel(viewModel: AssistantViewModel) {
        viewModel.isChoised = false
    }
    
    func unchooseAllViewModels() {
        assistantViewModels.forEach { viewModel in
            unchooseViewModel(viewModel: viewModel)
        }
    }
    
    func fetchViewModels() {
        guard let voiceovers = DictionariesService.shared.voiceOvers() else {
            return
        }
        let type = type == .sound ? 1 : 2
        
        let filtredVoiceovers = voiceovers.filter { $0.type == type }
        
        filtredVoiceovers.forEach { voiceOver in
            let assistant = AssistantData(title: voiceOver.title,
                                          previewImageURL: voiceOver.preview,
                                          videoURLToShowAsPreview: voiceOver.image,
                                          FullVieoURL: voiceOver.sound,
                                          voiceOverID: voiceOver.voiceoverID,
                                          typeID: voiceOver.type)
            let viewModel = AssistantViewModel(assistantData: assistant,
                                               parentPresenter: self)
            assistantViewModels.append(viewModel)
        }
        chooseFirstViewModel()
    }
}
