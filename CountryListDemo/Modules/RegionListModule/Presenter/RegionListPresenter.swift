import UIKit
final class RegionListPresenter {
    weak var view: RegionListViewInput?
    var interactor: RegionListInteractorInput?
    var router: RegionListRouterInput?
    
    var regionList: [String] = []
}

extension RegionListPresenter: RegionListViewOutput {
    
    func viewDidLoad() {
        interactor?.fetchCountryList()
    }
    
    func showCountries(in region: String) {
        router?.showCountries(in: region)
    }
}

extension RegionListPresenter: RegionListInteractorOutput {
    
    func getDataCountryList(data: [CountryModel]) {
        let values = data.compactMap { $0.continents }
            .compactMap { $0.first }
        let regions = Array(Set(values)).sorted(by: { $0 < $1 })
        
        let status: ErrorType = regions.isEmpty ? .dataNotFound : .notError
        setLoadingStatus(type: status)
        regionList = regions
        view?.setData(data: regions)
        view?.reloadTableView()
    }
    
    func setLoadingStatus(type: ErrorType) {
        view?.setLoadingStatus(type: type)
    }
}
