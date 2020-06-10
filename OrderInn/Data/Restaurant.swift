import Firebase
import Foundation
import UIKit

struct Restaurant {
    let id: String
    let name: String
    let logoImageUrl, bannerImageUrl: URL?
    var logoImage: UIImage? = nil
    var bannerImage: UIImage? = nil

    static func tryLoad(withId id: String, from source: Firebase.Firestore, callback: @escaping (Restaurant?) -> Void) {
        source.collection("restaurants").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                let restaurant = Restaurant.parse(document)
                callback(restaurant)
            } else {
                callback(nil)
            }
        }
    }

    private static func parse(_ document: Firebase.DocumentSnapshot) -> Restaurant {
        let data = document.data()!
        // TODO: should match data to a schema in case fields are missing
        return Restaurant.init(
            id: document.documentID,
            name: data["name"] as! String,
            logoImageUrl: URL.init(string: data["logo_image"] as! String),
            bannerImageUrl: URL.init(string: data["banner_image"] as! String))
    }
}
