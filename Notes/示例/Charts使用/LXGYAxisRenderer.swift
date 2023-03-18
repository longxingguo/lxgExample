//
//  LXGYAxisRenderer.swift
//  Notes
//
//  Created by 龙兴国 on 2019/10/25.
//  Copyright © 2019 龙兴国. All rights reserved.
//

import Charts
class LXGYAxisRenderer: YAxisRenderer {
    @objc open var drawImagesEnabled = false
    @objc open var images            = [String]()
    @objc open var isDrawImagesEnabled: Bool {return drawImagesEnabled}
    internal func drawYLabels(
        context: CGContext,
        fixedPosition: CGFloat,
        positions: [CGPoint],
        offset: CGFloat,
        textAlign: NSTextAlignment)
    {
        guard
            let yAxis = self.axis as? YAxis
            else { return }
        
        let labelFont      = yAxis.labelFont
        let labelTextColor = yAxis.labelTextColor
        let from           = yAxis.isDrawBottomYLabelEntryEnabled ? 0 : 1
        let to             = yAxis.isDrawTopYLabelEntryEnabled ? yAxis.entryCount : (yAxis.entryCount - 1)
        for i in stride(from: from, to: to, by: 1){
            let text = yAxis.getFormattedLabel(i)
            //画文字
            ChartUtils.drawText(
                context: context,
                text: text,
                point: CGPoint(x: fixedPosition, y: positions[i].y + offset),
                align: textAlign,
                attributes: [.font: labelFont, .foregroundColor: labelTextColor]
            )
            //画图片
            if isDrawImagesEnabled {
                let rect:CGRect     = text.boundingRect(with: CGSize(width: 0,height:labelFont.lineHeight),options: .usesLineFragmentOrigin,attributes:[.font: labelFont, .foregroundColor: labelTextColor],context:nil)
                let imageName       = self.images[i] as NSString
                let image:UIImage   = UIImage(named:imageName as String)!
                var point           = CGPoint(x: fixedPosition, y: positions[i].y + offset)
                if textAlign == .center{
                    point.x -= rect.size.width / 2.0
                }else if textAlign == .right{
                    point.x -= rect.size.width
                }
                //point.x + rect.size.width / 2.0 + image.size.width/2.0
                ChartUtils.drawImage(context: context,
                                     image:image,
                                     x: fixedPosition - image.size.width/2.0,
                                     y: point.y + image.size.height/2.0,
                                     size:image.size)
            }
        }
    }
}
