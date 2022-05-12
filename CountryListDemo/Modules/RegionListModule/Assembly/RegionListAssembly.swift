import UIKit

final class RegionListAssembly: ModuleAssembly {
    
    var view: UIViewController
    
    lazy var presenter = RegionListPresenter()
    lazy var interactor = RegionListInteractor()
    lazy var router = RegionListRouter()
    
    private init() {
        view = UIViewController()
    }
    
    static func assembly(navigation: Bool = true) -> Self {
        let assembly = self.init()
        
        let view = RegionListView()
        
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

