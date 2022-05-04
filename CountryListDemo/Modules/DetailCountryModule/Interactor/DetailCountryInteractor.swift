protocol DetailCountryInteractorInput {
    
}

protocol DetailCountryInteractorOutput: AnyObject {
    
}

final class DetailCountryInteractor {
    weak var output: DetailCountryInteractorOutput?
}

extension DetailCountryInteractor: DetailCountryInteractorInput {
    
}
