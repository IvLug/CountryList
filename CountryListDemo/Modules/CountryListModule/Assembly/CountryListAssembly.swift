import UIKit

final class CountryListAssembly: ModuleAssembly {
    
    var view: UIViewController
    
    lazy var presenter = CountryListPresenter()
    lazy var interactor = CountryListInteractor()
    lazy var router = CountryListRouter()
    
    private init() {
        view = UIViewController()
    }
    
    static func assembly(navigation: Bool = true) -> Self {
        let assembly = self.init()
        
        let view = CountryListView()
        
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
}

