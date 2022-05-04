protocol CountryListInteractorInput {
    
}

protocol CountryListInteractorOutput: AnyObject {
    
}

final class CountryListInteractor {
    weak var output: CountryListInteractorOutput?
}

extension CountryListInteractor: CountryListInteractorInput {
    
}
