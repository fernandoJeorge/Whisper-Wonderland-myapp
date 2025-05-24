import SwiftUI
import PhotosUI

struct AddCatView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var catStore: CatStore
    
    @State private var name = ""
    @State private var age = ""
    @State private var description = ""
    @State private var breed = ""
    @State private var gender = "Female"
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    let genders = ["Female", "Male"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photo")) {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            ContentUnavailableView("No photo selected",
                                systemImage: "photo.badge.plus",
                                description: Text("Tap to select a photo"))
                        }
                    }
                }
                
                Section(header: Text("Details")) {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Breed", text: $breed)
                    Picker("Gender", selection: $gender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add New Cat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCat()
                    }
                    .disabled(name.isEmpty || age.isEmpty)
                }
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
    
    private func saveCat() {
        guard let ageInt = Int(age) else { return }
        
        // Generate a unique filename for the image
        let imageFileName = UUID().uuidString + ".jpg"
        
        // Save the image to the documents directory if available
        if let imageData = selectedImageData,
           let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(imageFileName)
            try? imageData.write(to: imageUrl)
            
            let newCat = Cat(
                name: name,
                age: ageInt,
                description: description,
                imageURL: imageFileName, // Store the image filename instead of placeholder
                breed: breed,
                gender: gender,
                dateAdded: Date()
            )
            
            catStore.addCat(newCat)
            dismiss()
        } else {
            // Fallback if no image is selected
            let newCat = Cat(
                name: name,
                age: ageInt,
                description: description,
                imageURL: "cat_placeholder",
                breed: breed,
                gender: gender,
                dateAdded: Date()
            )
            
            catStore.addCat(newCat)
            dismiss()
        }
    }
}

#Preview {
    AddCatView()
        .environmentObject(CatStore())
} 
