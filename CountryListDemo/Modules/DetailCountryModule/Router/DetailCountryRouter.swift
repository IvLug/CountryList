protocol DetailCountryRouterInput {
    func showCountry(whith code: String)
    func backMain()
}

final class DetailCountryRouter {
    weak var view: DetailCountryViewInput?
}

extension DetailCountryRouter: DetailCountryRouterInput {
    
    func showCountry(whith code: String) {
        let module = view?.showModule(DetailCountryAssembly.self)
        module?.setCountry(code: code)
    }
    
    func backMain() {
        view?.navigationController?.popToRootViewController(animated: true)
    }
}


