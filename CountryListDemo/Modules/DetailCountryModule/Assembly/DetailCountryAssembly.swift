import UIKit

final class DetailCountryAssembly: ModuleAssembly {
    
    var view: UIViewController
    
    lazy var presenter = DetailCountryPresenter()
    lazy var interactor = DetailCountryInteractor()
    lazy var router = DetailCountryRouter()
    
    private init() {
        view = UIViewController()
    }
    
    static func assembly(navigation: Bool = true) -> Self {
        let assembly = self.init()
        
        let view = DetailCountryView()
        
        assembly.view = view
        
        view.output = assembly.presenter
        
        assembly.interactor.output = assembly.presenter
        
        assembly.presenter.view = view
        assembly.presenter.interactor = assembly.interactor
        assembly.presenter.router = assembly.router
        
        assembly.router.view = view

        guard navigation else { return assembly }
        
        let navigationController = UINavigationController(rootViewController: view)
        
        assembly.view = navigationController
        
        return assembly
    }
    
    func setCountry(data: CountryModel) {
        presenter.country = data
    }
}

