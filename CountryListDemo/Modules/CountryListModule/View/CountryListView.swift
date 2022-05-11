import UIKit

protocol CountryListViewInput: View {
    func reloadTableView()
    func setData(data: [CountryModel])
    func setLoadingStatus(type: ErrorType)
}

protocol CountryListViewOutput: TableViewDataSourseDelegate {
    func viewDidLoad()
    var countryList: [CountryModel] { get }
    func showCountryDetail(country: CountryModel)
}

final class CountryListView: BaseViewController {
    var output: CountryListViewOutput?
    
    var dataSourse = TableViewDataSourse<CountryModel>()
    
    private lazy var loadingStatusView = LoadingStatusView()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = dataSourse
        view.register(cellWithClass: CountryTableViewCell.self)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourse.delegate = output
        output?.viewDidLoad()
        setLoadingStatus(type: .isLoading)
        addSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(loadingStatusView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingStatusView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }
}

extension CountryListView: CountryListViewInput {
    
    func setLoadingStatus(type: ErrorType) {
        loadingStatusView.setLoadingStatus(type: type, view: tableView)
    }
    
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setData(data: [CountryModel]) {
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        dataSourse.setData(data: data)
    }
}

extension CountryListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = output?.countryList[indexPath.row] else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak output] in
            output?.showCountryDetail(country: data)
        }
    }
}
