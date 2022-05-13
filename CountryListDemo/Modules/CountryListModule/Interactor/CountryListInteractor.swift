import Alamofire
import Foundation

protocol CountryListInteractorInput {
    func fetchCountryList()
    func searchByText(search: String)
    func fetchCountries(in region: String)
}

protocol CountryListInteractorOutput: AnyObject {
    func getDataCountryList(data: [CountryModel])
    func setLoadingStatus(type: ErrorType)
}

final class CountryListInteractor {
    weak var output: CountryListInteractorOutput?
    
    private func fetchCountryListRequest(completion: @escaping(_ error: Error?, DataResponse<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.fetchCountryList
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
    
    private func searchCountryRequest(search: String, completion: @escaping(_ error: Error?, DataResponse<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.searchCountry(name: search)
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
    
    private func fetchCountriesRequest(in region: String, completion: @escaping(_ error: Error?, DataResponse<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.fetchCountriesInRegion(region)
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
}

extension CountryListInteractor: CountryListInteractorInput {
    
    func fetchCountries(in region: String) {
        fetchCountriesRequest(in: region) { [weak output] error, response in
            switch response.result {
            case .success(let data):
                output?.getDataCountryList(data: data)
            case .failure(let errorAF):
                print(errorAF)
                guard let mappedError = error as? ErrorModel else {
                    print(errorAF.localizedDescription)
                    output?.setLoadingStatus(type: .wentWrongError)
                    return
                }
                if mappedError.status == 404 {
                    output?.setLoadingStatus(type: .dataNotFound)
                }
            }
        }
    }
    
    func fetchCountryList() {
        fetchCountryListRequest { [weak output] error, response in
            switch response.result {
            case .success(let data):
                output?.getDataCountryList(data: data)
            case .failure(let error):
                print(error)
                output?.setLoadingStatus(type: .wentWrongError)
            }
        }
    }
    
    func searchByText(search: String) {
        searchCountryRequest(search: search) { [weak output] error, response in
            switch response.result {
            case .success(let data):
                output?.getDataCountryList(data: data)
            case .failure(let error):
                print(error)
                output?.setLoadingStatus(type: .wentWrongError)
            }
        }
    }
}
