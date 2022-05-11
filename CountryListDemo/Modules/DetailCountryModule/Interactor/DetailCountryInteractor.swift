import Alamofire

protocol DetailCountryInteractorInput {
    func fetchCountry(id: String)
}

protocol DetailCountryInteractorOutput: AnyObject {
    func getData(data: [CurtainDataModel])
    func setLoadingStatus(type: ErrorType)
}

final class DetailCountryInteractor {
    weak var output: DetailCountryInteractorOutput?
    
    private func fetchCountryRequest(id: String, completion: @escaping(Result<[CountryModel], AFError>) -> Void) {
        let route = CountriesNetworkRouter.fetchCountry(id: id)
        NetworkService.shared.performRequest(route: route, completion: completion)
    }
}

extension DetailCountryInteractor: DetailCountryInteractorInput {
    
    func fetchCountry(id: String) {
        fetchCountryRequest(id: id) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data.first else { return }
                self?.setDataToModel(data: data)
            case .failure(let error):
                print(error)
                self?.output?.setLoadingStatus(type: .wentWrongError)
            }
        }
    }
    
    private func setDataToModel(data: CountryModel) {
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
                children: setChildrenData(data: data, type: .currencies))
        ]
        
        output?.getData(data: model)
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
        }
    }
}
