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

struct TableViewIndexed: View {
    var persons = [Person]()
    var alphabet = [String]()
   
        
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
                        Text(person.firstName)
                        Text(person.lastName)
                    }
                    /// Dette medfører at navigationBarTitle viser korrekt ved oppstart. Er dette en feil?
                    .foregroundColor(.primary)
                }
            }
            foregroundColor(.primary)
        }
    }
    
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        SectionIndexTitles(proxy: proxy, titles: alphabet.sorted())
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
    }
    
    init() {
        /// persons må også være sortert
        persons.append(Person(firstName: "Anna", lastName: "Andersen"))
        persons.append(Person(firstName: "Alfred", lastName: "Knutsen"))
        persons.append(Person(firstName: "Bente", lastName: "Kristiansen"))
        persons.append(Person(firstName: "Dolly", lastName: "Olsen"))

        /// Må oppdatere alphabet
        
        alphabet.append("A")
        alphabet.append("B")
        alphabet.append("D")
        /// sort() virker ikke, så alphabet må sorteres på annen måte
        alphabet.sort()
    }
    
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
