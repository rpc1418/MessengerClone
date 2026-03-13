//
//  ContactRowCard.swift
//  MessengerClone
//
//  Created by rentamac on 16/02/2026.
//
import SwiftUI
import CoreData

struct ContactRowView: View {
    let contact: RegisteredContact
    let onTap: (RegisteredContact) -> Void
    @Binding var isMultiSelectEnabled: Bool
    @Binding var selectedContactIDs: Set<NSManagedObjectID>

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(contact.fullName)
                .font(.headline)

            Text(contact.isReg ? "reg user" : "not reg user")

            if let phone = contact.idPhNo {
                Text(phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap(contact)
        }
        .swipeActions(edge: .trailing) {
            Button {
                print("Message \(contact.fullName)")
            } label: {
                Label("Message", systemImage: "message.fill")
            }
            .tint(.green)

            Button {
                print("Call \(contact.fullName)")
            } label: {
                Label("Call", systemImage: "phone.fill")
            }
            .tint(.green)

            Button {
                selectedContactIDs.insert(contact.objectID)
                isMultiSelectEnabled.toggle()
            } label: {
                Label("Select", systemImage: "checkmark.circle.fill")
            }
            .tint(.blue)
        }
        .contextMenu {
            Button {
                print("Message \(contact.fullName)")
            } label: {
                Label("Message", systemImage: "message.fill")
            }
            .tint(.green)

            Button {
                print("Call \(contact.fullName)")
            } label: {
                Label("Call", systemImage: "phone.fill")
            }
            .tint(.green)

            Button {
                selectedContactIDs.insert(contact.objectID)
                isMultiSelectEnabled.toggle()
            } label: {
                Label("Select", systemImage: "checkmark.circle.fill")
            }
            .tint(.blue)
        }
        .tag(contact.objectID)
    }
}
extension RegisteredContact {
    var fullName: String {
        "\(firstName ?? "") \(lastName ?? "")"
    }
}
