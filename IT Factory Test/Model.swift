
import Foundation

// MARK: - Section
struct Section: Codable, Hashable {
    static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    let id, header: String
    let itemsTotal, itemsToShow: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable, Hashable {
    let id: String
    let image: Image
    let title: String
}

// MARK: - Image
struct Image: Codable, Hashable {
    let the1X, the2X, the3X: String
    let aspectRatio: Int?
    let loopAnimation: Bool?

    enum CodingKeys: String, CodingKey {
        case the1X = "1x"
        case the2X = "2x"
        case the3X = "3x"
        case aspectRatio, loopAnimation
    }
}
