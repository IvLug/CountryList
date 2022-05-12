import UIKit

protocol DetailCountryViewInput: View {
    func setData(data: CountryModel)
    func reloadData()
    func setLoadingStatus(type: ErrorType)
}

protocol DetailCountryViewOutput: CurtainViewProtocol {
    func viewWillAppear()
}

final class DetailCountryView: BaseViewController {
    var output: DetailCountryViewOutput?
    
    private lazy var flagImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInset = UIEdgeInsets(
            top: view.frame.height - (view.frame.height - 200),
            left: 0,
            bottom: 0,
            right: 0)
        scroll.delegate = self
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = false
        return scroll
    }()
    
    private lazy var bottomView: CurtainView = {
        let view = CurtainView()
        view.output = output
        return view
    }()
    
    private lazy var loadingStatusView = LoadingStatusView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setLoadingStatus(type: .isLoading)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Country Details"
        output?.viewWillAppear()
        isHideTabBar(true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(flagImage)
        view.addSubview(scrollView)
        scrollView.addSubview(bottomView)
        view.addSubview(loadingStatusView)
    }
    
    private func makeConstraints() {
        flagImage.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(16)
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
}

extension DetailCountryView: DetailCountryViewInput {
    
    func setLoadingStatus(type: ErrorType) {
        loadingStatusView.setLoadingStatus(type: type, view: scrollView)
    }
    
    func setData(data: CountryModel) {
        flagImage.kf.loadImage(urlStr: data.flags?.png ?? "")
        bottomView.setData(data: data)
    }
    
    func reloadData() {
        bottomView.reloadData()
    }
}

extension DetailCountryView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        
        if offSetY > -200 && offSetY < 0 {
            let num = (abs(offSetY) / 20) / 10
            flagImage.alpha = num
            UIView.animate(withDuration: 0) {
                self.flagImage.transform = CGAffineTransform(scaleX: num, y: num)
            }
        }
        
        if offSetY == -200 {
            UIView.animate(withDuration: 0.3) {
                self.flagImage.alpha = 1
                self.flagImage.transform = .identity
            }
        }
    }
}

