class MuseumArtifact: Decodable {
    var objectID: Int = 0
    var accessionNumber: String = ""
    var title: String = ""
    var artistDisplayName: String = ""
    var medium: String = ""
    var dimensions: String = ""
    var creditLine: String = ""
    var classification: String = ""
    var objectURL: String = ""
    var primaryImage: String = ""
    var primaryImageSmall: String = ""  // Adding smaller image for preview
    var tags: [Tag] = []  // Array of tags related to the artifact

    enum CodingKeys: String, CodingKey {
        case objectID
        case accessionNumber
        case title
        case artistDisplayName
        case medium
        case dimensions
        case creditLine
        case classification
        case objectURL
        case primaryImage
        case primaryImageSmall
        case tags
    }
    
    // Handle decoding from JSON
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        objectID = try container.decode(Int.self, forKey: .objectID)
        accessionNumber = try container.decode(String.self, forKey: .accessionNumber)
        title = try container.decode(String.self, forKey: .title)
        artistDisplayName = try container.decode(String.self, forKey: .artistDisplayName)
        medium = try container.decode(String.self, forKey: .medium)
        dimensions = try container.decode(String.self, forKey: .dimensions)
        creditLine = try container.decode(String.self, forKey: .creditLine)
        classification = try container.decode(String.self, forKey: .classification)
        objectURL = try container.decode(String.self, forKey: .objectURL)
        primaryImage = try container.decode(String.self, forKey: .primaryImage)
        primaryImageSmall = try container.decode(String.self, forKey: .primaryImageSmall)
        
        // Handling an optional array of tags
        if let tagsArray = try? container.decode([Tag].self, forKey: .tags) {
            tags = tagsArray
        }
    }
}

class Tag: Decodable {
    var term: String = ""
    var AAT_URL: String = ""
    var Wikidata_URL: String = ""

    enum CodingKeys: String, CodingKey {
        case term
        case AAT_URL
        case Wikidata_URL
    }
}

