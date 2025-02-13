//
//  AdDetailUseCaseProtocol.swift
//  Geev
//
//  Created by Gaida Salwa on 12/02/2025.
//


import Foundation
import AppModels
import CoreModule
import Extensions
import Factory
import AppDI

public protocol AdDetailUseCaseProtocol {
    func fetchAdDetail(identifier: String) async throws -> Ad
}

public class AdDetailUseCase: AdDetailUseCaseProtocol {
    @Injected(\.httpClient) private var httpClient: HTTPClientProtocol
    
    public init() {}
    
    public func fetchAdDetail(identifier: String) async throws -> Ad {
        let urlRequest = Endpoint.fetchAdDetail(identifier: identifier).urlRequest
        do {
            let adResponse: AdDetailResponse = try await httpClient.sendRequest(to: urlRequest)
            print("✅ Annonce : \(adResponse)")
            var imageUrl: String = ""
            if let image = adResponse.pictures.first {
                imageUrl = "https://images.geev.fr/\(image)/squares/300"
            }
            return Ad(
                id: adResponse.id,
                imageUrl: imageUrl, // créer une fonction pour composer l'url de l'image
                createdSince: adResponse.creationTimestamp.minutesSince(),
                distance: 0, // à mettre à jour avec la bonne distance
                title: adResponse.title,
                description: adResponse.description
            )
        } catch {
            print("❌ Erreur : \(error)")
            throw error
        }
    }
}
