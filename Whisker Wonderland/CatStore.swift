import Foundation
import SwiftUI

class CatStore: ObservableObject {
    @Published var cats: [Cat] = []
    
    init() {
        // Starting with empty list - removed loadSampleData()
    }
    
    func addCat(_ cat: Cat) {
        cats.append(cat)
    }
    
    func deleteCat(at indexSet: IndexSet) {
        cats.remove(atOffsets: indexSet)
    }
} 
