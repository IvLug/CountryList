import Alamofire
import Foundation
protocol CountryListInteractorInput {
   func fetchCountryList()
   func searchByText(search: String)
}

protocol CountryListInteractorOutput: AnyObject {
    func getDataCountryList(data: [CountryModel])
    func setLoadingStatus(type: ErrorType)
}

final class CountryListInteractor {
    weak var output: CountryListInteractorOutput?
                
    private func fetchCountryListRequest(completion: @escaping(Result<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.fetchCountryList
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
    
    private func searchCountryRequest(search: String, completion: @escaping(Result<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.searchCountry(name: search)
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
}

extension CountryListInteractor: CountryListInteractorInput {
    
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
    
    func searchByText(search: String) {
        searchCountryRequest(search: search) { [weak output] result in
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
