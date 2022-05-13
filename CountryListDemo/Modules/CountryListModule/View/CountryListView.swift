import UIKit
import Combine

protocol CountryListViewInput: View {
    func reloadTableView()
    func setData(data: [CountryModel])
    func setLoadingStatus(type: ErrorType)
    func stopRefresh()
}

protocol CountryListViewOutput: AnyObject {
    func viewDidLoad()
    var countryList: [CountryModel] { get }
    var type: CountryListType { get }
    func showCountryDetail(country: CountryModel)
    func searchByText(search: String)
    func reloadData()
}

final class CountryListView: BaseViewController {
    var output: CountryListViewOutput?
    
    private var dataSourse = TableViewDataSourse<CountryModel>()
    
    private lazy var loadingStatusView = LoadingStatusView()
    private var cancellables = Set<AnyCancellable>()
    private var isRefreshing = false
    
    var isHideTabBar: Bool {
        output?.type == .all ? false : true
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setLeftImage(UIImage(named: "search")!, with: 10, tintColor: .clear)
        searchBar.layer.cornerRadius = 10
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        searchBar.searchTextField.tintColor = .gray
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        searchBar.searchTextField.delegate = self
        searchBar.setTextFieldColor(UIColor.systemGray6)
        searchBar.sizeToFit()
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = dataSourse
        view.register(cellWithClass: CountryTableViewCell.self)
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .gray
        refresh.attributedTitle = NSAttributedString(string: "Wait Please")
        refresh.addTarget(self, action: #selector(reload), for: .valueChanged)
        return refresh
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isHideTabBar(isHideTabBar)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func configure() {
        switch output?.type {
        case .all:
            tableView.refreshControl = refreshControl
            observeSearchBar()
            hideKeyboardWhenTappedAround()
        default: break
        }
        
        dataSourse.delegate = self
        output?.viewDidLoad()
        setLoadingStatus(type: .isLoading)
        addSubviews()
        navigationItem.title = "Country List"
    }
    
    private func addSubviews() {
        switch output?.type {
        case .all:
            self.navigationController?.navigationBar.topItem?.titleView = searchBar
        default: break
        }
        view.addSubview(tableView)
        view.addSubview(loadingStatusView)
    }
    
    private func makeConstraints() {
        
        switch output?.type {
        case .all:
            searchBar.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
            }
            searchBar.searchTextField.snp.makeConstraints { make in
                make.left.centerY.right.equalToSuperview()
                make.height.equalTo(36)
            }
            tableView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.leading.bottom.trailing.equalToSuperview()
            }
        case .inRegion:
            tableView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
                make.leading.bottom.trailing.equalToSuperview()
            }
        default: break
        }
        loadingStatusView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }
    }
    
    private func observeSearchBar() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
        publisher
            .map { ($0.object as! UISearchTextField).text }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] (value) in
                guard self?.isRefreshing == false else { return }
                self?.output?.searchByText(search: value ?? "")
                self?.setLoadingStatus(type: .isLoading)
            })
            .store(in: &cancellables)
    }
    
    @objc func reload() {
        view.endEditing(true)
        isRefreshing = true
        searchBar.text = ""
        output?.reloadData()
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
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        dataSourse.setData(data: data)
    }
    
    func stopRefresh() {
        guard isRefreshing else { return }
        refreshControl.endRefreshing()
        isRefreshing = false
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

extension CountryListView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension CountryListView: TableViewDataSourseDelegate {
 
    func setDataToCell(indexPath: IndexPath) -> UITableViewCell {
        guard let data = output?.countryList[indexPath.row] else { return UITableViewCell() }
        let cell: CountryTableViewCell = tableView.dequeueCell(at: indexPath)
        cell.setData(data: data)
        return cell
    }
}
