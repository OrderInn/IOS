
import Foundation
import UIKit
import OrderInnAPIKit

struct Restaurant {
    let id: String
    let name: String
    let logoImageUrl, bannerImageUrl: URL?
    var logoImage: UIImage? = nil
    var bannerImage: UIImage? = nil
    var apiKit: OrderInnAPIKit.Restaurant?

    init(id: String, name: String, logoImageUrl: URL, bannerImageUrl: URL) {
        self.id = id
        self.name = name
        self.logoImageUrl = logoImageUrl
        self.bannerImageUrl = bannerImageUrl
    }

    init(from source: OrderInnAPIKit.Restaurant) {
        self.id = String(source.id)
        self.name = source.name
        self.bannerImageUrl = source.images.banner.url
        self.logoImageUrl = source.images.logo.url
        self.apiKit = source
    }
}
