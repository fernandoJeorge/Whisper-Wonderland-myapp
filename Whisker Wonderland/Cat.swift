import Foundation

struct Cat: Identifiable, Codable {
    var id = UUID()
    var name: String
    var age: Int
    var description: String
    var imageURL: String
    var breed: String
    var gender: String
    var dateAdded: Date
    
    static let sampleCat = Cat(
        name: "Whiskers",
        age: 2,
        description: "A friendly and playful cat who loves cuddles",
        imageURL: "cat_placeholder",
        breed: "Mixed",
        gender: "Female",
        dateAdded: Date()
    )
}

