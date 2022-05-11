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
}

extension CountryListPresenter: CountryListInteractorOutput {
    
    func getDataCountryList(data: [CountryModel]) {
        let status: ErrorType = data.isEmpty ? .dataNotFound : .notError
        setLoadingStatus(type: status)
        countryList = data
        view?.setData(data: data)
        view?.reloadTableView()
    }
}
