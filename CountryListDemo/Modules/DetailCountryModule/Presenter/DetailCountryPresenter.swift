import Foundation

final class DetailCountryPresenter {
    weak var view: DetailCountryViewInput?
    var interactor: DetailCountryInteractorInput?
    var router: DetailCountryRouterInput?
    
    var cca3: String?
    var model: [CurtainDataModel] = []
}

extension DetailCountryPresenter: DetailCountryViewOutput {
    
    func showCountry(whith code: String) {
        router?.showCountry(whith: code)
    }
    
    func viewWillAppear() {
        guard let id = cca3 else { return }
        interactor?.fetchCountry(id: id)
    }
    
    func backMain() {
        router?.backMain()
    }
}

extension DetailCountryPresenter: DetailCountryInteractorOutput {
    
    func getData(data: [CurtainDataModel]) {
        self.model = data
        guard let country = data.first?.model else {return }
        let status: ErrorType = data.isEmpty ? .dataNotFound : .notError
        setLoadingStatus(type: status)
        view?.setData(data: country)
    }
    
    func setLoadingStatus(type: ErrorType) {
        view?.setLoadingStatus(type: type)
    }
    
    func setDataToModel(data: CountryModel) {
        let model = [
            CurtainDataModel(
                model: data,
                title: continentsCount(count: data.languages?.count ?? 0),
                type: .languages,
                children: setChildrenData(data: data, type: .languages)),
            CurtainDataModel(
                model: data,
                title: "Translations:",
                type: .translations,
                children: setChildrenData(data: data, type: .translations)),
            CurtainDataModel(
                model: data,
                title: "Regoin:",
                type: .subregion,
                children: setChildrenData(data: data, type: .subregion)),
            CurtainDataModel(
                model: data,
                title: "Time zones:",
                type: .timezones,
                children: setChildrenData(data: data, type: .timezones)),
            CurtainDataModel(
                model: data,
                title: "Currencies:",
                type: .currencies,
                children: setChildrenData(data: data, type: .currencies)),
            CurtainDataModel(
                model: data,
                title: "Population:",
                type: .population,
                children: setChildrenData(data: data, type: .population)),
            CurtainDataModel(
                model: data,
                title: "Borders:",
                type: .borders,
                children: setChildrenData(data: data, type: .borders))
        ]
        getData(data: model)
    }
    
    private func setChildrenData(data: CountryModel, type: DatailsTableType) -> [String] {
        switch type {
        case .timezones:
            return data.timezones ?? []
        case .subregion:
            return [data.region ?? ""]
        case .languages:
            return data.languages?.values.compactMap({ $0 }) ?? []
        case .translations:
            let value = data.translations?.values.compactMap({ $0.official }) ?? []
            return value
        case .currencies:
            return data.currencies?.values.compactMap({ $0.name }) ?? []
        case .population:
            let population = (data.population ?? 0).description
            return [population]
        case .borders:
            return data.borders ?? []
        }
    }
}

extension DetailCountryPresenter {
    
    func toggleExpansionOfType(with index: Int) {
        model[index].isExpanded?.toggle()
    }
}
