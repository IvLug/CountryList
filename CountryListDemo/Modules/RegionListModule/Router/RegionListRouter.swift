protocol RegionListRouterInput {
    func showCountries(in region: String)
}

final class RegionListRouter {
    weak var view: RegionListViewInput?
}

extension RegionListRouter: RegionListRouterInput {
    
    func showCountries(in region: String) {
        let module = view?.showModule(CountryListAssembly.self)
        module?.setRegion(region, type: .inRegion)
    }
}


