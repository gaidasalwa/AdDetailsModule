//
//  AdDetailViewController.swift
//  GeevTest
//
//  Created by Gaida Salwa on 10/02/2025.
//

import UIKit
import RxSwift
import RxCocoa
import AppModels

public class AdDetailViewController: UIViewController {
    private let viewModel: AdDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    public init(viewModel: AdDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        Task {
            await fetchData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        imageView.contentMode = .scaleAspectFill
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func bindViewModel() {
        viewModel.adDetail
            .compactMap { $0 } // Ignorer les valeurs `nil`
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] ad in
                self?.updateUI(with: ad)
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.activityIndicator.isHidden = !isLoading
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let error = error, !error.isEmpty else { return }
                self?.showError(error)
            })
            .disposed(by: disposeBag)
    }
    
    @MainActor
    private func fetchData() async {
        await viewModel.fetchAdDetail(id: "67462abca4ddfca45fe05311")
    }
    
    private func updateUI(with ad: Ad) {
        titleLabel.text = ad.title
        descriptionLabel.text = ad.description
        if let imageUrl = ad.imageUrl,
           let url = URL(string: imageUrl) {
            loadImage(from: url)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func loadImage(from url: URL) {
        Task {
            do {
                let data = try await URLSession.shared.data(from: url).0
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } catch {
                print("Erreur chargement image:", error)
            }
            
        }
    }
}
