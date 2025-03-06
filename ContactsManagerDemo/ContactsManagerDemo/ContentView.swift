//
//  ContentView.swift
//  ContactsManagerDemo
//
//  Created by Arpit Agarwal on 3/5/25.
//

import Contacts
import ContactsManager
import SwiftUI
import RealmSwift

struct ContentView: View {
    @State private var contacts: [Contact] = []
    @State private var authorizationStatus: CNAuthorizationStatus = .notDetermined
    @State private var showingAuthAlert: Bool = false
    @State private var searchText: String = ""
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        }
        if let results = ContactService.shared.contactResults(searchQuery: searchText) {
            return Array(results)
        }
        return []
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch authorizationStatus {
                case .notDetermined:
                    ContactAccessView(requestAccess: requestAccess)
                case .denied, .restricted:
                    ContactDeniedView()
                case .authorized:
                    List {
                        ForEach(filteredContacts) { contact in
                            ContactRow(contact: contact)
                        }
                    }
                case .limited:
                  List {
                    ForEach(filteredContacts) { contact in
                      ContactRow(contact: contact)
                    }
                  }
                @unknown default:
                    Text("Unknown authorization status")
                }
            }
            .navigationTitle("Rolodex")
            .searchable(text: $searchText, prompt: "Search by name, email, or phone")
            .onAppear {
                checkAuthorizationStatus()
            }
            .contactAccessAlert(isPresented: $showingAuthAlert)
        }
    }
    
    private func checkAuthorizationStatus() {
        authorizationStatus = ContactService.shared.contactAuthStatus()
        if authorizationStatus == .authorized {
            loadContacts()
        }
    }
    
    private func requestAccess() {
        requestContactAccess { granted in
            authorizationStatus = granted ? .authorized : .denied
            if granted {
                loadContacts()
            } else {
                showingAuthAlert = true
            }
        }
    }
    
    private func loadContacts() {
        if let results = ContactService.shared.contactResults() {
            contacts = Array(results)
        }
    }
}

// MARK: - Supporting Views
private struct ContactRow: View {
    let contact: Contact
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.displayName ?? "No Name")
                .font(.headline)
            if let firstPhone = contact.phoneNumbers.first,
               let phoneNumber = firstPhone.value {
                Text(phoneNumber)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ContactAccessView: View {
    let requestAccess: () -> Void
    
    var body: some View {
        VStack {
            Text("Contact Access Required")
                .font(.title)
                .padding()
            
            Text("This app needs access to your contacts to display them.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Grant Access") {
                requestAccess()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

private struct ContactDeniedView: View {
    var body: some View {
        VStack {
            Text("Contact Access Denied")
                .font(.title)
                .padding()
            
            Text("Please enable contact access in Settings to use this app.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Open Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
}

