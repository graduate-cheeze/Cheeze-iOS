import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class DecoViewController: BaseVC<DecoViewModel>, UIGestureRecognizerDelegate {
    private let menuType: [String] = ["스티커", "프레임"]

    private var stickerObjectView: StickerObjectView?

    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
        $0.isUserInteractionEnabled = true
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
        $0.isUserInteractionEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.clipsToBounds = true
        $0.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.identifier)
        $0.isHidden = true
    }

    private func showStickerObjectView(image: UIImage) {
        // stickerObjectView 생성
        stickerObjectView = StickerObjectView(image: image)
        mainImageView.addSubview(stickerObjectView!)

        stickerObjectView?.center = mainImageView.center
        stickerObjectView?.bounds.size = CGSize(width: 70, height: 70)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        panGestureRecognizer.delegate = self
        stickerObjectView?.addGestureRecognizer(panGestureRecognizer)
        print("ㅋㅋ")
    }

    @objc private func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: stickerObjectView)

        var center = stickerObjectView?.center ?? CGPoint.zero
        center.x += translation.x
        center.y += translation.y

        // Limit the movement of stickerObjectView to mainImageView bounds
        let minX = stickerObjectView?.bounds.width ?? 0 / 2
        let maxX = mainImageView.bounds.width - (stickerObjectView?.bounds.width ?? 0) / 2
        let minY = stickerObjectView?.bounds.height ?? 0 / 2
        let maxY = mainImageView.bounds.height - (stickerObjectView?.bounds.height ?? 0) / 2

        center.x = max(minX, min(maxX, center.x))
        center.y = max(minY, min(maxY, center.y))

        stickerObjectView?.center = center
        gesture.setTranslation(.zero, in: stickerObjectView)
    }

    // ...

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    private func bindCollectionView() {
        viewModel.photosList
            .bind(to: stickerCollectionView.rx.items(
                cellIdentifier: StickerCollectionViewCell.identifier,
                cellType: StickerCollectionViewCell.self)) { _, photo, cell in
                cell.stickerButtonView.setImage(img: photo)
            }
            .disposed(by: disposeBag)

        stickerCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self!.stickerCollectionView.cellForItem(at: indexPath) as?
                        StickerCollectionViewCell else { return }
                guard let selectedImage = cell.stickerButtonView.buttonIconImageView.image else { return }

                self?.showStickerObjectView(image: selectedImage)
            })
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

    // MARK: - ConfigureVC
    override func configureVC() {
        navigationItem.title = "1/10"
        self.tabBarController?.tabBar.isHidden = true
        stickerCollectionView.delegate = self

        menuTypeSegmentedControl.selectedSegmentIndex = 1
        oneFrameButtonDidTap()
        setMainImage()
        bindCollectionView()
    }
    @objc private func mainImageTapGestureHandler(_ gesture: UITapGestureRecognizer) {
        print("Main image tapped")
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func addView() {
        view.addSubviews(mainImageView, oneFrameView,
                         fourFrameView, menuTypeSegmentedControl,
                         oneFrameButton, stickerCollectionView)
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
}
