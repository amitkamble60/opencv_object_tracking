//
//  TrackedObject.swift
//  openCvApp
//
//  Created by Apple on 01/08/24.
//

import Foundation


class TrackedObject {
    private let id : Int
    private var boundingBox : CGRect
    private let score: Double
    private var lable : String
    private let order : Int = 0
    private let isPrimary : Bool = true
    
    init(id : Int, boundingBox:CGRect, score: Double, lable: String){
        self.id = id
        self.boundingBox = boundingBox
        self.score = score
        self.lable = lable
    }
    
    func getLable() -> String {
        return self.lable;
    }
    
    func setLable(lable: String) {
        self.lable = lable;
    }
    
    func getBoundingBox() -> CGRect {
        return self.boundingBox;
    }
    
    func setBoundingBox(rect: CGRect) {
        self.boundingBox = rect;
    }
    
    
    
    
}
