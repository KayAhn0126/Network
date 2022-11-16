# Alamofire를 통한 네트워킹

## 🍎 네트워크를 하기위해 필요한 3가지.
- 서버에 요구할 파라미터
    - Encodable 프로토콜을 따르는 구조체로 구현
    ```swift
    // MARK: - 요청을 보낼때 같이 보낼 파라미터 형식
    struct FeedAPIInput: Encodable {
        var limit: Int
        var page: Int
    }
    ```
- 서버에서 받은 데이터를 인스턴스화 시킬 구조체
    ```swift
    // MARK: - 서버로 부터 response를 어떤 형태로 받을것인지.
    struct FeedModel: Decodable {
        var id: String?
        var url: String?
    }
    ```
- 서버에게 request를 할 DataManager
    ```swift
    class FeedDataManager {
        var dataDelegate: DataTransferDelegate?
    
        init(_ dataDelegate: DataTransferDelegate? = nil) {
            self.dataDelegate = dataDelegate
        }
        
        deinit {
            print("deinit")
        }
    
        func feedDataManager(_ parameters: FeedAPIInput) {
            AF.request("https://api.thecatapi.com/v1/images/search", method: .get, parameters: parameters).validate().responseDecodable(of: [FeedModel].self) { response in
                switch response.result {
                case .success(let data):
                    self.dataDelegate!.sendData(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    ```
    - FeedDataManager 클래스가 struct이 아닌 class인 이유
        - FeedDataManager로 생성된 인스턴스가 메모리에서 해제되는 시점이 알고싶어 소멸자를 추가했다. -> class에서만 가능.

## 🍎 Alamofire와 밀접한 관련은 없지만..
- 서버로 부터 데이터를 받는 형태가 배열이다!
- 왜?
- [the cat api](https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t) <- 이곳에서 Example Response를 보면 아래와 같은 모양이다.

## 🍎 메모리 누수 확인



## 🍎 Citation
- [the cat api](https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t) 쿼리 파라미터 정리
