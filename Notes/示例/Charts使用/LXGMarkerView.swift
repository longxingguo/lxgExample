//
//  LXGMarkerView.swift
//  Notes
//
//  Created by 龙兴国 on 2019/10/11.
//  Copyright © 2019 龙兴国. All rights reserved.
//

import UIKit
import Charts
class LXGMarkerView: MarkerView {
    let label     = UILabel()//(frame:CGRect(x:-25, y:-20, width:40, height:15))
    let imageView = UIImageView()//(frame: CGRect(x:10, y:-20, width:10, height:15))
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textColor     = UIColor.black
        label.font          = UIFont(name:"PingFangSC-Regular", size:10)
        self.addSubview(label)
        self.addSubview(imageView)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text        = String(format: "%.2f", entry.y)
        let attributes    = [NSAttributedString.Key.font:label.font]
        let rect:CGRect   = label.text!.boundingRect(with: CGSize(width: 0,height: 15),options: NSStringDrawingOptions.usesLineFragmentOrigin,attributes: attributes as [NSAttributedString.Key : Any],context:nil)
        let width:CGFloat = rect.size.width + 10;
       // self.frame        = CGRect(x:-width/2.0,y:-25,width:width,height: 15)
        label.frame       = CGRect(x:-width/2.0,y:-20,width: rect.size.width,height: 15)
        imageView.frame   = CGRect(x:rect.size.width - width/2.0,y:-20, width:10,height: 15)
        if (entry.data != nil) {
            let s:NSString  = "升";
            let j:NSString  = "降";
            let p:NSString  = "平";
            if (entry.data as! String).contains(s as String){
                imageView.image = UIImage(named: "RealTime_rose")
            }else if (entry.data as! String).contains(j as String){
                imageView.image = UIImage(named: "WaterPrediction_rose")
            }else if (entry.data as! String).contains(p as String){
                imageView.image = UIImage(named: "WaterPrediction_fall")
            }
//            let result      = entry.data as! String;
//            if up.isEqual(to: result) {
//                imageView.image = UIImage(named: result)
//            }
//            let data = entry.data as? Dictionary<String, String>
//                  let yStr = data?["yStr"]
//                  let dateStr = data?["date"]
//                  setLabel(String("\(dateStr!)  \(yStr!)"))
        }
    }
}
