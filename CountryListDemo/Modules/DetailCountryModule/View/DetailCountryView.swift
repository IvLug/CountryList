import UIKit

protocol DetailCountryViewInput: View {
    func setData(data: CountryModel)
    func reloadData()
    func setLoadingStatus(type: ErrorType)
}

protocol DetailCountryViewOutput: CurtainViewProtocol {
    func viewWillAppear()
    func showCountry(whith code: String)
    func backMain()
}

final class DetailCountryView: BaseViewController {
    var output: DetailCountryViewOutput?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var flagImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.4
        imageView.layer.shadowRadius = 2
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInset = UIEdgeInsets(
            top: view.frame.height - (view.frame.height - 250),
            left: 0,
            bottom: 0,
            right: 0)
        scroll.delegate = self
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = false
        return scroll
    }()
    
    private lazy var bottomView: CurtainView = {
        let view = CurtainView { [weak output] sender in
            output?.showCountry(whith: sender)
        }
        view.output = output
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var loadingStatusView = LoadingStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Country Details"
        output?.viewWillAppear()
        isHideTabBar(true)
        navigationController?.navigationBar.prefersLargeTitles = false
        setLoadingStatus(type: .isLoading)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func configure() {
        addSubviews()
        let toRootViewButton = UIBarButtonItem(title: "Main", style: .done, target: self, action: #selector(showMain))
        navigationItem.rightBarButtonItem = toRootViewButton
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(flagImage)
        view.addSubview(scrollView)
        scrollView.addSubview(bottomView)
        view.addSubview(loadingStatusView)
    }
    
    private func makeConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        flagImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().inset(32)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        bottomView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
            make.top.centerX.bottom.equalToSuperview()
        }
    
        loadingStatusView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
    }
    
    @objc func showMain() {
        output?.backMain()
    }
}

extension DetailCountryView: DetailCountryViewInput {
    
    func setLoadingStatus(type: ErrorType) {
        loadingStatusView.setLoadingStatus(type: type, view: scrollView)
    }
    
    func setData(data: CountryModel) {
        flagImage.kf.loadImage(urlStr: data.flags?.png ?? "")
        bottomView.setData(data: data)
        titleLabel.text = data.name?.official
    }
    
    func reloadData() {
        bottomView.reloadData()
    }
}

extension DetailCountryView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        
        if offSetY > -250 && offSetY < 0 {
            let num = (abs(offSetY) / 20) / 10
            flagImage.alpha = num
            titleLabel.alpha = num
            UIView.animate(withDuration: 0) {
                self.flagImage.transform = CGAffineTransform(scaleX: num, y: num)
            }
        }
        
        if offSetY == -250 {
            UIView.animate(withDuration: 0.3) {
                self.flagImage.alpha = 1
                self.flagImage.transform = .identity
                self.titleLabel.alpha = 1
            }
        }
    }
}

