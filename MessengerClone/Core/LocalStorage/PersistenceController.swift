//
//  PersistenceController.swift
//  MessengerClone
//
//  Created by rentamac on 12/02/2026.
//

import CoreData


final class PersistenceController {
    
    static let shared = PersistenceController()
    let regContactListContainer: NSPersistentContainer
    
    private init() {
        regContactListContainer = NSPersistentContainer(name: "RegisteredContactContainer")
        regContactListContainer.loadPersistentStores { _, error in
            if let error {
                print("Core Data load error:", error.localizedDescription)
            }else{
                print("Core Data loaded successfully")
            }
        }
    }
    
    
    func saveContext() {
        let context = regContactListContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error:", error.localizedDescription)
            }
        }
    }
    
    func createRegCon(appUser: AppUser, isReg: Bool){
        let regCon=RegisteredContact(context: regContactListContainer.viewContext)
        regCon.databaseId=appUser.uid
        regCon.firstName=appUser.firstName
        regCon.lastName=appUser.lastName
        regCon.idPhNo=appUser.phoneNumber
        regCon.isReg=isReg
        regCon.gender=""
        saveContext()
    }


    func fetchContactsDetails()-> [RegisteredContact]{
        let fetchReq = NSFetchRequest<RegisteredContact>(entityName: "RegisteredContact")
        do {
            return try regContactListContainer.viewContext.fetch(fetchReq)
        } catch let error{
                print("print the error \(error)")
        }
        return []
    }

    func updateRegCon(regCon: RegisteredContact){
        
        saveContext()
    }
   
    func fetUserById(id: String)->RegisteredContact?{
        let fetchReq: NSFetchRequest<RegisteredContact> = RegisteredContact.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "databaseId == %@", id)
        do {
            return try regContactListContainer.viewContext.fetch(fetchReq).first
        } catch let error{
            print("print the error \(error)")
        }
        return nil
    }
    
    func deleteContact(_ contact: RegisteredContact) {
        regContactListContainer.viewContext.delete(contact)

        do {
            try regContactListContainer.viewContext.save()
        } catch {
            print("Failed to delete contact:", error)
        }
    }
    
    func fetchUserIDs(from objectIDs: Set<NSManagedObjectID>) -> [String] {
        
        
        var userIDs: [String] = []
        
        regContactListContainer.viewContext.performAndWait {
            for objectID in objectIDs {
                do {
                    if let contact = try regContactListContainer.viewContext.existingObject(with: objectID) as? RegisteredContact,
                       let userID = contact.databaseId {
                        userIDs.append(userID)
                    }
                } catch {
                    print("Failed to fetch object for ID: \(objectID), error: \(error)")
                }
            }
        }
        
        return userIDs
    }


    
}
