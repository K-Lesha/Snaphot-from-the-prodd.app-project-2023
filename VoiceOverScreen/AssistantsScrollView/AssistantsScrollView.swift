import SwiftUI

struct AssistantsScrollView: View {
    
    @ObservedObject var presenter: AssistantsScrollViewPresenter
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(presenter.assistantViewModels, id: \.id) { assistantViewModel in
                    AssistantCellView(viewModel: assistantViewModel)
                        .frame(maxWidth: 200, maxHeight: 200)
                }
            }
        }
    }
}
