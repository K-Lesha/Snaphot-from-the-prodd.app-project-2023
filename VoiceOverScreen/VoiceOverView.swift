import SwiftUI

struct VoiceOverView: View {
    
    @ObservedObject var presenter: VoiceOverViewPresenter
    
    var body: some View {
        VStack(spacing: 5) {
            enableVoiceoverRow()
            voiceOverOptions()
            descriptionRow()
            Spacer()
            totalCostRow()
            continueButton()
        }
        .padding()
    }

    private func enableVoiceoverRow() -> some View {
        HStack {
            Text("Add Voiceover")
                .font(.largeTitle)
                .bold()
            Spacer()
            Toggle("", isOn: $presenter.isVoiceOverActive)
                .toggleStyle(ShakingToggleStyle(shakingState: ShakingState()))
        }
    }
    
    private func voiceOverOptions() -> some View {
        VStack {
            if presenter.isVoiceOverActive {
                enableSoundsRow()
                soundsScrollView()
                enableAssistantsRow()
                assistantsScrollView()
            }
        }
    }
    
    private func enableSoundsRow() -> some View {
        HStack {
            Text("Voiceover only")
                .font(.body.bold())
            Spacer()
            Toggle("", isOn: $presenter.isSoundsActive)
                .toggleStyle(ShakingToggleStyle(shakingState: ShakingState()))
        }
    }
    
    private func soundsScrollView()  -> some View {
        ZStack {
            if presenter.isSoundsActive {
                AssistantsScrollView(presenter: presenter.soundsViewPresenter)
            }
        }
    }
    
    private func enableAssistantsRow() -> some View {
        HStack {
            Text("Virtual presenter")
                .font(.body.bold())
            Spacer()
            Toggle("", isOn: $presenter.isAssistantActive)
                .toggleStyle(ShakingToggleStyle(shakingState: ShakingState()))
        }
    }
    
    private func assistantsScrollView()  -> some View {
        ZStack {
            if presenter.isAssistantActive {
                AssistantsScrollView(presenter: presenter.assistantViewPresenter)
            }
        }
    }
    
    private func descriptionRow() -> some View {
        Text(DictionariesService.shared.mediaDescriptionText() ?? "")
            .font(.subheadline)
    }
    
    private func totalCostRow() -> some View {
        HStack {
            Spacer()
            Text("Total cost - \(Int(presenter.currentCost))€")
                .font(.title3)
                .bold()
            Spacer()
        }
    }
    
    private func continueButton() -> some View {
        Button {
            presenter.continueToTheNextScreen()
        } label: {
            Text("Continue")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.purpleProdd)
                .cornerRadius(10)
        }
    }
    
}
