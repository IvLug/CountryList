import Alamofire

protocol DetailCountryInteractorInput {
    func fetchCountry(id: String)
}

protocol DetailCountryInteractorOutput: AnyObject {
    func setDataToModel(data: CountryModel)
    func setLoadingStatus(type: ErrorType)
}

final class DetailCountryInteractor {
    weak var output: DetailCountryInteractorOutput?
    
    private func fetchCountryRequest(id: String, completion: @escaping(Result<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.fetchCountry(id: id)
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
}

extension DetailCountryInteractor: DetailCountryInteractorInput {
    
    func fetchCountry(id: String) {
        fetchCountryRequest(id: id) { [weak output] result in
            switch result {
            case .success(let data):
                guard let data = data.first else { return }
                output?.setDataToModel(data: data)
            case .failure(let error):
                print(error)
                output?.setLoadingStatus(type: .wentWrongError)
            }
        }
    }
}
