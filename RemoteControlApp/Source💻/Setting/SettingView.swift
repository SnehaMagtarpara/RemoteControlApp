//
//  SettingView.swift
//  RemoteControlApp
//
//  Created by Zafran on 10/10/2024.
//

import SwiftUI
import MessageUI

struct SettingView: View {
    @ObservedObject private var mailIDViewModel = mailViewModel()
    @ObservedObject private var privacyPolicyID = privacyModel()
    @ObservedObject private var shareAppID = appLinkModel()
    
    @EnvironmentObject var appState: AppState
    @State private var showMailComposer: Bool = false
    @State private var showAlert: Bool = false
    @State private var mailError: String = ""
    @State private var isGoToUpgrade: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
               
                HStack(spacing: 15) {
                    Image("back")
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    Text("Settings".localized)
                        .font(.system(size: 22, type: .Bold))
                        .foregroundColor(Color.tintstatic)
                    Spacer()
                }
            }
            .padding()
            .background(Color.secondaryBg)
            
            
            VStack(spacing: 14) {
                Image("settingbanner")
                    .onTapGesture {
                        isGoToUpgrade.toggle()
                    }
                    .padding()
                
                DetailView(image: "language", buttonText: "Change language".localized, buttonClick: {
                    appState.hasSeenLanguage = false
                })
                DetailView(image: "tvbrand", buttonText: "TV Brand".localized, buttonClick: {
                    appState.hasSeenSelectTVBrand = false
                })
                
                DetailView(image: "share", buttonText: "Share".localized, buttonClick: {
                    share()
                })
                DetailView(image: "rate", buttonText: "Rate US".localized, buttonClick: {
                    rateUs()
                })
                DetailView(image: "feedback", buttonText: "Feedback".localized, buttonClick: {
                    feedback()
                })
                DetailView(image: "shield", buttonText: "Privacy Policy".localized, buttonClick: {
                    privacyPolicy()
                })
            }
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea(.all))
        .navigationDestination(isPresented: $isGoToUpgrade, destination: {
            UpgradeToPro(isGoToUpgradePro: $isGoToUpgrade)
        })
        .navigationBarBackButtonHidden(true)
    }
    
    
    func share() {
        if let appLink = shareAppID.shareAppID {
            let text = "Check out my app at \(appLink)"
            let url = URL(string: "\(appLink)")!
            let activityItems: [Any] = [text, url]
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func rateUs() {
        if let appLink = shareAppID.shareAppID {
            let text = "Rate our app: \(appLink)"
            let url = URL(string: "\(appLink)")!
            let activityItems: [Any] = [text, url]
            let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func redirectToAppStoreForReview() {
        let appStoreURL = URL(string: "https://apps.apple.com/app/id6705136133?action=write-review")!
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
    
    func feedback() {
        if MFMailComposeViewController.canSendMail() {
            showMailComposer = true
        } else {
            mailError = "Mail services are not available on this device."
            showAlert = true
        }
    }
    
    func privacyPolicy() {
        
        if let privacyLink = privacyPolicyID.privacyPolicy, let url = URL(string: privacyLink) {
            //MyWebView(url: URL(string: privacyLink)!, NavBarTitle: "Privacy Policy")
            UIApplication.shared.open(url)
        }
    }
}

struct MailComposerView: UIViewControllerRepresentable {
    var recipients: [String]
    var completion: (Result<Bool, Error>) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(recipients)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposerView
        
        init(_ parent: MailComposerView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.completion(.failure(error))
                controller.dismiss(animated: true)
                return
            }
            
            switch result {
            case .sent:
                parent.completion(.success(true))
            default:
                parent.completion(.success(false))
            }
            controller.dismiss(animated: true)
        }
    }
}

#Preview {
    SettingView()
}

struct DetailView: View {
    var image: String
    var buttonText: String
    var buttonClick: () -> Void
    
    var body: some View {
        Button(action: buttonClick, label: {
            HStack{
                Image(image)
                Text(buttonText)
                    .font(.system(size: 17, type: .Regular))
                    .foregroundStyle(Color.tintTertiary)
                Spacer()
            }
            .padding()
            .background(Color.secondaryBg)
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
        })
    }
}
