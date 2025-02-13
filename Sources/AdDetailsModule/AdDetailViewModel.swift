//
//  AdDetailViewModel.swift
//  Geev
//
//  Created by Gaida Salwa on 12/02/2025.
//


import RxSwift
import RxCocoa
import AppModels

public class AdDetailViewModel {
    private let useCase: AdDetailUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    let adDetail = BehaviorRelay<Ad?>(value: nil)
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String?>(value: nil)
    
    public init(useCase: AdDetailUseCaseProtocol) {
        self.useCase = useCase
    }
    
    @MainActor
    func fetchAdDetail(id: String) async {
        isLoading.accept(true)
        
        Task {
            do {
                let ad = try await useCase.fetchAdDetail(identifier: id)
                self.adDetail.accept(ad)
                self.isLoading.accept(false)
            } catch {
                self.errorMessage.accept(error.localizedDescription)
                self.isLoading.accept(false)
            }
        }
    }
}
