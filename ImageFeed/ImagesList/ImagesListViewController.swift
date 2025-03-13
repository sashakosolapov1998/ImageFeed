//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр Косолапов on 28.02.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map { "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
       
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = photosName[indexPath.row]
        
        // Проверяем, можно ли создать UIImage
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        cell.cellImage.image = image
        
        // Устанавливаем текущую дату
        let currentDate = Date()
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        
        // Устанавливаем состояние кнопки лайка
        cell.likeButton.isSelected = indexPath.row % 2 == 0
    }
    
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            print("Ошибка: Ячейка не является типом ImagesListCell")
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            // Получаем имя изображения
            let imageName = photosName[indexPath.row]
            
            // Получаем изображение из ресурсов
            guard let image = UIImage(named: imageName) else {
                // Возвращаем стандартную высоту, если изображения нет
                return 200
            }
            
            // Вычисляем ширину изображения
            let imageWidth = tableView.bounds.width - 32 // отступы по 16 слева и справа
            
            // Вычисляем высоту, сохраняя соотношение сторон
            let imageHeight = image.size.height / image.size.width * imageWidth
            
            // Возвращаем высоту с учетом отступов сверху и снизу
            return imageHeight + 16 + 8 // 16 сверху, 8 снизу
        }

    
}
