import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class DecoViewController: BaseVC<DecoViewModel> {
    private let menuType: [String] = ["스티커", "프레임"]

    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
    }

    private lazy var menuTypeSegmentedControl = UISegmentedControl(items: menuType).then {
        $0.backgroundColor = .clear
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                    UIColor.cheezeColor(.neutral(.neutral30)),
                                   .font: CheezeFontFamily.Pretendard.bold.font(size: 15)], for: .normal)
        $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
                                    UIColor.black,
                                   .font: CheezeFontFamily.Pretendard.bold.font(size: 15)], for: .selected)
        $0.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }

    private let oneFrameView = OneFrameView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    private let fourFrameView = FourFrameView().then {
        $0.isHidden = true
    }

    private let oneFrameButton = ButtonContainer()

    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 8
    }

    private lazy var stickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.clipsToBounds = true
        $0.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)
        $0.isHidden = true
    }
    
    private func bindCollectionView() {
        viewModel.photosList
            .bind(to: stickerCollectionView.rx.items(cellIdentifier: StickerCollectionViewCell.identifier, cellType: StickerCollectionViewCell.self)) { _ , photo, cell in
                cell.stickerButtonView.setImage(img: photo)
            }
            .disposed(by: disposeBag)
    }

    private func oneFrameButtonDidTap() {
        oneFrameButton.oneFrameButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.setOneImage()
            }.disposed(by: disposeBag)

        oneFrameButton.fourFrameButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.setFourImage()
            }.disposed(by: disposeBag)

        oneFrameButton.xButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.setMainImage()
            }.disposed(by: disposeBag)
    }

    private func setMainImage() {
        oneFrameView.isHidden = true
        fourFrameView.isHidden = true

        viewModel.selectedPhotos
            .subscribe(onNext: { [weak self] images in
                guard let firstImage = images.first else { return }
                self?.mainImageView.image = firstImage
            })
            .disposed(by: disposeBag)
    }

    private func setOneImage() {
        oneFrameView.isHidden = false
        fourFrameView.isHidden = true
        mainImageView.image = .none

        viewModel.selectedPhotos
            .subscribe(onNext: { [weak self] images in
                guard let firstImage = images.first else { return }
                self?.oneFrameView.setImage(img: firstImage)
            })
            .disposed(by: disposeBag)
    }

    private func setFourImage() {
        fourFrameView.isHidden = false
        oneFrameView.isHidden = true
        mainImageView.image = .none

        viewModel.selectedPhotos
            .subscribe(onNext: { [weak self] images in
                guard images.count >= 4 else { return }
                self?.fourFrameView.setImage(img1: images[0], img2: images[1], img3: images[2], img4: images[3])
            })
            .disposed(by: disposeBag)
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            oneFrameButton.isHidden = true
            stickerCollectionView.isHidden = false
        } else if selectedIndex == 1 {
            oneFrameButton.isHidden = false
            stickerCollectionView.isHidden = true
        }
    }

    private func bindViewMode() {
        let input = DecoViewModel.Input()
        let output = viewModel.transVC(input: input)
    }

    override func configureVC() {
        navigationItem.title = "1/10"
        self.tabBarController?.tabBar.isHidden = true
        stickerCollectionView.delegate = self

        menuTypeSegmentedControl.selectedSegmentIndex = 1
        oneFrameButtonDidTap()
        setMainImage()
        bindCollectionView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func addView() {
        view.addSubviews(mainImageView, oneFrameView, fourFrameView, menuTypeSegmentedControl, oneFrameButton, stickerCollectionView)
    }

    override func setLayout() {
        mainImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.6)
        }

        oneFrameView.snp.makeConstraints {
            $0.center.equalTo(mainImageView)
        }

        menuTypeSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(48)
        }

        oneFrameButton.snp.makeConstraints {
            $0.top.equalTo(menuTypeSegmentedControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(74)
            $0.height.equalTo(70)
            $0.width.equalTo(226)
        }

        fourFrameView.snp.makeConstraints {
            $0.center.equalTo(mainImageView)
        }

        stickerCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuTypeSegmentedControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
    }
}

extension DecoViewController: UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 70
        let height = 70
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
