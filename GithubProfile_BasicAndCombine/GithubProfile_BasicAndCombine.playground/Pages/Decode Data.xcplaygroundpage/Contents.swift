import Foundation

struct GithubProfile: Codable {
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case followers
        case following
    }
    // CodingKey를 통해 서버에서 주는 avatar_url 데이터를 avatarUrl로 받는것 (JSON에서는 snake_case, swift에서는 camelCase를 사용하기 때문에 맵핑 필요)
}

// JSON -> App Model

let configuration = URLSessionConfiguration.default     // URLSession의 Configuration 구성
let session = URLSession(configuration: configuration)  // URLSession Configuration으로 URLSession 생성
let url = URL(string: "https://api.github.com/users/kayahn0126")! // 주소로 URL 생성

let task = session.dataTask(with: url) { data, response, error in
    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
        print("--> response \(response)")
        return
    }
    
    guard let data = data else { return }
    // data -> GithubProfile
    
    do {
        let decoder = JSONDecoder()
        let profile = try decoder.decode(GithubProfile.self, from: data)
        print("profile: \(profile)")
    } catch let error as NSError {
        print("error: \(error)")
    }
}
task.resume()
