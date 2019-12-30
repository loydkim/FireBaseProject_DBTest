//
//  Data.swift
//  FireBaseProject
//
//  Created by YOUNGSIC KIM on 2019-12-29.
//  Copyright © 2019 YOUNGSIC KIM. All rights reserved.
//

import Firebase
import FirebaseFirestore

let dbCollection = Firestore.firestore().collection("dbTest")
let firebaseData = FirebaseData()

class FirebaseData: ObservableObject {
    
    @Published var data = [ThreadDataType]()
    
    init() {
        readData()
    }
    
    // Reference link: https://firebase.google.com/docs/firestore/manage-data/add-data
    func createData(msg1:String) {
        // To create or overwrite a single document
        dbCollection.document().setData(["id" : dbCollection.document().documentID,"testText":msg1]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("create data success")
            }
        }
    }
    
    // Reference link : https://firebase.google.com/docs/firestore/query-data/listen
    func readData() {
        dbCollection.addSnapshotListener { (documentSnapshot, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("read data success")
            }
            
            documentSnapshot!.documentChanges.forEach { diff in
                // Real time create from server
                if (diff.type == .added) {
                    let msgData = ThreadDataType(id: diff.document.documentID, msg: diff.document.get("testText") as! String)
                    self.data.append(msgData)
                }
                
                // Real time modify from server
                if (diff.type == .modified) {
                    self.data = self.data.map { (eachData) -> ThreadDataType in
                        var data = eachData
                        if data.id == diff.document.documentID {
                            data.msg = diff.document.get("testText") as! String
                            return data
                        }else {
                            return eachData
                        }
                    }
                }
            }
        }
    }
    
    //Reference link: https://firebase.google.com/docs/firestore/manage-data/delete-data
    func deleteData(datas: FirebaseData ,index: IndexSet) {
        let id = datas.data[index.first!].id
        dbCollection.document(id).delete { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("delete data success")
            }
            datas.data.remove(atOffsets:index)
        }
    }
    
    // Reference link: https://firebase.google.com/docs/firestore/manage-data/add-data
    func updateData(id: String, txt: String) {
        dbCollection.document(id).updateData(["testText":txt]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("update data success")
            }
        }
    }
}
