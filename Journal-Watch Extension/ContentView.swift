//
//  ContentView.swift
//  Journal-Watch Extension
//
//  Created by Claudia Maciel on 1/16/21.
//  Copyright © 2021 thecoderpilot. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var journalEntries = [EntryRepresentation]()
    @State var title = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("New entry", text: $title)
                Button {
                    guard title.isEmpty == false else { return }
                    let entry = EntryRepresentation(id: UUID().uuidString, title: title, bodyText: "body Text goes here", timestamp: Date(), mood: "happy")
                    journalEntries.append(entry)
                    title = ""
                    self.postEntry(entry: entry)
                } label: {
                    Image(systemName: "plus")
                        .padding()
                }
                .fixedSize()
                .buttonStyle(BorderedButtonStyle(tint: .blue))
            }
            List {
                ForEach(0..<journalEntries.count, id: \.self) { i in
                    NavigationLink(destination: DetailView(entry: journalEntries[i])) {
                        Text(journalEntries[i].title)
                            .lineLimit(1)
                    }
                }.onDelete(perform: delete)
            }.onAppear(perform: loadData)
        }.navigationTitle("Journal")
    }
    
    func loadData() {
        guard let url = URL(string: "https://journal-23243.firebaseio.com/.json") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error Fetching Tasks \(error)")
                return
            }
            guard let data = data else {
                print("No data returned from data task")
                return
            }
            if let decodedResponse = try?JSONDecoder().decode([String: EntryRepresentation].self, from: data) {
                DispatchQueue.main.async {
                    for(_, entry) in decodedResponse {
                        if entry.id.isEmpty {
                            print("fetching failed")
                        } else {
                            journalEntries.append(entry)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func postEntry(entry: EntryRepresentation) {
        guard let encoded = try? JSONEncoder().encode(entry) else {
            print("Failed to encode entry")
            return
        }
        
        guard let url = URL(string: "https://journal-23243.firebaseio.com/.json") else {
                    print("Invalid URL")
                    return
                }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error Posting entry to server: \(error)")
                return
            }
            guard data != nil else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
        }.resume()
        
    }
    
    func delete(offsets: IndexSet) {
        guard let url = URL(string: "https://journal-23243.firebaseio.com/") else {
            print("Invalid URL")
            return
        }

        withAnimation {
            offsets.forEach { i in
                let deleteURL = url.appendingPathComponent(journalEntries[i].id).appendingPathExtension("json")

                var request = URLRequest(url: deleteURL)
                request.httpMethod = "DELETE"
                
                URLSession.shared.dataTask(with: request) { data, _ , error in
                    if let error = error {
                        print("Error deleting task in server: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        journalEntries.remove(atOffsets: offsets)
                    }
                }.resume()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
