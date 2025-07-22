//
//  CastomCell.swift
//  LuxuryTest
//
//  Created by dany on 18.07.2025.
//
import UIKit

class CastomCell: UITableViewCell {
    
    let model = ViewModel()
    let dataModel = Model()
    var currentCompany: String?
    var react = false
    
    //MARK: - UI
    private var name: UILabel = {
        let lable = UILabel()
        lable.font = .systemFont(ofSize: 16, weight: .semibold)
        lable.numberOfLines = 0
        lable.setContentCompressionResistancePriority(.required, for: .vertical)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let lable: UILabel = {
        let lable = UILabel()
        lable.font = .boldSystemFont(ofSize: 20)
        lable.numberOfLines = 2
        lable.setContentCompressionResistancePriority(.required, for: .vertical)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let price: UILabel = {
        let lable = UILabel()
        lable.font = .boldSystemFont(ofSize: 20)
        lable.numberOfLines = 1
        lable.textAlignment = .right
        lable.setContentCompressionResistancePriority(.required, for: .vertical)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let favorite: UIButton = {
        var reaction = false
        let button = UIButton()
        let image = UIImage(named: "notLike")
        button.setImage(image, for: .normal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let photo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Constants
    private func setupUI() {
        contentView.addSubview(photo)
        contentView.addSubview(lable)
        contentView.addSubview(name)
        contentView.addSubview(price)
        contentView.addSubview(favorite)
            
            NSLayoutConstraint.activate([
                photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                photo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                photo.widthAnchor.constraint(equalToConstant: 50),
                photo.heightAnchor.constraint(equalToConstant: 50),
                photo.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
                
                lable.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 20),
                lable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                lable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -25),
                lable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
                
                price.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 200),
                price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                price.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -25),
                price.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
                
                name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant: 20),
                name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                name.topAnchor.constraint(equalTo: lable.topAnchor, constant: 60),
                name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                
                favorite.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -80),
                favorite.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                favorite.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -25),
                favorite.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            ])
        }
    //MARK: - Favorite
    
    private func updateFavoriteButton() {
        guard let company = currentCompany else { return }
        let isFavorite = dataModel.isFavorite(company: company)
        let imageName = isFavorite ? "like" : "notLike"
        favorite.setImage(UIImage(named: imageName), for: .normal)
        react = isFavorite
    }
    
    
    private func like(_ button: UIButton) {
        button.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    @objc func tap() {
        guard let company = currentCompany else { return }
        
        if react {
            dataModel.removeFavorite(company: company)
        } else {
            dataModel.addFavorite(company: company)
        }
        
        updateFavoriteButton()
    }

    //MARK: - Configurate
    
    public func configurate(with company: String, _ tableView: UITableView) {
        currentCompany = company
        updateFavoriteButton()
        
        like(favorite)
        DispatchQueue.main.async {
            self.lable.text = company
        }
        if let index = dataModel.arrayCompany.firstIndex(of: company) {
            
            model.getCompanyInfoAndImage(index) { [weak self] price, name, image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.name.text = name
                    self.price.text = price
                    self.photo.image = image
                }
            }
        }
    }
}
