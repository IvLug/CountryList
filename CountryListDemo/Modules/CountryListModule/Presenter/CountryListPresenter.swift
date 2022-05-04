final class CountryListPresenter {
    weak var view: CountryListViewInput?
    var interactor: CountryListInteractorInput?
    var router: CountryListRouterInput?
}

extension CountryListPresenter: CountryListViewOutput {
    
}

extension CountryListPresenter: CountryListInteractorOutput {
    
}
