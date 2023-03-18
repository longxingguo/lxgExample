//
//  XYMarkerView.swift
//  Notes
//
//  Created by 龙兴国 on 2019/10/11.
//  Copyright © 2019 龙兴国. All rights reserved.
//

import UIKit
import Charts
class XYMarkerView: BalloonMarker {
    @objc open var xAxisValueFormatter: IAxisValueFormatter?
    fileprivate var xStr  = String()
    fileprivate var yStr  = String()
    fileprivate var data1 = [Double]()
    fileprivate var data2 = [Double]()
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,xName:String,yName:String,data1:Array<Double>,data2:Array<Double>){
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xStr  = xName
        self.yStr  = yName
        self.data1 = data1
        self.data2 = data2
    }
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight){
        let index   = Int(entry.x)
        let value1  = self.data1[index]
        let value2  = self.data2[index]
        var string1 = ""
        var string2 = ""
        let number1 = NSNumber.init(value: value1)
        let number2 = NSNumber.init(value: value2)
        if self.xStr == "销量"{
            let format = NumberFormatter()
            format.positiveFormat = "###,###"
            string1    = format.string(from: number1)!
            string2    = format.string(from: number2)!
            
        }else{
            let format = NumberFormatter()
            format.positiveFormat = "###,##0.00"
            string1    = format.string(from: number1)!
            string2    = format.string(from: number2)!
        }
        setLabel(self.xStr + ":" + string1 + "\n" + self.yStr + string2)
    }
}
