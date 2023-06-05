import Foundation
import Alamofire

class VoiceOverViewPresenter: ObservableObject {
    
    private var client: NetworkController

    weak var view: HostingViewController<VoiceOverView>?
    
    @Published var isVoiceOverActive: Bool = true {
        didSet {
            if isVoiceOverActive == false {
                let voiceoverID = DraftService.shared.add(voiceover: nil)
                calcOrders()
            } else {
                if isAssistantActive {
                    assistantViewPresenter.chooseFirstViewModel()
                } else {
                    soundsViewPresenter.chooseFirstViewModel()
                }
            }
        }
    }
    @Published var isAssistantActive: Bool = false {
        didSet {
            if isAssistantActive != oldValue {
                isSoundsActive = !isAssistantActive
                if isAssistantActive == false {
                    assistantViewPresenter.unchooseAllViewModels()
                } else {
                    assistantViewPresenter.chooseFirstViewModel()
                }
            }
        }
    }
    @Published var isSoundsActive: Bool = true {
        didSet {
            if isSoundsActive != oldValue {
                isAssistantActive = !isSoundsActive
                if isSoundsActive == false {
                    soundsViewPresenter.unchooseAllViewModels()
                } else {
                    soundsViewPresenter.chooseFirstViewModel()
                }
            }
        }
    }
    
    lazy var assistantViewPresenter = AssistantsScrollViewPresenter(type: .videoAssistant)
    lazy var soundsViewPresenter = AssistantsScrollViewPresenter(type: .sound)
    @Published var currentCost: Double
    
    init(cost: Double) {
        
        DraftService.shared.add(voiceover: nil)
        
        let requestHandler = RequestDecorator()
        
        let baseURL: String = ConfigurationService.shared.get(key: .apiBase)
        let networkController = NetworkController(base: baseURL, trustPolicies: [:])
        networkController.manager.retrier = requestHandler
        networkController.manager.adapter = requestHandler
        self.client = networkController
        
        self.currentCost = cost
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.calcOrders), name: Notification.Name("calcVoiceoverOrder"), object: nil)
    }
    
    func continueToTheNextScreen() {
        let controller = ViewFactory.shared.createFormatOptionsScreen(cost: currentCost)
        view?.push(viewController: controller)
    }
    
    private func onRecalculate(cost: Double?, message: String?) {
        guard let cost = cost else { return }
        currentCost = cost
    }
    
    @objc func calcOrders() {
        guard let deliveryId = DictionariesService.shared.getDefaultValueFor(type: .delivery) else { return }
        guard let styleId = DictionariesService.shared.getDefaultValueFor(type: .style) else { return }
        guard let formatId = DictionariesService.shared.getDefaultValueFor(type: .format) else { return }
        let content = DraftService.shared.draft?.content ?? ""
        let voiceoverTypeID = DraftService.shared.draft?.voiceover?.typeID ?? 0

        client.calcOrder(data: EncodableOrderCreationOrUpdation(content: content, deliveryId: deliveryId, styleId: styleId, formats: "\(formatId)", voiceoverID: nil, voiceoverTypeID: voiceoverTypeID, mediaId: ImageCacheService.shared.mediaLogoId, logoTypeId: ImageCacheService.shared.logoTypeId, mediaList: nil, comment: nil)).responseObject { (response: DataResponse<DecodableOrderCalc>) in
            switch response.result {
            case let .success(response):
                self.onRecalculate(cost: response.cost, message: response.message)
            case .failure(let error):
                self.onRecalculate(cost: nil, message: error.localizedDescription)
            }
        }
    }
}
