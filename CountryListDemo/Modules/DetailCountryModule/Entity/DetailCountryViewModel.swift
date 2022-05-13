final class DetailCountryViewModel {

}

struct CurtainDataModel {
    var model: CountryModel?
    var title: String?
    var parrent: Bool?
    var isExpanded: Bool? = false
    var type: DatailsTableType?
    var children: [String]?
}


enum DatailsTableType {
    
    case timezones
    case subregion
    case languages
    case translations
    case currencies
    case population
    case borders
}
