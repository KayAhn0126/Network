# Network

## 🍎 큰 틀에서 보는 네트워크 순서
1. URLSessionConfiguration 객체 생성
2. 1번에서 생성한 configuration을 URLSession 생성자의 매개변수로 넣어 URLSession 객체 생성
3. 데이터를 받아올 주소를 문자열로 매개변수로 넣어 URL 객체 생성
4. 2번에서 생성한 URLSession 객체의 dataTask(with: 3번의 URL 객체)메서드를 사용해 URLSessionDataTask 객체 생성
    - 4-1. URLSessionDataTask 객체가 생성이 되었을때 상태는 suspended 상태이다.
    - 4-2. resume()메서드 호출로 서버로부터 응답 데이터 받기 프로세스 시작 -> Data 객체를 dataTask 클로져에 전달
    - 4-3. response를 제대로 받았는지, data가 제대로 들어왔는지, error가 발생했는지 확인 후 알맞은 프로세스 진행

```swift
import Foundation

// configuration -> urlsession -> urlsessionTask
let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)
let url = URL(string: "https://api.github.com/users/kayahn0126")!

let task = session.dataTask(with: url) { data, response, error in
    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
        print("--> response \(response)")
        return
    }
    
    guard let data = data else { return }
    
    let result = String(data: data, encoding: .utf8)
    print(result)
}
task.resume()
```
