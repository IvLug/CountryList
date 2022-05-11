import UIKit
import Combine

protocol CountryListViewInput: View {
    func reloadTableView()
    func setData(data: [CountryModel])
    func setLoadingStatus(type: ErrorType)
    func stopRefresh()
}

protocol CountryListViewOutput: TableViewDataSourseDelegate {
    func viewDidLoad()
    var countryList: [CountryModel] { get }
    func showCountryDetail(country: CountryModel)
    func searchByText(search: String)
    func reloadData()
}

final class CountryListView: BaseViewController {
    var output: CountryListViewOutput?
    
    var dataSourse = TableViewDataSourse<CountryModel>()
    
    private lazy var loadingStatusView = LoadingStatusView()
    private var cancellables = Set<AnyCancellable>()
    private var isRefreshing = false
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.setLeftImage(UIImage(named: "search")!, with: 10, tintColor: .clear)
        searchBar.layer.cornerRadius = 10
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
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
        view.refreshControl = refreshControl
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func configure() {
        dataSourse.delegate = output
        output?.viewDidLoad()
        setLoadingStatus(type: .isLoading)
        addSubviews()
        observeSearchBar()
        hideKeyboardWhenTappedAround()
        navigationItem.title = "Country List"
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingStatusView)
    }
    
    private func makeConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(56)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(-14)
            make.leading.bottom.trailing.equalToSuperview()
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
        tableView.estimatedRowHeight = 85
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
