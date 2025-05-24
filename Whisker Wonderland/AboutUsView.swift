import SwiftUI
import PhotosUI

struct AboutUsView: View {
    @AppStorage("backgroundImageData") private var backgroundImageData: Data?
    @AppStorage("businessName") private var businessName: String = ""
    @AppStorage("missionText") private var missionText: String = ""
    @AppStorage("contactText") private var contactText: String = ""
    @AppStorage("processText") private var processText: String = ""
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ZStack {
                        if let backgroundImageData,
                           let uiImage = UIImage(data: backgroundImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                        }
                        
                        VStack {
                            if isEditing {
                                TextField("Enter Business Name", text: $businessName)
                                    .font(.system(size: 40, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            } else {
                                Text(businessName.isEmpty ? "Enter Business Name" : businessName)
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(radius: 5)
                            }
                            
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                Text("Change Background")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        EditableInfoSection(
                            title: "Our Mission",
                            content: $missionText,
                            placeholder: "Enter your business mission here",
                            isEditing: isEditing
                        )
                        
                        EditableInfoSection(
                            title: "Contact Us",
                            content: $contactText,
                            placeholder: "Enter your contact information here",
                            isEditing: isEditing
                        )
                        
                        EditableInfoSection(
                            title: "Process",
                            content: $processText,
                            placeholder: "Enter your process steps here",
                            isEditing: isEditing
                        )
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") {
                        isEditing.toggle()
                    }
                }
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    backgroundImageData = data
                }
            }
        }
    }
}

struct EditableInfoSection: View {
    let title: String
    @Binding var content: String
    let placeholder: String
    let isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            if isEditing {
                TextEditor(text: $content)
                    .frame(minHeight: 100)
                    .font(.body)
                    .foregroundColor(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .overlay(
                        Group {
                            if content.isEmpty {
                                Text(placeholder)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                            }
                        }
                    )
            } else {
                Text(content.isEmpty ? placeholder : content)
                    .font(.body)
                    .foregroundColor(content.isEmpty ? .gray : .secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    AboutUsView()
} 