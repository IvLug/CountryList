import UIKit

protocol RegionListViewInput: View {
    func reloadTableView()
    func setLoadingStatus(type: ErrorType)
    func setData(data: [String])
}

protocol RegionListViewOutput: AnyObject {
    func viewDidLoad()
    var regionList: [String] { get }
    func showCountries(in region: String)
}

final class RegionListView: BaseViewController {
    var output: RegionListViewOutput?
    
    private lazy var loadingStatusView = LoadingStatusView()
    private var dataSourse = TableViewDataSourse<String>()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = dataSourse
        view.register(cellWithClass: RegionTableVIewCell.self)
        return view
    }()
        
    let storage = StorageManager<ProductData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isHideTabBar(false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func configure() {
        dataSourse.delegate = self
        output?.viewDidLoad()
        setLoadingStatus(type: .isLoading)
        addSubviews()
        navigationItem.title = "Region List"
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(loadingStatusView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
        loadingStatusView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }
}

extension RegionListView: RegionListViewInput {
    
    func setLoadingStatus(type: ErrorType) {
        loadingStatusView.setLoadingStatus(type: type, view: tableView)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func setData(data: [String]) {
        dataSourse.setData(data: data)
    }
}

extension RegionListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let region = output?.regionList[indexPath.row] else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak output] in
            output?.showCountries(in: region)
        }
    }
}

extension RegionListView: TableViewDataSourseDelegate {
    
    func setDataToCell(indexPath: IndexPath) -> UITableViewCell {
        guard let data = output?.regionList[indexPath.row] else { return UITableViewCell() }
        let cell: RegionTableVIewCell = tableView.dequeueCell(at: indexPath)
        cell.setData(data: data)
        return cell
    }
}
