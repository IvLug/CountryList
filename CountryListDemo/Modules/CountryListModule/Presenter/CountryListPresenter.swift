import UIKit

final class CountryListPresenter {
    weak var view: CountryListViewInput?
    var interactor: CountryListInteractorInput?
    var router: CountryListRouterInput?
    
    var region: String?
    var type: CountryListType = .all
    
    var countryList: [CountryModel] = []
}

extension CountryListPresenter: CountryListViewOutput {
    
    func showCountryDetail(country: CountryModel) {
        router?.showCountryDetail(country: country)
    }
    
    func viewDidLoad() {
        switch type {
        case .all:
            interactor?.fetchCountryList()
        case .inRegion:
            guard let region = region else { return }
            interactor?.fetchCountries(in: region)
        }
    }
    
    func setLoadingStatus(type: ErrorType) {
        view?.setLoadingStatus(type: type)
    }
    
    func searchByText(search: String) {
        guard !search.isEmpty else {
            interactor?.fetchCountryList()
            return
        }
        interactor?.searchByText(search: search)
    }
    
    func reloadData() {
        interactor?.fetchCountryList()
    }
}

extension CountryListPresenter: CountryListInteractorOutput {
    
    func getDataCountryList(data: [CountryModel]) {
        let status: ErrorType = data.isEmpty ? .dataNotFound : .notError
        setLoadingStatus(type: status)
        countryList = data
        view?.setData(data: data)
        view?.stopRefresh()
        view?.reloadTableView()
    }
}
