//
//  AdDetailViewControllerWrapper.swift
//  GeevTest
//
//  Created by Gaida Salwa on 10/02/2025.
//


import SwiftUI
import UIKit
import SharedModels

struct AdDetailViewControllerWrapper: UIViewControllerRepresentable {
    let ad: Ad

    func makeUIViewController(context: Context) -> AdDetailViewController {
        let viewController = AdDetailViewController(viewModel: AdDetailViewModel(useCase: AdDetailUseCase()))
        return viewController
    }

    func updateUIViewController(_ uiViewController: AdDetailViewController, context: Context) {
        // Mise à jour si besoin
    }
}
