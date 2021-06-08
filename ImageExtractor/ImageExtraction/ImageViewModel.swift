//
//  ImageViewModel.swift
//  ImageExtractor
//
//  Created by Vishnu on 07/06/21.
//

import Foundation

class ImageViewModel: NSObject {
    var synonymVal: [String] = []
    var antonymVal: [String] = []
    var thesaurusVal: [String]?
    var updateValues: ((String) -> ())?
    var dictWordInfo: String?


    func getSynonym(word: String) {
        let urlString = String(format: Appurl.get_synonym, word)
        ApplicationDataServiceManager.shared.getWordVal(urlString: urlString, dictKey: "synonyms") { (synonym) in
            if synonym != nil {
                self.synonymVal = synonym ?? []
            }
            self.getAntonym(word: word)
        }
    }

    func getAntonym(word: String) {
        let urlString = String(format: Appurl.get_antonym, word)
        ApplicationDataServiceManager.shared.getWordVal(urlString: urlString, dictKey: "antonyms") { (antonym) in
            if antonym != nil {
                self.antonymVal = antonym ?? []
            }
            DispatchQueue.main.async {
                self.formWordDict()
            }
        }
    }
    //    func getThesaurus(word: String) {
    //        let urlString = String(format: Appurl.get_thesaurus, word)
    //        ApplicationDataServiceManager.shared.getWordVal(urlString: urlString) { (thesaurus) in
    //            if thesaurus != nil {
    //                self.thesaurusVal = thesaurus
    //            }
    //            self.formWordDict()
    //        }
    //    }

    //Method to format string to show it in textview
    func formWordDict() {
        var txtVwVal = ""
        if self.synonymVal.count > 0 {
            //dictWordInfo = ["Synonym": synonymVal as Any]
            txtVwVal += "Synonym: "
            for eachVal in synonymVal {
                txtVwVal += eachVal + "\n"
            }
            if self.antonymVal.count > 0 {
                //  dictWordInfo = ["Antonym": antonymVal as Any]
                txtVwVal += "Antonym: "
                for eachVal in antonymVal {
                    txtVwVal += eachVal + "\n"
                }
            }

            dictWordInfo = txtVwVal
            self.updateValues?(dictWordInfo!)
        }
    }
}
