import UIKit

final class DecoViewController: BaseVC<DecoViewModel> {
    private let menuType: [String] = ["스티커", "프레임"]

    private let mainImageView = UIImageView().then {
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
    }

    private let oneFrameView = OneFrameView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }

    private let oneFrameButton = ButtonContainer()

    private let fourFrameView = FourFrameView().then {
        $0.isHidden = true
    }

    private func oneFrameButtonDidTap() {
        oneFrameButton.oneFrameButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.setMainImage()
            }.disposed(by: disposeBag)

        oneFrameButton.fourFrameButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.setFourImage()
            }.disposed(by: disposeBag)
    }

    private func setMainImage() {
        oneFrameView.isHidden = false
        fourFrameView.isHidden = true

        viewModel.selectedPhotos// 첫 번째 이미지만 받아오도록 함
            .subscribe(onNext: { [weak self] images in
                guard let firstImage = images.first else { return }
                self?.oneFrameView.setImage(img: firstImage)
            })
            .disposed(by: disposeBag)
    }

    private func setFourImage() {
        fourFrameView.isHidden = false
        oneFrameView.isHidden = true

        viewModel.selectedPhotos
            .subscribe(onNext: { [weak self] images in
                guard images.count >= 4 else {
                    return
                }

                self?.fourFrameView.setImage(img1: images[0], img2: images[1], img3: images[2], img4: images[3])
            })
            .disposed(by: disposeBag)
    }

    private func bindViewMode() {
        let input = DecoViewModel.Input()
        let output = viewModel.transVC(input: input)
    }

    override func configureVC() {
        navigationItem.title = "1/10"
        oneFrameButtonDidTap()
    }

    override func addView() {
        view.addSubviews(mainImageView, oneFrameView, fourFrameView, menuTypeSegmentedControl, oneFrameButton)
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
    }
}
