import SwiftUI

struct CatListView: View {
    @EnvironmentObject var catStore: CatStore
    @State private var currentIndex: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("Swipe left or right to view more cats")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    
                    // Main content
                    if !catStore.cats.isEmpty {
                        TabView(selection: $currentIndex) {
                            ForEach(Array(catStore.cats.enumerated()), id: \.element.id) { index, cat in
                                NavigationLink(destination: CatDetailView(cat: cat)) {
                                    CatCardView(cat: cat)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .padding(.vertical)
                    }
                    
                    // Empty state view
                    if catStore.cats.isEmpty {
                        ContentUnavailableView {
                            Label("Enlist Your Cats Here", systemImage: "pawprint.fill")
                        } description: {
                            Text("Tap the + button to add your first cat")
                                .foregroundColor(.gray)
                        } actions: {
                            NavigationLink(destination: AddCatView()) {
                                Text("Add Cat")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Whisker Wonderland")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddCatView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct CatCardView: View {
    let cat: Cat
    
    var body: some View {
        VStack(spacing: 0) {
            // Image Section
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let imageUrl = documentsDirectory.appendingPathComponent(cat.imageURL)
                if let imageData = try? Data(contentsOf: imageUrl),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                } else {
                    Image(systemName: "cat")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .foregroundColor(.gray)
                }
            }
            
            // Info Section
            VStack(alignment: .center, spacing: 8) {
                Text(cat.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(cat.age) year\(cat.age == 1 ? "" : "s") old")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 20)
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}

#Preview {
    CatListView()
        .environmentObject(CatStore())
} 
