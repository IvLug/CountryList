import UIKit

protocol CountryListViewInput: View {}

protocol CountryListViewOutput: AnyObject {}

final class CountryListView: BaseViewController {
    var output: CountryListViewOutput?
    
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

extension CountryListView: CountryListViewInput {}

