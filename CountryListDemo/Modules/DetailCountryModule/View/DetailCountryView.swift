import UIKit

protocol DetailCountryViewInput: View {
    func setData(data: CountryModel)
    func reloadData()
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
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Country Details"
        output?.viewWillAppear()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(flagImage)
        view.addSubview(scrollView)
        scrollView.addSubview(bottomView)
    }
    
    private func makeConstraints() {
        flagImage.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.width.equalToSuperview().inset(32)
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
        bottomView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
}

extension DetailCountryView: DetailCountryViewInput {
    
    func setData(data: CountryModel) {
        flagImage.kf.loadImage(urlStr: data.flags?.png ?? "")
        bottomView.setData(data: data)
    }
    
    func reloadData() {
        bottomView.reloadData()
    }
}

extension DetailCountryView: CurtainScrollDelegate {
    
    func setOffset() -> CGFloat {
        return .zero
    }
    
    func getOffSet(offset: CGFloat) {
        scrollView.contentOffset.y = offset
    }
}

extension DetailCountryView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        
        if scrollView.contentOffset.y <= -200 {
            scrollView.contentOffset.y = -200
        }
        
        if scrollView.contentOffset.y >= 0 {
            scrollView.contentOffset.y = 0
        }
                
        if offSetY > -200 && offSetY < 0 {
            let num = (abs(offSetY) / 20) / 10
            flagImage.alpha = num
            UIView.animate(withDuration: 0) {
                self.flagImage.transform = CGAffineTransform(scaleX: num, y: num)
            }
        }
    }
}

