import UIKit

protocol DetailCountryViewInput: View {}

protocol DetailCountryViewOutput: AnyObject {}

final class DetailCountryView: BaseViewController {
    var output: DetailCountryViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        
    }
    
    private func makeConstraints() {
        
    }
}

extension DetailCountryView: DetailCountryViewInput {}

