import SwiftUI

struct AppInfo: Codable { let name, bundleID, version, downloadURL, iconURL: String }

struct ContentView: View {
 @State var apps: [AppInfo] = []
 var body: some View {
  NavigationView {
   List(apps, id: \.bundleID) { app in
    HStack {
     AsyncImage(url: URL(string: app.iconURL)) { $0.resizable().frame(width:50,height:50).cornerRadius(10) } placeholder: { Color.gray.frame(width:50,height:50) }
     VStack(alignment:.leading){ Text(app.name).bold(); Text(app.version).font(.caption) }
     Spacer()
     Button("Get") { install(app: app) }.buttonStyle(.borderedProminent)
    }
   }.navigationTitle("Silicon Store").onAppear { loadApps() }
  }
 }
 func loadApps() {
  // lädt deine wdsb0h.json
  guard let url = URL(string: "https://polite-pastelito-e246f2.netlify.app/apps.json") else { return }
  URLSession.shared.dataTask(with: url) { d,_,_ in
   if let d = d { apps = (try? JSONDecoder().decode([AppInfo].self, from: d))?? [] }
  }.resume()
 }
 func install(app: AppInfo) {
  // Erstellt manifest on-the-fly und öffnet itms
  let manifestURL = "https://files.catbox.moe/\(app.bundleID).plist" // du musst plist für jede App erstellen
  let itms = "itms-services://?action=download-manifest&url=\(manifestURL)"
  UIApplication.shared.open(URL(string: itms)!)
 }
}