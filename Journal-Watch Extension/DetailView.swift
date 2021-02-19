//
//  DetailView.swift
//  Journal-Watch Extension
//
//  Created by Claudia Maciel on 1/18/21.
//  Copyright © 2021 thecoderpilot. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let entry: EntryRepresentation
    var body: some View {
        VStack {
            Text(entry.title)
                .font(.largeTitle)
            Text(entry.bodyText)
            Text(entry.mood)
                .foregroundColor(Color.green)
        }.navigationTitle(entry.title)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(entry: EntryRepresentation(id: "", title: "New Entry", bodyText: "This is some text", timestamp: Date(), mood: "happy"))
    }
}
