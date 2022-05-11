import Foundation

final class DetailCountryPresenter {
    weak var view: DetailCountryViewInput?
    var interactor: DetailCountryInteractorInput?
    var router: DetailCountryRouterInput?
    
    var country: CountryModel?
    
    var model: [CurtainDataModel] = []
}

extension DetailCountryPresenter: DetailCountryViewOutput {
    
    func viewWillAppear() {
        guard let id = country?.cca3 else { return }
        interactor?.fetchCountry(id: id)
    }
}

extension DetailCountryPresenter: DetailCountryInteractorOutput {
    
    func getData(data: [CurtainDataModel]) {
        self.model = data
        guard let country = data.first?.model else {return }
        let status: ErrorType = data.isEmpty ? .dataNotFound : .notError
        setLoadingStatus(type: status)
        view?.setData(data: country)
        view?.reloadData()
    }
    
    func setLoadingStatus(type: ErrorType) {
        view?.setLoadingStatus(type: type)
    }
}

extension DetailCountryPresenter {
    
    func toggleExpansionOfType(with index: Int) {
        model[index].isExpanded?.toggle()
    }
}
