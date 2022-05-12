import Alamofire

protocol RegionListInteractorInput {
    func fetchCountryList()
}

protocol RegionListInteractorOutput: AnyObject {
    func getDataCountryList(data: [CountryModel])
    func setLoadingStatus(type: ErrorType)
}

final class RegionListInteractor {
    weak var output: RegionListInteractorOutput?
    
    private func fetchCountryListRequest(completion: @escaping(Result<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.fetchCountryList
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
}

extension RegionListInteractor: RegionListInteractorInput {
    
    func fetchCountryList() {
        fetchCountryListRequest { [weak output] result in
            switch result {
            case .success(let data):
                output?.getDataCountryList(data: data)
            case .failure(let error):
                print(error)
                output?.setLoadingStatus(type: .wentWrongError)
            }
        }
    }
}
