import UIKit
import CryptoKit

extension String {
    var md5: String {
       Insecure.MD5.hash(data: self.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
}

func getData(urlRequest: String) {
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in

        guard let response = response as? HTTPURLResponse else {
            print("Проблемы с интернет соединением")
            return
        }

        print("Код ответа от сервера: \(response.statusCode)\n")

        switch response.statusCode {
        case 200...299:
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            print("\(dataAsString ?? "")\n")
        case 400:
            print("Запрос сформирован некорректно")
        case 401:
            print("Для получения запрашиваемого ответа нужна аутентификация")
        case 402:
            print("Необходима оплата")
        case 403:
            print("Нет прав доступа к содержимому")
        case 404:
            print("Сервер не может найти запрашиваемый ресурс")
        case 405:
            print("Метод был деактивирован и не может быть использован")
        case 408:
            print("Превышено время ожидания")
        case 409:
            print("Конфликт запроса с текущим состоянием сервера")
        case 500...599:
            print("Проблемы с сервером")
        default:
            if let error = error as NSError? {
                print("Возникла ошибка: \(error)")
            }
        }
    }.resume()
}

let urlRequest = "https://api.chucknorris.io/jokes/random"

getData(urlRequest: urlRequest)

let publicKey = "723d6f5dff37f9143059dbd05970bfcc"
let privateKey = "0f4102a4697711c82d2c2ff842952d3baa8aca51"
let timeStamp = DateFormatter().string(from: Date())
let hash = (timeStamp + privateKey + publicKey).md5

let marvelUrlRequest = "https://gateway.marvel.com:443/v1/public/characters/1010743?ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"

getData(urlRequest: marvelUrlRequest)
