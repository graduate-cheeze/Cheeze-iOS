import UIKit
import Photos
import RxSwift
import RxCocoa
import RxRelay

final class DecoViewController: BaseVC<DecoViewModel> {
    private let menuType: [String] = ["스티커", "프레임"]

    private var stickerObjectViews: [StickerObjectView] = []

    private let imageBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
        $0.isUserInteractionEnabled = true
    }

    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor.cheezeColor(.neutral(.neutral10))
        $0.isUserInteractionEnabled = true
        $0.clipsToBounds = true
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
        $0.layer.shadowOpacity = 0.8
        $0.layer.shadowRadius = 3
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

    private lazy var uploadButton = UIBarButtonItem(image: CheezeAsset.Image.upload.image, style: .plain, target: nil, action: nil)

    // MARK: - Create Sticker

    private func showStickerObjectView(image: UIImage) {
        let stickerObjectView = StickerObjectView(image: image)
        mainImageView.addSubview(stickerObjectView)

        stickerObjectView.center = mainImageView.center
        stickerObjectView.bounds.size = CGSize(width: 90, height: 90)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))
        stickerObjectView.addGestureRecognizer(panGesture)

        stickerObjectViews.append(stickerObjectView)
        print("하하")
    }

    @objc func panGestureHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let stickerObjectView = gestureRecognizer.view as? StickerObjectView else { return }

        if let index = stickerObjectViews.firstIndex(of: stickerObjectView) {
            let translation = gestureRecognizer.translation(in: mainImageView)

            var center = stickerObjectView.center
            center.x += translation.x
            center.y += translation.y

            let minX = stickerObjectView.bounds.width - 25
            let maxX = mainImageView.bounds.width - (stickerObjectView.bounds.width) / 2
            let minY = stickerObjectView.bounds.height - 35
            let maxY = mainImageView.bounds.height - (stickerObjectView.bounds.height) / 2

            center.x = max(minX, min(maxX, center.x))
            center.y = max(minY, min(maxY, center.y))

            stickerObjectView.center = center
        }
    }

    private func chooseSaveButtonClicked() {
        let renderer = UIGraphicsImageRenderer(bounds: mainImageView.bounds)

        let saveImage = renderer.image { context in
            mainImageView.layer.render(in: context.cgContext)
        }

        if let pngData = saveImage.pngData() {
            let photoLibrary = PHPhotoLibrary.shared()
            photoLibrary.performChanges({
                let request = PHAssetCreationRequest.forAsset()
                request.addResource(with: .photo, data: pngData, options: nil)
            }) { success, error in
                if success {
                    print("Saved image as PNG")
                } else if let error = error {
                    print("Error saving image: \(error.localizedDescription)")
                }
            }
        } else {
            print("Failed to convert image to PNG data")
        }
    }

    private func uploadButtonDidTap() {
        uploadButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.shareToInstaStories()
                owner.chooseSaveButtonClicked()
            }
    }

    private func shareToInstaStories() {
        let renderer = UIGraphicsImageRenderer(bounds: mainImageView.bounds)

        let saveImage = renderer.image { context in
            mainImageView.layer.render(in: context.cgContext)
        }

        let appID = "Cheeze"

        let backgroundImage = CheezeAsset.Image.background.image

        if let storiesUrl = URL(string: "instagram-stories://share?source_application=\(appID)") {
            if UIApplication.shared.canOpenURL(storiesUrl) {

                let image = mainImageView.asImage()

                guard let imageData = image.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                    "com.instagram.sharedSticker.stickerImage": imageData,
                    "com.instagram.sharedSticker.backgroundImage": backgroundImage
                ]
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
            } else {
                print("User doesn't have instagram on their device.")
            }
        }
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

        mainImageView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.6)
        }

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
        mainImageView.layer.cornerRadius = 16
        mainImageView.translatesAutoresizingMaskIntoConstraints = false

        oneFrameView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        mainImageView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(444)
            $0.width.equalTo(375)
        }

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
        mainImageView.layer.cornerRadius = 16
        mainImageView.translatesAutoresizingMaskIntoConstraints = false

        fourFrameView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        mainImageView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(510)
            $0.width.equalTo(375)
        }

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

    // MARK: - ConfigureVC
    override func configureVC() {
        navigationItem.title = "꾸미기"
        self.tabBarController?.tabBar.isHidden = true
        stickerCollectionView.delegate = self

        menuTypeSegmentedControl.selectedSegmentIndex = 1
        oneFrameButtonDidTap()
        setMainImage()
        bindCollectionView()
        uploadButtonDidTap()
        navigationItem.rightBarButtonItem = uploadButton
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func addView() {
        view.addSubviews(imageBackgroundView, mainImageView, oneFrameButton,
                         menuTypeSegmentedControl, stickerCollectionView)
        mainImageView.addSubviews(oneFrameView, fourFrameView)
    }

    override func setLayout() {
        imageBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.6)
        }

        mainImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.6)
        }

        menuTypeSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(imageBackgroundView.snp.bottom).offset(20)
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
