import Foundation

struct QRURI {
    let restaurant, table, seat: String

    static func parse(from input: String) -> QRURI? {
        guard let url = URL.init(string: input) else { return nil }
        guard url.scheme == "orderinn" && url.host == "qr1" else { return nil }
        let pathParts = url.path.split(separator: "/")
        guard pathParts.count == 3 else { return nil }
        return QRURI.init(
            restaurant: String.init(pathParts[0]),
            table: String.init(pathParts[1]),
            seat: String.init(pathParts[2]))
    }
}
