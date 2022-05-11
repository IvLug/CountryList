protocol CountryListRouterInput {
    func showCountryDetail(country: CountryModel)
}

final class CountryListRouter {
    weak var view: CountryListViewInput?
}

extension CountryListRouter: CountryListRouterInput {
    
    func showCountryDetail(country: CountryModel) {
      let module = view?.showModule(DetailCountryAssembly.self)
        module?.setCountry(data: country)
    }
}
