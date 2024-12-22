//
//  FaqQuestionView.swift
//  RemoteControlApp
//
//  Created by Zafran on 10/10/2024.
//

import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    var isExpanded: Bool = false
}

struct FAQView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var faqItems = [
        FAQItem(question: "1. I can't find my Smart TV.",
                answer: """
Try the following to resolve the issue:
- Make sure that both your phone and Smart TV are connected to the same WiFi network.
- Restart your Smart TV, app, or WiFi router.
If the issue isn't solved after doing the above, Click here to tell us.
"""),
        FAQItem(question: "2. How to connect to my TV?",
                answer: """
1. Turn on TV
2. Tap [ADD REMOTE] on the homepage
3. Choose the type of your TV Remote:
   - If you choose IR TV Remote, make sure your phone has a built-in IR (infrared blaster)
   - If you choose Smart TV Remote, connect to the same WiFi on your phone and TV.
4. Then select the TV you want to connect and save the remote for future use.
"""),
        FAQItem(question: "3. My TV doesn't have WiFi capability. Can I use this app?",
                answer: """
Yes. You can try using IR TV Remote to control your TV. It requires your phone to have a built-in IR (infrared blaster).
* Unfortunately, Smart TV Remote is not available for TVs without WiFi capability.
"""),
        FAQItem(question: "4. It doesn't have my TV brand.",
                answer: """
Please click here to tell us your TV brand, and we will do our best to add it in future updates.
"""),
        FAQItem(question: "5. Do I need a physical remote to use this app?",
                answer: """
This depends on your TV's configuration:
- If your TV is connected to WiFi, you can use this app directly on your phone.
- If not, a physical remote control may be necessary to configure the settings on your TV.
"""),
        FAQItem(question: "6. Device found but can't connect?",
                answer: """
                    LG: The first time you connect, you need to pair the application with your TV by entering the PIN code displayed on the TV.
                    Samsung: For Samsung TVs, when connecting for the first time, your TV will ask whether it should accept incoming connections. Select "Allow".
                    """),
        FAQItem(question: "7. What if I selected 'Deny' connection by mistake on Samsung TV?",
                answer: """
                    For Samsung TVs, go to [Network] -> [AllShare Settings] -> [Content Sharing], then select the device and change its status to 'Allow.'
                    """),
        FAQItem(question: "8. PIN code doesn't display on my Sony TV.",
                answer: """
                    Please make sure that the renderer function is enabled. Go to [Settings] -> [Network] -> [Remote Device/Renderer], and turn on [Renderer function].
                    """),
        FAQItem(question: "9. How to enable [ADB debugging] on Fire TV?",
                answer: """
                    To connect to Fire TV, enable [ADB debugging]. Go to [Settings] -> [My Fire TV] -> [Developer options] -> [ADB debugging].
                    """),
        FAQItem(question: "10. How to use this app while the Sony TV is in standby mode?",
                answer: """
                    Set the (Remote Start) function to [On] to use this app while your Sony TV is in standby mode. Go to [Setup] -> [Network Settings] -> [Remote Start].
                    """),
        FAQItem(question: "11. How to cast from my phone to TV?",
                answer: """
                    1. Connect your phone to the TV.
                    2. Go to the [Cast] page and select the content you want to cast.
                    """),
        FAQItem(question: "12. I can't detect the cast device.",
                answer: """
                    Make sure your phone and the cast device are on the same Wi-Fi network and that VPN is disabled.
                    """),
        FAQItem(question: "13. Why can't I cast or mirror certain videos?",
                answer: """
                    DRM-protected content like Netflix, Hulu, and Prime Video cannot be cast due to copyright protection.
                    """),
        FAQItem(question: "14. Is the application safe?",
                answer: """
                    The app uses your private Wi-Fi network for communication between your phone and the Smart TV, ensuring privacy and security.
                    """)
    ]
    
    var body: some View {
        VStack {
            HStack {
               
                HStack(spacing: 15) {
                    Image("back")
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    Text("FAQ")
                        .font(.system(size: 22, type: .Bold))
                        .foregroundColor(Color.tintstatic)
                    Spacer()
                }
            }
            .padding()
            .background(Color.secondaryBg)
            
            List {
                ForEach(faqItems.indices, id: \.self) { index in
                    FAQRow(faqItem: $faqItems[index])
                }
                .listRowInsets(EdgeInsets())

                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct FAQRow: View {
    @Binding var faqItem: FAQItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                faqItem.isExpanded.toggle()
            }) {
                HStack {
                    Text(faqItem.question)
                        .font(.system(size: 17, type: .Regular))
                        .foregroundColor(Color.tintTertiary)
                    Spacer()
                    Image(faqItem.isExpanded ? "chevron.up" : "chevron.down")
                        
                }
                .padding()
                .background(Color.secondaryBg)
                .cornerRadius(10)
            }
            
            if faqItem.isExpanded {
                Text(faqItem.answer)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(Color.tintstatic)
                    //.transition(.slide)
                    //.animation(.easeInOut)
            }
        }
        .padding(.vertical, 5)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    FAQView()
}
