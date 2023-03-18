//
//  LXGXAxisRenderer.swift
//  ChartsUnderstandAndUsage
//
//  Created by 龙兴国 on 2019/10/24.
//  Copyright © 2019 张海峰. All rights reserved.
//

import Charts
class LXGXAxisRenderer: XAxisRenderer {
    @objc open var selectedEntryX:NSNumber?
    @objc open var selectedXLabelTextColor:UIColor?
    @objc open var selectedXLabelFont:UIFont?
    @objc open var drawImagesEnabled = false
    @objc open var images            = [String]()
    @objc open var isDrawImagesEnabled: Bool {return drawImagesEnabled}
    @objc open var drawLablesEnabled = false
    @objc open var labelTextColors   = [UIColor]()
    @objc open var isDrawLablesEnabled: Bool {return drawLablesEnabled}
    @objc open override func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint){
        guard
            let xAxis = self.axis as? XAxis,
            let transformer = self.transformer
            else {return}
        let paraStyle       = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paraStyle.alignment = .center
        var labelAttrs: [NSAttributedString.Key : Any] = [
            .font: xAxis.labelFont,
            .foregroundColor: xAxis.labelTextColor,
            .paragraphStyle: paraStyle
        ]
        let centeringEnabled   = xAxis.isCenterAxisLabelsEnabled
        let valueToPixelMatrix = transformer.valueToPixelMatrix
        var position           = CGPoint(x: 0.0, y: 0.0)
        var labelMaxSize       = CGSize()
        if xAxis.isWordWrapEnabled{
            labelMaxSize.width = xAxis.wordWrapWidthPercent * valueToPixelMatrix.a
        }
        let entries = xAxis.entries
        for i in stride(from: 0, to: entries.count, by: 1){
            if centeringEnabled{
                position.x = CGFloat(xAxis.centeredEntries[i])
            }else{
                position.x = CGFloat(entries[i])
            }
            position.y     = 0.0
            position       = position.applying(valueToPixelMatrix)
            if viewPortHandler.isInBoundsX(position.x){
                let label   = xAxis.valueFormatter?.stringForValue(xAxis.entries[i], axis: xAxis) ?? ""
                //let labelns = label as NSString
                let array : Array = label.components(separatedBy: ",")//自组数组
                let labelns = array.first! as NSString//2行
                let labelns1 = array.last! as NSString//2行
                if xAxis.isAvoidFirstLastClippingEnabled{
                    // avoid clipping of the last
                    if i == xAxis.entryCount - 1 && xAxis.entryCount > 1{
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        
                        if  width > viewPortHandler.offsetRight * 2.0
                            && position.x + width > viewPortHandler.chartWidth{
                            position.x -= width / 2.0
                        }
                    }else if i == 0{ // avoid clipping of the first
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        position.x += width / 2.0
                    }
                }
                print(xAxis.entries);
                if self.selectedXLabelTextColor != nil,self.selectedEntryX?.doubleValue == xAxis.entries[i]{
                    
                    labelAttrs[NSAttributedString.Key.foregroundColor] = self.selectedXLabelTextColor
                }else{
                    labelAttrs[NSAttributedString.Key.foregroundColor] = axis?.labelTextColor
                }
                if self.selectedXLabelFont != nil,self.selectedEntryX?.doubleValue == xAxis.entries[i]{
                    labelAttrs[NSAttributedString.Key.font] = self.selectedXLabelFont
                }else{
                    labelAttrs[NSAttributedString.Key.font] = axis?.labelFont
                }
                if isDrawLablesEnabled{
                    print(i);
                    let m = Int(xAxis.entries[i]);
                    labelAttrs[NSAttributedString.Key.foregroundColor] = self.labelTextColors[m]
                }
                //画文字
                drawLabel(context: context,
                          formattedLabel: labelns as String,
                          x: position.x,
                          y: pos,//如果多行文字 可在这里加上 行数*行高
                          attributes: labelAttrs,
                          constrainedToSize: labelMaxSize,
                          anchor: anchor,
                          angleRadians: 0)
                //画文字
                if(labelns1.length > 0 && !(labelns1.isEqual(to: labelns as String))){
                    let rect:CGRect = labelns.boundingRect(with: CGSize(width: 0,height:xAxis.labelFont.lineHeight),options: .usesLineFragmentOrigin,attributes:labelAttrs,context:nil)
                    drawLabel(context: context,
                              formattedLabel: labelns1 as String,
                              x: position.x,
                              y: pos + rect.size.height,
                        attributes: labelAttrs,
                        constrainedToSize: labelMaxSize,
                        anchor: anchor,
                        angleRadians: 0)
                }
                //画图片
                if isDrawImagesEnabled {
//                    print(self.images)
                    let rect:CGRect     = labelns.boundingRect(with: CGSize(width: 0,height:xAxis.labelFont.lineHeight),options: .usesLineFragmentOrigin,attributes:labelAttrs,context:nil)
                    let imageName       = self.images[i] as NSString
                    let image:UIImage   = UIImage(named:imageName as String)!
                    ChartUtils.drawImage(context: context,
                                         image:image,
                                         x: position.x  + rect.size.width/2.0 + image.size.width/2.0,
                                         y: pos + image.size.height/2.0,
                                         size:image.size)
                }
            }
        }
    }
}
/**
 参考安卓
class CustomXAxisRenderer(viewPortHandler: ViewPortHandler, xAxis: XAxis, trans: Transformer) : XAxisRenderer(viewPortHandler, xAxis, trans) {
         override fun drawLabel(c: Canvas, formattedLabel: String, x: Float, y: Float, anchor: MPPointF, angleDegrees: Float) {
             val lines = formattedLabel.split("\n")
             for (i in lines.indices) {
                 val vOffset = i * mAxisLabelPaint.textSize
                 Utils.drawXAxisValue(c, lines[i], x, y + vOffset, mAxisLabelPaint, anchor, angleDegrees)
             }
         }
     }
*/
