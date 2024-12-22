//
//  HomeView.swift
//  RemoteControlApp
//
//  Created by Zafran on 10/10/2024.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @State private var selectedSegment: String = "Remote".localized
    @State private var navigateSetting: Bool = false
    @State private var isGoToUpgrade: Bool = false
    @State private var isGoToFaq: Bool = false
    @EnvironmentObject var userViewModel : UserViewModel
    @Environment(\.requestReview) var requestReview
    @State private var saveRateCount = UserDefaults.standard.integer(forKey: "isRateCount")
    @ObservedObject private var isRateViewModel = isRateModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                
                HStack {
                    Text("remote_control".localized)
                        .font(.system(size: 22, type: .Bold))
                        .foregroundColor(Color.tintstatic)
                    Spacer()
                    
                    HStack(spacing: 15) {
                        Image("crown")
                            .onTapGesture {
                                isGoToUpgrade.toggle()
                            }
                        Image("settings")
                            .onTapGesture {
                                navigateSetting.toggle()
                            }
                        Image("faq")
                            .onTapGesture {
                                isGoToFaq.toggle()
                            }
                    }
                }
                .padding()
                .background(Color.secondaryBg)
                
                
                
                // Segmented control for Remote/Channel
                HStack {
                    Button(action: {
                        selectedSegment = "Remote".localized
                    }) {
                        HStack{
                            Image("remote").renderingMode(.template)
                            Text("Remote".localized)
                                .font(.system(size: 17, type: .Bold))
                            
                        }
                        
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(selectedSegment == "Remote".localized ? Color.tintstatic : Color.clear)
                        .cornerRadius(10)
                        .foregroundColor(selectedSegment == "Remote".localized ? .black : Color.tintTertiary)
                        
                    }
                    
                    Button(action: {
                        selectedSegment = "Channel".localized
                    }) {
                        HStack {
                            Image("channel").renderingMode(.template)
                            Text("Channel".localized)
                                .font(.system(size: 17, type: .Bold))
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(selectedSegment == "Channel".localized ? Color.tintstatic : Color.clear)
                        .cornerRadius(10)
                        .foregroundColor(selectedSegment == "Channel".localized ? Color.tintSecondary : Color.tintTertiary)
                    }
                }
                .background(Color.secondaryFill)
                .cornerRadius(12)
                .padding(.vertical)
                
                ScrollView {
                    if selectedSegment == "Channel".localized {
                        ChannelView(isGoToUpgradePro: $isGoToUpgrade)
                    } else {
                        RemoteView(isGoToUpgradePro: $isGoToUpgrade)
                    }
                }
                Spacer()
                
            }
            .padding(.bottom)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear() {
                saveRateCount += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let isRatecount = isRateViewModel.israte {
                        if saveRateCount == isRatecount {
                            requestReview()
                        }
                    }
                }
                
                UserDefaults.standard.set(saveRateCount, forKey: "isRateCount")
            }
            .background(Color.secondaryBg)
            .navigationDestination(isPresented: $isGoToUpgrade, destination: {
                UpgradeToPro(isGoToUpgradePro: $isGoToUpgrade)
            })
            .navigationDestination(isPresented: $isGoToFaq, destination: {
                FAQView()
            })
            .navigationDestination(isPresented: $navigateSetting, destination: {
                SettingView()
            })
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func checkSubscriptionAndNavigate() {
        print("Checking subscription status in ChannelView...")
        if userViewModel.isSubscriptionActive {
            print("User is subscribed. No navigation to UpgradeToPro.")
        } else {
            print("User is not subscribed. Navigating to UpgradeToPro.")
            isGoToUpgrade = true
        }
    }
}

struct ChannelView: View {
    @Binding var isGoToUpgradePro: Bool
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            
            ForEach(serviceButtons) { service in
                Button(action: {
                    
                }) {
                    Image(service.imageName)
                        .padding(.top, 5)
                        .onTapGesture {
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            checkSubscriptionAndNavigate()
                        }
                    
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func checkSubscriptionAndNavigate() {
        print("Checking subscription status in ChannelView...")
        if userViewModel.isSubscriptionActive {
            print("User is subscribed. No navigation to UpgradeToPro.")
        } else {
            print("User is not subscribed. Navigating to UpgradeToPro.")
            isGoToUpgradePro = true
        }
    }
}

struct RemoteView: View {
    @Binding var isGoToUpgradePro: Bool
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View {
        VStack() {
            HStack() {
                IconView(image: "off", buttonClick: {
                    checkSubscriptionAndNavigate()
                })
                IconView(image: "keyboard", buttonClick: {
                    checkSubscriptionAndNavigate()
                })
                IconView(image: "home", buttonClick: {
                    checkSubscriptionAndNavigate()
                })
                IconView(image: "forward", buttonClick: {
                    checkSubscriptionAndNavigate()
                })
            }
            HStack{
                IconView(image: "plusminus", buttonClick: {
                    checkSubscriptionAndNavigate()
                })
                VStack{
                    HStack{
                        IconView(image: "number", buttonClick: {
                            checkSubscriptionAndNavigate()
                        })
                        IconView(image: "volumn", buttonClick: {
                            checkSubscriptionAndNavigate()
                        })
                    }
                    HStack{
                        IconView(image: "previous", buttonClick: {
                            checkSubscriptionAndNavigate()
                        })
                        IconView(image: "forward", buttonClick: {
                            checkSubscriptionAndNavigate()
                        })
                    }
                }
                
                IconView(image: "updown", buttonClick: {
                    checkSubscriptionAndNavigate()
                })
            }
            
            IconView(image: "maincontrol", buttonClick: {
                checkSubscriptionAndNavigate()
            })
        }
        .padding(30)
        .background(Color.secondaryBg)
        .cornerRadius(20)
    }
    
    private func checkSubscriptionAndNavigate() {
        print("Checking subscription status in ChannelView...")
        if userViewModel.isSubscriptionActive {
            print("User is subscribed. No navigation to UpgradeToPro.")
        } else {
            print("User is not subscribed. Navigating to UpgradeToPro.")
            isGoToUpgradePro = true
        }
    }
}

struct IconView: View {
    var image: String
    var buttonClick: () -> Void
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            buttonClick()
        }, label: {
            Image(image)
        })
    }
}

struct Service: Identifiable {
    let id = UUID()
    let imageName: String
}

let serviceButtons: [Service] = [
    Service(imageName: "netflix"),
    Service(imageName: "youtube"),
    Service(imageName: "hulu"),
    Service(imageName: "disney"),
    Service(imageName: "primevideo"),
    Service(imageName: "hbomax"),
    Service(imageName: "roku"),
    Service(imageName: "sling"),
    Service(imageName: "tubi"),
    Service(imageName: "peacock")
]


#Preview {
    HomeView()
}

import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: filename)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            animationView.stop()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
