import UIKit

final class CountryListPresenter {
    weak var view: CountryListViewInput?
    var interactor: CountryListInteractorInput?
    var router: CountryListRouterInput?
    
    var countryList: [CountryModel] = []
}

extension CountryListPresenter: CountryListViewOutput {
    
    func showCountryDetail(country: CountryModel) {
        router?.showCountryDetail(country: country)
    }
    
    func setDataToCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: CountryTableViewCell = tableView.dequeueCell(at: indexPath)
        cell.setData(data: countryList[indexPath.row])
        return cell
    }
    
    func viewDidLoad() {
        interactor?.fetchCountryList()
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
