//
//  SelectTvBrandView.swift
//  RemoteControlApp
//
//  Created by Zafran on 07/10/2024.
//

import SwiftUI
import MessageUI

struct SelectTVBrandView: View {
    @State private var searchText = "search Channel".localized
    @State private var infoIconClick = false
    @State private var brandName = "Enter Brand Name"
    @State private var modelName = "Enter Model Name"
    @State private var showMailComposer = false
    @State private var showMailError = false
    @EnvironmentObject var appState: AppState
    @ObservedObject private var mail = mailViewModel()
    
    let brandLogos = [
        "panasonic", "roku.icon", "sony", "tcl"
    ]
    
    let brandData = [
        "A": ["Acer", "ACONATIC", "Admiral Vi", "Alwa", "AKAI", "Aiwa", "ALBA", "Alba", "ALLSAT", "Allsat", "Amazon", "Amstrad", "ANIMAX", "Animax", "AOC", "AOPEN", "Aopen", "Apple", "Arcelik", "ARISTONA", "Aristona", "Aspire", "Astro", "Asus", "Atec", "Audiovox"],
        "B": ["Bang & Olufsen", "Barco", "BBK", "Beko", "Belkin", "BenQ", "Benq", "BGH", "Bgh", "Blaupunkt", "Bush"],
        "C": ["Cambridge Audio", "Canalsat", "Canon", "Casio", "Cce", "Challenger", "CHANGHONG", "Chang Hong", "Clarion", "Coby", "Comcast", "Condor", "Conrad", "Cox", "CREATIVE", "Creative", "Curtis"],
        "D": ["Daewoo", "Daytron", "Dell", "Denon", "Denver", "Dexp", "Dicksmith", "Directv", "Dream Multimedia", "Dual", "Durabrand", "Dy audio", "D-link"],
        "E": ["Echostar", "Element", "Elenberg", "Emerson", "Epson"],
        "F": ["Fagor", "Ferguson", "Finlux", "Fisher", "Foxtel", "Fujitsu", "Fujitsu Siemens", "Funai"],
        "G": ["General Instrument", "Geniatech", "Gigabyte", "Golden Interstate", "Goldstar", "Goodmans", "Govideo", "Gradiente", "Graetz", "Grandin", "Grundig"],
        "H": ["Haier", "Hama", "Hannspree", "Harman Kardon", "Hauppauge", "Hello Kitty", "Hisense", "Hitachi", "Horizont", "Hp", "Huawei", "Hughes", "Human", "Hyundai"],
        "I": ["Ibm", "Imex", "Imon", "Infects", "Insignia", "Ivc"],
        "K": ["Kaon", "Kathrein", "Kawa", "Kendo", "Kenwood", "Kolin", "Konka", "Korting", "Kworld"],
        "L": ["Lenovo", "Lg", "Linksys", "Loewe", "Logitech", "Lutron"],
        "M": ["Magnavox", "Maranta", "Metz", "Micromax", "Microsoft", "Mitsai", "Mitsubishi", "Mivar", "Monoprice", "Motorola", "Msi", "Ms Tech", "Multi Canal"],
        "N": ["Nad", "Nakamichi", "Nebula", "New", "Nextwave", "Nexus Tv", "Nikai", "Nikko", "Noblex", "Nokia"],
        "O": ["Oki", "Olevia", "O TV", "One For All", "Onida", "Onkyo", "Optex", "Orava", "Orion"],
        "P": ["Packard Bell", "Palcom", "Panasonic", "Philco", "Philex", "Philips", "Pioneer", "Pixel view", "Polaroid", "Pollin"],
        "R": ["Radio Shack", "Rca", "Rega", "Remotec", "Replay", "Revo", "Roku", "Rolsen", "Rowa", "Rubin"],
        "S": ["Sab", "Saba", "Salora", "Samsung", "Samy", "Sansui", "Sanyo", "Schneider", "Schwaiger", "Scientific Atlanta"],
        "T": ["Tatasky", "TCL", "TEAC", "Teac", "Technics", "TechniSat", "Technisat", "Technotrend", "TECO", "Teco", "Telecom Italia", "Telefunken", "Telenet", "Tesla", "T.Vii", "Tevii", "Thinkgeek", "Thomson", "Time", "Time Warner Cable", "Tivo", "Topfield", "Toshiba", "Turtlebeach"],
        "U": ["Umc", "Uniden"],
        "V": ["Venturer", "Vestel", "Videocon", "Videocon Dth", "Viewsonic", "Viore", "Virgin Media", "Visionetics", "Vistron", "Vitek", "Vivanco", "Vivax", "Vizio", "Voxson"],
        "W": ["Wansa", "WD", "Western Digital", "Westinghouse", "Wharfedale"],
        "X": ["Xiaomi", "Xtreamer", "Xoro"],
        "Y": ["Yamaha"],
        "Z": ["Zalman", "Zenith", "Zoltrix", "ZYXEL", "Zyxel"]
    ]
    
    
    var filteredBrands: [String] {
        let allBrands = brandData.flatMap { $0.value }
        if searchText.isEmpty {
            return allBrands
        } else {
            return allBrands.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                Text("Select TV Brand".localized)
                    .font(.system(size: 18, type: .Bold))
                    .foregroundColor(Color.tintstatic)
                
                Spacer()
                
                Button(action: {
                    infoIconClick.toggle()
                }) {
                    Image("info")
                    
                }
            }
            .padding()
            .background(Color.secondaryBg)
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Search Here".localized)
                            .foregroundColor(.white)
                    }
                    TextField("", text: $searchText)
                        .foregroundColor(.white)
                }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 55)
            .background(Color.secondaryBg)
            .cornerRadius(8)
            
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                ForEach(brandLogos, id: \.self) { logo in
                    Image(logo)
                        .resizable()
                        .frame(width: 150,height: 50)
                        .onTapGesture {
                            appState.hasSeenSelectTVBrand = true
                        }
                }
            }
            .padding(.vertical)
            
            ZStack(alignment: .trailing) {
                if !searchText.isEmpty {
                    List(filteredBrands, id: \.self) { brand in
                        Text(brand)
                            .font(.system(size: 17, type: .Bold))
                            .foregroundColor(.white)
                            .onTapGesture {
                                appState.hasSeenSelectTVBrand = true
                            }
                            .listRowBackground(Color.clear)
                    }
                    .listRowSpacing(0)
                    .scrollContentBackground(.hidden)
                    .listStyle(GroupedListStyle())
                } else {
                    // A-Z List of brandData when not searching
                    List {
                        ForEach(brandData.keys.sorted(), id: \.self) { letter in
                            Section(header: Text(letter)
                                .font(.headline)
                                .foregroundColor(.white)) {
                                    ForEach(brandData[letter]!, id: \.self) { brand in
                                        Text(brand)
                                            .font(.system(size: 17, type: .Bold))
                                            .foregroundColor(.white)
                                            .onTapGesture {
                                                appState.hasSeenSelectTVBrand = true
                                            }
                                    }
                                }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listRowSpacing(0)
                    .scrollContentBackground(.hidden)
                    .listStyle(GroupedListStyle())
                }
                
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $infoIconClick) {
            BottomSheetView(showMailComposer: $showMailComposer, brandName: $brandName, modelName: $modelName)
                .presentationDetents([.height(450)])
                
        }
        .sheet(isPresented: $showMailComposer) {
            MailComposeView(showing: $showMailComposer, result: $showMailError, recipientEmail: mail.mailID ?? "Patrickridd10@icloud.com", brand: brandName, model: modelName)
        }
        .onAppear {
            
            searchText = ""
            brandName = "Enter Brand Name".localized
            modelName = "Enter Model Name".localized
        }
    }
}

