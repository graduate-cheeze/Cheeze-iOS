import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class DecoViewController: BaseVC<DecoViewModel>, UIGestureRecognizerDelegate {
    private let menuType: [String] = ["스티커", "프레임"]

    private var stickerObjectViews: [StickerObjectView] = []

    private let imageBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
        $0.isUserInteractionEnabled = true
    }

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

    private lazy var saveButton = UIButton().then {
        $0.backgroundColor = .red
        $0.addTarget(self, action: #selector(chooseSaveButtonClicked), for: .touchUpInside)
    }

    private func showStickerObjectView(image: UIImage) {
        // stickerObjectView 생성
        let stickerObjectView = StickerObjectView(image: image)
        mainImageView.addSubview(stickerObjectView)

        stickerObjectView.center = mainImageView.center
        stickerObjectView.bounds.size = CGSize(width: 70, height: 70)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        panGestureRecognizer.delegate = self
        stickerObjectView.addGestureRecognizer(panGestureRecognizer)

        // 스티커 객체 뷰 배열에 추가
        stickerObjectViews.append(stickerObjectView)
        print("ㅋㅋ")
    }

    private func updateMainImageViewSize() {
        guard let image = mainImageView.image else { return }

        let imageSize = image.size
        let aspectRatio = imageSize.width / imageSize.height

        // Calculate the new size based on the aspect ratio and the available width
        let maxWidth = mainImageView.superview?.bounds.width ?? UIScreen.main.bounds.width
        let newWidth = min(imageSize.width, maxWidth)
        let newHeight = newWidth / aspectRatio

        // Update the size of mainImageView
        mainImageView.bounds.size = CGSize(width: newWidth, height: newHeight)
    }

    @objc private func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let stickerObjectView = gestureRecognizer.view as? StickerObjectView else { return }

        // 스티커 객체 뷰 배열에서 현재 제스처 이벤트를 받고 있는 스티커 객체 뷰 식별
        if let index = stickerObjectViews.firstIndex(of: stickerObjectView) {
            let translation = gestureRecognizer.translation(in: mainImageView)

            // 스티커 객체 뷰 이동 처리
            var center = stickerObjectView.center
            center.x += translation.x
            center.y += translation.y

            // Limit the movement of stickerObjectView to mainImageView bounds
            let minX = stickerObjectView.bounds.width
            let maxX = mainImageView.bounds.width - (stickerObjectView.bounds.width) / 2
            let minY = stickerObjectView.bounds.height
            let maxY = mainImageView.bounds.height - (stickerObjectView.bounds.height) / 2

            center.x = max(minX, min(maxX, center.x))
            center.y = max(minY, min(maxY, center.y))

            stickerObjectView.center = center
            gestureRecognizer.setTranslation(.zero, in: stickerObjectView)
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
                           otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func chooseSaveButtonClicked(sender: UIButton) {
        // 사진 저장 코드
        let saveImage = mainImageView.asImage()
        UIImageWriteToSavedPhotosAlbum(saveImage, self, nil, nil)
        print("save")
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
                self?.updateMainImageViewSize()
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
        let img = oneFrameView.asImage()
        mainImageView.image = img
    }

    private func setFourImage() {
        fourFrameView.isHidden = false
        oneFrameView.isHidden = true
        mainImageView.image = .none

        mainImageView.addSubview(fourFrameView)

        fourFrameView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        viewModel.selectedPhotos
            .subscribe(onNext: { [weak self] images in
                guard images.count >= 4 else { return }
                self?.fourFrameView.setImage(img1: images[0], img2: images[1], img3: images[2], img4: images[3])

                guard let img = self?.fourFrameView.asImage() else { return print("no")}

                // Set the image to mainImageView
                self?.mainImageView.image = img
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

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func addView() {
        view.addSubviews(mainImageView, oneFrameButton, menuTypeSegmentedControl,
                         stickerCollectionView, saveButton)
    }

    override func setLayout() {
        mainImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.6)
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

        stickerCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuTypeSegmentedControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(menuTypeSegmentedControl.snp.top)
            $0.leading.equalTo(menuTypeSegmentedControl.snp.trailing).offset(10)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
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
