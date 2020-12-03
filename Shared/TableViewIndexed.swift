// Original article here: https://www.fivestars.blog/code/section-title-index-swiftui.html
import SwiftUI


let database: [String: [String]] = [
    "A": ["Anna", "Alfred"
    ],
    "B": ["Beate", "Bente"
    ],
    "C": ["Christine", "Charlotte"
    ],
    "D": ["Dante", "Dagfinn"
    ],
    "E": ["Erik", "Einar"
    ],
    "F": ["Fredrik", "Frantz"
    ]
]


struct HeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RowView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TableViewIndexed: View {
    //  let devices: [String: [String]] = database
    
    var persons = [Person]()
    var alphabet = ["B","A"].sorted()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    devicesList
                }
            }
            .overlay(sectionIndexTitles(proxy: proxy))
        }
        .navigationBarTitle("Apple Devices")
    }
    
    var devicesList: some View {
        
        //    ForEach(alphabet, id: \.self) { letter in
        //        Section(header: Text(letter) {
        //            ForEach(persons) { person in
        //                person.firstName.prefix(1) == letter
        //            }) { person in
        //                HStack {
        //                    Image(systemName: "person.circle.fill").font(.largeTitle).padding(.trailing, 5)
        //                    Text(person.firstName)
        //                    Text(person.lastName)
        //                }
        //            }
        //        }
        //    }
        
        
        ForEach(alphabet, id: \.self) { letter in
            Section(header: Text(letter).id(letter)) {
                ForEach(persons.filter({ (person) -> Bool in
                    person.firstName.prefix(1) == letter
                })) { person in
                    HStack {
                        Image(systemName: "person.circle.fill").font(.largeTitle).padding(.trailing, 5)
                        Text(person.firstName)
                        Text(person.lastName)
                    }
                }
            }
        }
        
        
        
        //
        //
        //
        //
        //
        //
        //
        //      lhs.indexLetter < rhs.indexLetter
        //    }), id: \.indexLetter) { _ in
        //      Section(
        //        header: HeaderView(title: alphabet.sorted())
        //      ) {
        //        ForEach(persons) { name in
        //            RowView(text: name)
        //        }
        //      }
        //    }
        
    }
    
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        SectionIndexTitles(proxy: proxy, titles: alphabet.sorted())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
    }
    
    init() {
        persons.append(Person(firstName: "Anna", lastName: "Andersen"))
        persons.append(Person(firstName: "Bente", lastName: "Kristiansen"))
    }
    
}

struct SectionIndexTitles: View {
    let proxy: ScrollViewProxy
    let titles: [String]
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                SectionIndexTitle(text: sfSymbol(text: title))
                    .background(dragObserver(title: title))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
    }
    
    func dragObserver(title: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, title: title)
        }
    }
    
    func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .top)
            }
        }
        return Rectangle().fill(Color.clear)
    }
    
    func sfSymbol(text: String) -> String {
        //    let systemName: String
        //    switch deviceCategory {
        //    case "iPhone": systemName = "iphone"
        //    case "iPad": systemName = "ipad"
        //    case "iPod": systemName = "ipod"
        //    case "Apple TV": systemName = "appletv"
        //    case "Apple Watch": systemName = "applewatch"
        //    case "HomePod": systemName = "homepod"
        //    default: systemName = "xmark"
        //    }
        //    return Image(systemName: systemName)
        return text
    }
}

struct SectionIndexTitle: View {
    let text: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .foregroundColor(Color.gray.opacity(0.1))
            .frame(width: 30, height: 10)
            .overlay(
                Text(text)
                    .foregroundColor(.accentColor)
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TableViewIndexed()
        }
    }
}
