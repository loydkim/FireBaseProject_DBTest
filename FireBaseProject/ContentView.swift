//
//  ContentView.swift
//  FireBaseProject
//
//  Created by YOUNGSIC KIM on 2019-12-22.
//  Copyright © 2019 YOUNGSIC KIM. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @State private var textValue = ""
    @State private var updateRowID = ""
    @State private var updateRowValue = ""
    @State private var isUpdate = false
    @ObservedObject private var datas = firebaseData
    
    var body: some View {
        VStack {
            List {
                ForEach(datas.data){ data in
                    HStack {
                        Button(action: {
                            self.isUpdate = true
                            self.updateRowID = data.id
                            self.updateRowValue = data.msg
                        }) {
                            Text(data.msg)
                        }
                    }
                }.onDelete { (index) in
                    firebaseData.deleteData(datas: self.datas, index: index)
                }
            }
            self.isUpdate ? Text("The value ( \(updateRowValue) ) will chage") : nil
            HStack {
                Spacer()
                TextField("Add text please", text: $textValue).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    self.doItButton()
                }) {
                    Text("Do It")
                }
                Spacer()
            }
        }
    }
    
    func doItButton() {
        self.isUpdate ? firebaseData.updateData(id: self.updateRowID, txt: self.textValue) : firebaseData.createData(msg1: self.textValue)
        self.isUpdate = false
        self.textValue = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
