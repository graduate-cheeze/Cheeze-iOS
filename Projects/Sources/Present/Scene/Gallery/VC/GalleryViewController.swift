import UIKit
import Photos

final class GalleryViewController: BaseVC<GalleryViewModel> {
    private var selectedPhotos: [PHAsset] = []
    private let maxSelectionCount = 4

    private let leftLogoLabel = UILabel().then {
        $0.text = "갤러리"
    }

    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 3
        $0.minimumInteritemSpacing = 3
    }

    private lazy var galleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    private var fetchResult: PHFetchResult<PHAsset>?
    private let imageManager = PHImageManager.default()

    override func configureVC() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        if status == .authorized {
            // 권한이 승인된 경우 갤러리 로드 작업 진행
            self.loadGallery()
        } else if status == .denied || status == .restricted {
            // 권한이 거부되거나 제한된 경우 알림을 표시하거나 대체 작업 수행
            // 사용자에게 권한을 요청하도록 안내할 수도 있습니다.
        } else if status == .notDetermined {
            // 권한이 아직 결정되지 않은 경우 권한 요청
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == .authorized {
                    // 권한이 승인된 경우 갤러리 로드 작업 진행
                    self.loadGallery()
                } else {
                    // 권한이 거부되거나 제한된 경우 알림을 표시하거나 대체 작업 수행
                }
            }
        }

        self.loadGallery()

        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        galleryCollectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.identifier)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftLogoLabel)
    }

    func loadGallery() {
        let fetchOptions = PHFetchOptions()

        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: fetchOptions)
    }

    override func addView() {
        view.addSubviews(galleryCollectionView)
    }

    override func setLayout() {
        galleryCollectionView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.identifier,
                                                            for: indexPath) as? GalleryCell else {
            fatalError("Unable to dequeue GalleryCell")
        }

        cell.imageView.layer.cornerRadius = 8

        if let asset = fetchResult?.object(at: indexPath.item) {
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isSynchronous = false
            options.deliveryMode = .highQualityFormat // 고화질 이미지 제공
            options.resizeMode = .exact

            imageManager.requestImage(for: asset, targetSize:
                                        CGSize(width: 181, height: 181),
                                      contentMode: .aspectFill,
                                      options: options) { image, _ in
                cell.imageView.image = image
                cell.layer.cornerRadius = 8
            }
        }

        // 셀의 데이터 설정
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width / 2.02
        let height = view.bounds.height / 4.3
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? GalleryCell,
              let asset = fetchResult?.object(at: indexPath.item) else {
            return
        }

        if selectedPhotos.contains(asset) {
            if let index = selectedPhotos.firstIndex(of: asset) {
                selectedPhotos.remove(at: index)
            }
            cell.isSelected = false
            cell.changeColor(num: "", hidden: true)
        } else {
            if selectedPhotos.count < maxSelectionCount {
                selectedPhotos.append(asset)
                cell.isSelected = true
                cell.changeColor(num: "\(selectedPhotos.count)", hidden: false)
            } else {

            }
        }

        updateCellUI()
    }

    func updateCellUI() {
        for indexPath in galleryCollectionView.indexPathsForVisibleItems {
            guard let cell = galleryCollectionView.cellForItem(at: indexPath) as? GalleryCell,
                  let asset = fetchResult?.object(at: indexPath.item) else {
                continue
            }

            if selectedPhotos.contains(asset) {
                if let index = selectedPhotos.firstIndex(of: asset) {
                    cell.changeColor(num: "\(index + 1)", hidden: false)
                }
            } else {
                cell.changeColor(num: "", hidden: true)
            }
        }
    }
}
