//
//  ViewController.swift
//  ASyncTesting
//
//  Created by Steve Wainwright on 30/03/2024.
//

import UIKit
import SwiftUI
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var theContainer1: UIView?
    @IBOutlet weak var theContainer2: UIView?
    @IBOutlet weak var theContainer3: UIView?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let childView1 = UIHostingController(rootView: ASyncMessagesView())
        addChild(childView1)
        childView1.view.frame = theContainer1?.bounds ?? CGRectZero
        theContainer1?.addSubview(childView1.view)
        childView1.didMove(toParent: self)
        
        let childView2 = UIHostingController(rootView: CountriesView())
        addChild(childView2)
        childView2.view.frame = theContainer2?.bounds ?? CGRectZero
        theContainer2?.addSubview(childView2.view)
        childView2.didMove(toParent: self)
        
        let childView3 = UIHostingController(rootView: ChartExampleView())
        addChild(childView3)
        childView3.view.frame = theContainer3?.bounds ?? CGRectZero
        theContainer3?.addSubview(childView3.view)
        childView3.didMove(toParent: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}

extension CGPoint {
    static func randPoint(xRange: ClosedRange<CGFloat>, yRange: ClosedRange<CGFloat>) -> Self {
        let x = CGFloat.random(in: xRange)
        let y = CGFloat.random(in: yRange)
        return .init(x: x, y: y)
    }
}

extension String {
    var isContainsNumericsNegativeOrPoint : Bool {
        var allowed = CharacterSet.decimalDigits
        allowed = allowed.union(CharacterSet(charactersIn: ".-"))
        return self.rangeOfCharacter(from: allowed) != nil
    }
}
