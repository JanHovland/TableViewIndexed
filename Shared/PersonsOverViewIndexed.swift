// Original article here: https://www.fivestars.blog/code/section-title-index-swiftui.html
import SwiftUI

struct HeaderView: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RowView: View {
    var text: String
    var body: some View {
        Text(text)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PersonsOverViewIndexed: View {
    var persons: [Person] = [Person(firstName: "Anna", lastName: "Andersen"),
                             Person(firstName: "Alfred", lastName: "Gunnerud"),
                             Person(firstName: "Bente", lastName: "Kristiansen"),
                             Person(firstName: "Dolly", lastName: "Olsen"),
                             Person(firstName: "Fred", lastName: "Knutsen")
    ]
    
    var alphabet = ["A","B","D","F"]
        
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack (alignment: .leading) {
                        devicesList
                    }
                    .navigationBarTitle("Persons Overview")
                }
                .overlay(sectionIndexTitles(proxy: proxy))
            }
        }
    }
    
    var devicesList: some View {
        ForEach(alphabet, id: \.self) { letter in
            Section(header: Text(letter).id(letter)) {
                /// Her er kopligen mellom letter pg person
                ForEach(persons.filter({ (person) -> Bool in
                    person.firstName.prefix(1) == letter
                })) { person in
                    HStack {
                        Image(systemName: "person.circle.fill").font(.largeTitle).padding(.trailing, 5)
                            .foregroundColor(.green)
                        Text(person.firstName)
                            .font(Font.system(.body).bold())
                        Text(person.lastName)
                    }
                    .foregroundColor(.primary)
                }
            }
            .foregroundColor(.primary)
            .font(Font.system(.body).bold())
            .padding(.top,2)
            .padding(.leading,5)
            .padding(.bottom,2)
        }
    }
    
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        SectionIndexTitles(proxy: proxy, titles: alphabet.sorted())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
    }
    
//    init() {
//        /// persons må også være sortert
//        persons.append(Person(firstName: "Anna", lastName: "Andersen"))
//        persons.append(Person(firstName: "Alfred", lastName: "Gunnerud"))
//        persons.append(Person(firstName: "Bente", lastName: "Kristiansen"))
//        persons.append(Person(firstName: "Dolly", lastName: "Olsen"))
//        persons.append(Person(firstName: "Fred", lastName: "Knutsen"))
//
//        /// Må oppdatere alphabet
//
//        alphabet.append("A")
//        alphabet.append("B")
//        alphabet.append("D")
//        alphabet.append("F")
//        /// sort() virker ikke, så alphabet må sorteres på annen måte
//        /// alphabet.sort()
//    }
    
}

struct SectionIndexTitles: View {
    let proxy: ScrollViewProxy
    let titles: [String]
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        VStack {
            ForEach(titles, id: \.self) { title in
                SectionIndexTitle(text: title)
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
    
}

struct SectionIndexTitle: View {
    var text: String
    var body: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .foregroundColor(Color.gray.opacity(0.01))
            .frame(width: 30, height: 10)
            .overlay(
                Text(text)
                    .foregroundColor(.accentColor)
            )
    }
}

