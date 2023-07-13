import UIKit
import Photos
import AVFoundation

final class CaptureViewController: BaseVC<CaptureViewModel>, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    var image1: UIImage?

    private let leftLogoLabel = UILabel().then {
        $0.text = "사진찍기"
    }

    private let logoImageView = UIImageView().then {
        $0.image = CheezeAsset.Image.hanni.image
    }

    private let takeImageView = UIView().then {
        $0.backgroundColor = .white
    }

    private let takeButton = TakePhotoButton()

    private let changeCameraButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.setImage(CheezeAsset.Image.changeCamera.image, for: .normal)
        $0.backgroundColor = CheezeAsset.Colors.neutral50.color
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            return
        }

        let saveImageView = UIImageView(image: image)
        saveImageView.frame = CGRect(x: 0, y: 0, width: 390, height: 390)
        saveImageView.contentMode = .scaleAspectFill
        saveImageView.addSubview(logoImageView)

        videoPreviewLayer.isHidden = false
        logoImageView.isHidden = false

        DispatchQueue.main.async { [weak self] in
            self?.chooseSaveButtonClicked(saveImg: saveImageView.asImage())
        }
    }

    private func takePhotoButtonDidTap() {
        takeButton.mainButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.takeButtonClicked()
            }.disposed(by: disposeBag)
    }
    
    private func changeCameraButtonDidTap() {
        changeCameraButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.returnButtonClicked()
            }
    }

    private func chooseSaveButtonClicked(saveImg: UIImage) {
        // 사진 저장 코드
        UIImageWriteToSavedPhotosAlbum(saveImg, self, nil, nil)
    }

    private func takeButtonClicked() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        logoImageView.frame = CGRect(x: 0, y: 0,
                                     width: takeImageView.bounds.width,
                                     height: takeImageView.bounds.height)

        videoPreviewLayer.addSublayer(logoImageView.layer)

        takeImageView.layer.addSublayer(videoPreviewLayer)
        takeImageView.addSubview(logoImageView)

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.takeImageView.bounds
            }
        }
    }

    override func configureVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftLogoLabel)
        takePhotoButtonDidTap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        } catch let error {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }

    private func returnButtonClicked() {
            print("return")
            // 카메라 전환 기능 코드
            captureSession?.beginConfiguration()
            let currentInput = captureSession?.inputs.first as? AVCaptureDeviceInput
            captureSession?.removeInput(currentInput!)

            let newCameraDevice = currentInput?.device.position == .back ? camera(with: .front) : camera(with: .back)
            let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
            captureSession?.addInput(newVideoInput!)
            captureSession?.commitConfiguration()
    }

    func camera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        return devices.devices.filter { $0.position == position }.first
    }

    override func addView() {
        view.addSubviews(takeImageView, takeButton, changeCameraButton)
    }

    override func setLayout() {
        takeImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(64)
            $0.height.equalTo(390)
            $0.width.equalToSuperview()
        }

        takeButton.snp.makeConstraints {
            $0.top.equalTo(takeImageView.snp.bottom).offset(89)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }

        changeCameraButton.snp.makeConstraints {
            $0.centerY.equalTo(takeButton)
            $0.leading.equalTo(takeButton.snp.trailing).offset(69)
            $0.size.equalTo(45)
        }
    }
}
