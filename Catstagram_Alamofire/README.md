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
- ![](https://i.imgur.com/GutLx71.png)
- 왜? 배열일까?
- [the cat api](https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t) <- 이곳에서 Example Response를 보면 아래와 같은 모양이다.
- ![](https://i.imgur.com/OuY2J1C.png)
- **즉, 배열로 넘겨주니 배열로 받아야 한다.**
- 배열로 받고 배열 내 하나하나의 데이터는indexPath.row(tableView) or indexPath.item(collectionView)로 접근.

## 🍎 memory leak 확인
- 먼저 Catstagram 프로젝트에서 memory leak이 발생할 수 있는 경우는 **데이터를 받아 위임한 VC의 메서드에 전달하는 코드** 하나 뿐이다.
- ![](https://i.imgur.com/3851bmb.png)
- 일단 profile - leak으로 앱이 실행되는 동안 메모리 릭이 발생하는지 확인해보자.
- ![](https://i.imgur.com/ggVHq7h.png)
    - 앱 실행 후 테스트 이후에도 발생하지 않음
- **클로져 내 self는 강한참조를 하는데 왜 메모리 누수가 생기지 않을까?**
- 윗첨자는 reference count. **카운트 되는 방식은 지금까지 배운 내용으로 셈**
- ![](https://i.imgur.com/p6dKxTK.png)
    - 강한 참조를 할테니 분명 HomeViewController는 기존 + 1 이 될텐데 어떻게 메모리 누수가 없을까 생각해보았더니 viewDidLoad의 해제 시점에 아래의 인스턴스가 해제되면서 카운트를 차례로 줄여나가 결국 필요 이상으로 강한참조 하던 HomeViewController의 카운트를 하나 줄여 메모리릭이 발생하지 않는다고 결론을 내렸다.
    - ![](https://i.imgur.com/qqb9Ked.png)


## 🍎 Citation
- [the cat api](https://developers.thecatapi.com/view-account/ylX4blBYT9FaoVd6OhvR?report=bOoHBz-8t) 쿼리 파라미터 정리
