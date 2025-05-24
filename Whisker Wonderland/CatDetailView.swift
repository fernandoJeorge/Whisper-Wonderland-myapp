import SwiftUI

struct CatDetailView: View {
    let cat: Cat
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let imageUrl = documentsDirectory.appendingPathComponent(cat.imageURL)
                    if let imageData = try? Data(contentsOf: imageUrl),
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                    } else {
                        // Show placeholder image
                        Image("cat_placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                    }
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(title: "Name", value: cat.name)
                    DetailRow(title: "Age", value: "\(cat.age) year\(cat.age == 1 ? "" : "s")")
                    DetailRow(title: "Breed", value: cat.breed)
                    DetailRow(title: "Gender", value: cat.gender)
                    
                    Text("About")
                        .font(.headline)
                        .padding(.top)
                    Text(cat.description)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                
                Button(action: {
                    // TODO: Implement adoption inquiry
                }) {
                    Text("Inquire About Adoption")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(cat.name)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    NavigationView {
        CatDetailView(cat: Cat.sampleCat)
    }
} 