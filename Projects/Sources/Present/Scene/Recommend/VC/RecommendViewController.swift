import UIKit

protocol RecommendViewControllerDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

final class RecommendViewController: BaseVC<RecommendViewModel> {
    weak var delegate: RecommendViewControllerDelegate?

    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 8
    }

    private lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {

        $0.isUserInteractionEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.clipsToBounds = true
        $0.register(RecommendCell.self, forCellWithReuseIdentifier: RecommendCell.identifier)
    }

    override func configureVC() {
        navigationItem.title = "포즈추천"
        self.tabBarController?.tabBar.isHidden = true
        recommendCollectionView.delegate = self

        bindCollectionView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func bindCollectionView() {
        viewModel.recommendList
            .bind(to: recommendCollectionView.rx.items(
                cellIdentifier: RecommendCell.identifier,
                cellType: RecommendCell.self)) { _, photo, cell in
                    cell.mainImageView.image = photo
            }
            .disposed(by: disposeBag)

        recommendCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self!.recommendCollectionView.cellForItem(at: indexPath) as?
                        RecommendCell else { return }
                let image = cell.mainImageView.image

                self?.delegate?.didSelectImage(image!)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    override func addView() {
        view.addSubview(recommendCollectionView)
    }

    override func setLayout() {
        recommendCollectionView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}

extension RecommendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width, height: 390)
    }
}