#Preview {
    SelectTVBrandView()
}

struct MailComposeView: UIViewControllerRepresentable {
    @Binding var showing: Bool
    @Binding var result: Bool
    var recipientEmail: String
    var brand: String
    var model: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.setToRecipients([recipientEmail])
        mailComposeVC.setSubject("Inquiry about \(brand) \(model)")
        mailComposeVC.setMessageBody("I would like to inquire about...", isHTML: false)
        mailComposeVC.mailComposeDelegate = context.coordinator
        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeView

        init(_ parent: MailComposeView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
            parent.showing = false
            parent.result = error == nil
        }
    }
}

// A-Z Navigation
//                VStack {
//                    Image(systemName: "star.fill")
//                        .foregroundStyle(Color.red)
//                    Spacer()
//                    ForEach(brandData.keys.sorted(), id: \.self) { letter in
//                        Text(letter)
//                            .foregroundColor(.white)
//                            .font(.system(size: 12, weight: .bold))
//                            .padding(.bottom, 0.2)
//                            .onTapGesture {
//
//                            }
//                    }
//                }
//                .padding(8)
//                .background(Color.primaryFill)
//                .cornerRadius(15)
//List {
//    ForEach(brandData.keys.sorted(), id: \.self) { letter in
//        Section(header: Text(letter)
//            .font(.headline)
//            .foregroundColor(.white)) {
//                ForEach(brandData[letter]!, id: \.self) { brand in
//                    Text(brand)
//                        .font(.system(size: 17, type: .Bold))
//                        .foregroundStyle(Color.white)
//                        .onTapGesture {
//                            appState.hasSeenSelectTVBrand = true
//                        }
//                }
//            }
//    }
//    .listRowBackground(Color.clear)
//}
//.listRowSpacing(0)
//.scrollContentBackground(.hidden)
//.listStyle(GroupedListStyle())

