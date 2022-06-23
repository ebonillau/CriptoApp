//
//  sd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 15/06/22.
//

import Foundation
import CoreData

class PortofolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName = "PortofolioContainer"
    private let portofolioEntityName = "Portofolio"
    
    @Published var savedEntities: [Portofolio] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] (_, error) in
            if let error = error {
                print("Error loading CoreData. \(error.localizedDescription)")
            }
            self?.getPortofolio()
        }
    }
    
    func updatePortofolio(coin: Coin, amount: Double) {
        
        if let entity = savedEntities.first(where: { $0.coinID == coin.id}) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    private func getPortofolio() {
        let request = NSFetchRequest<Portofolio>(entityName: portofolioEntityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching Portofolio Entities. \(error.localizedDescription)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = Portofolio(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: Portofolio, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: Portofolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to CoreData. \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortofolio()
    }
}
