//
//  BarChartRenderer.swift
//
//
//  Created by 杨虎 on 2018/10/30.
//  Copyright © 2018年  . All rights reserved.
//

import Foundation
import Charts

@objc public protocol YHBarChartRendererDelegate {
    /// Called when drawning a bar's shape.
    @objc optional func drawBarChartShape(context: CGContext, barRect: CGRect, index: Int) -> Void
    
    /// Called when drawning a highlight bar's shape.
    @objc optional func drawBarChartHighlightShape(context: CGContext, barRect: CGRect, index: Int) -> Void
}

class YHBarChartRenderer: BarChartRenderer {
    private class Buffer
    {
        var rects = [CGRect]()
    }
    
    @objc open weak var delegate: YHBarChartRendererDelegate?
    
    private var _buffers = [Buffer]()
    
    override func initBuffers() {
        if let barData = dataProvider?.barData
        {
            // Matche buffers count to dataset count
            if _buffers.count != barData.dataSetCount
            {
                while _buffers.count < barData.dataSetCount
                {
                    _buffers.append(Buffer())
                }
                while _buffers.count > barData.dataSetCount
                {
                    _buffers.removeLast()
                }
            }
            
            for i in stride(from: 0, to: barData.dataSetCount, by: 1)
            {
                let set = barData.dataSets[i] as! IBarChartDataSet
                let size = set.entryCount * (set.isStacked ? set.stackSize : 1)
                if _buffers[i].rects.count != size
                {
                    _buffers[i].rects = [CGRect](repeating: CGRect(), count: size)
                }
            }
        }
        else
        {
            _buffers.removeAll()
        }
    }
    
    private func prepareBuffer(dataSet: IBarChartDataSet, index: Int)
    {
        guard
            let dataProvider = dataProvider,
            let barData = dataProvider.barData
            else { return }
        
        let barWidthHalf = barData.barWidth / 2.0
        
        let buffer = _buffers[index]
        var bufferIndex = 0
        let containsStacks = dataSet.isStacked
        
        let isInverted = dataProvider.isInverted(axis: dataSet.axisDependency)
        let phaseY = animator.phaseY
        var barRect = CGRect()
        var x: Double
        var y: Double
        
        for i in stride(from: 0, to: min(Int(ceil(Double(dataSet.entryCount) * animator.phaseX)), dataSet.entryCount), by: 1)
        {
            guard let e = dataSet.entryForIndex(i) as? BarChartDataEntry else { continue }
            
            let vals = e.yValues
            
            x = e.x
            y = e.y
            
            if !containsStacks || vals == nil
            {
                let left = CGFloat(x - barWidthHalf)
                let right = CGFloat(x + barWidthHalf)
                var top = isInverted
                    ? (y <= 0.0 ? CGFloat(y) : 0)
                    : (y >= 0.0 ? CGFloat(y) : 0)
                var bottom = isInverted
                    ? (y >= 0.0 ? CGFloat(y) : 0)
                    : (y <= 0.0 ? CGFloat(y) : 0)
                
                // multiply the height of the rect with the phase
                if top > 0
                {
                    top *= CGFloat(phaseY)
                }
                else
                {
                    bottom *= CGFloat(phaseY)
                }
                
                barRect.origin.x = left
                barRect.size.width = right - left
                barRect.origin.y = top
                barRect.size.height = bottom - top
                buffer.rects[bufferIndex] = barRect
                bufferIndex += 1
            }
            else
            {
                var posY = 0.0
                var negY = -e.negativeSum
                var yStart = 0.0
                
                // fill the stack
                for k in 0 ..< vals!.count
                {
                    let value = vals![k]
                    
                    if value == 0.0 && (posY == 0.0 || negY == 0.0)
                    {
                        // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
                        y = value
                        yStart = y
                    }
                    else if value >= 0.0
                    {
                        y = posY
                        yStart = posY + value
                        posY = yStart
                    }
                    else
                    {
                        y = negY
                        yStart = negY + abs(value)
                        negY += abs(value)
                    }
                    
                    let left = CGFloat(x - barWidthHalf)
                    let right = CGFloat(x + barWidthHalf)
                    var top = isInverted
                        ? (y <= yStart ? CGFloat(y) : CGFloat(yStart))
                        : (y >= yStart ? CGFloat(y) : CGFloat(yStart))
                    var bottom = isInverted
                        ? (y >= yStart ? CGFloat(y) : CGFloat(yStart))
                        : (y <= yStart ? CGFloat(y) : CGFloat(yStart))
                    
                    // multiply the height of the rect with the phase
                    top *= CGFloat(phaseY)
                    bottom *= CGFloat(phaseY)
                    
                    barRect.origin.x = left
                    barRect.size.width = right - left
                    barRect.origin.y = top
                    barRect.size.height = bottom - top
                    
                    buffer.rects[bufferIndex] = barRect
                    bufferIndex += 1
                }
            }
        }
    }
    
    private var _barShadowRectBuffer: CGRect = CGRect()
    
    override func drawData(context: CGContext) {
        self.initBuffers()
        super.drawData(context: context)
    }
    
    override func drawValues(context: CGContext) {
        if isDrawingValuesAllowed(dataProvider: dataProvider)
        {
            guard
                let dataProvider = dataProvider,
                let barData = dataProvider.barData
                else { return }
            
            var dataSets = barData.dataSets
            
            let valueOffsetPlus: CGFloat = 4.5
            var posOffset: CGFloat
            var negOffset: CGFloat
            let drawValueAboveBar = dataProvider.isDrawValueAboveBarEnabled
            
            for dataSetIndex in 0 ..< barData.dataSetCount
            {
                guard let dataSet = dataSets[dataSetIndex] as? IBarChartDataSet else { continue }
                
                if !shouldDrawValues(forDataSet: dataSet)
                {
                    continue
                }
                
                let isInverted = dataProvider.isInverted(axis: dataSet.axisDependency)
                
                // calculate the correct offset depending on the draw position of the value
                let valueFont = dataSet.valueFont
                let valueTextHeight = valueFont.lineHeight
                posOffset = (drawValueAboveBar ? -(valueTextHeight + valueOffsetPlus) : valueOffsetPlus)
                negOffset = (drawValueAboveBar ? valueOffsetPlus : -(valueTextHeight + valueOffsetPlus))
                
                if isInverted
                {
                    posOffset = -posOffset - valueTextHeight
                    negOffset = -negOffset - valueTextHeight
                }
                
                let buffer = _buffers[dataSetIndex]
                
                guard let formatter = dataSet.valueFormatter else { continue }
                
                let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
                
                let phaseY = animator.phaseY
                
                let iconsOffset = dataSet.iconsOffset
                
                // if only single values are drawn (sum)
                if !dataSet.isStacked
                {
                    for j in 0 ..< Int(ceil(Double(dataSet.entryCount) * animator.phaseX))
                    {
                        guard let e = dataSet.entryForIndex(j) as? BarChartDataEntry else { continue }
                        
                        let rect = buffer.rects[j]
                        
                        let x = rect.origin.x + rect.size.width / 2.0
                        
                        if !viewPortHandler.isInBoundsRight(x)
                        {
                            break
                        }
                        
                        if !viewPortHandler.isInBoundsY(rect.origin.y)
                            || !viewPortHandler.isInBoundsLeft(x)
                        {
                            continue
                        }
                        
                        let val = e.y
                        
                        if dataSet.isDrawValuesEnabled
                        {
                            drawValue(
                                context: context,
                                value: formatter.stringForValue(
                                    val,
                                    entry: e,
                                    dataSetIndex: dataSetIndex,
                                    viewPortHandler: viewPortHandler),
                                xPos: x,
                                yPos: val >= 0.0
                                    ? (rect.origin.y + posOffset)
                                    : (rect.origin.y + rect.size.height + negOffset),
                                font: valueFont,
                                align: .center,
                                color: dataSet.valueTextColorAt(j))
                        }
                        
                        if let icon = e.icon, dataSet.isDrawIconsEnabled
                        {
                            var px = x
                            var py = val >= 0.0
                                ? (rect.origin.y + posOffset)
                                : (rect.origin.y + rect.size.height + negOffset)
                            
                            px += iconsOffset.x
                            py += iconsOffset.y
                            
                            ChartUtils.drawImage(
                                context: context,
                                image: icon,
                                x: px,
                                y: py,
                                size: icon.size)
                        }
                    }
                }
                else
                {
                    // if we have stacks
                    
                    var bufferIndex = 0
                    
                    for index in 0 ..< Int(ceil(Double(dataSet.entryCount) * animator.phaseX))
                    {
                        guard let e = dataSet.entryForIndex(index) as? BarChartDataEntry else { continue }
                        
                        let vals = e.yValues
                        
                        let rect = buffer.rects[bufferIndex]
                        
                        let x = rect.origin.x + rect.size.width / 2.0
                        
                        // we still draw stacked bars, but there is one non-stacked in between
                        if vals == nil
                        {
                            if !viewPortHandler.isInBoundsRight(x)
                            {
                                break
                            }
                            
                            if !viewPortHandler.isInBoundsY(rect.origin.y)
                                || !viewPortHandler.isInBoundsLeft(x)
                            {
                                continue
                            }
                            
                            if dataSet.isDrawValuesEnabled
                            {
                                drawValue(
                                    context: context,
                                    value: formatter.stringForValue(
                                        e.y,
                                        entry: e,
                                        dataSetIndex: dataSetIndex,
                                        viewPortHandler: viewPortHandler),
                                    xPos: x,
                                    yPos: rect.origin.y +
                                        (e.y >= 0 ? posOffset : negOffset),
                                    font: valueFont,
                                    align: .center,
                                    color: dataSet.valueTextColorAt(index))
                            }
                            
                            if let icon = e.icon, dataSet.isDrawIconsEnabled
                            {
                                var px = x
                                var py = rect.origin.y +
                                    (e.y >= 0 ? posOffset : negOffset)
                                
                                px += iconsOffset.x
                                py += iconsOffset.y
                                
                                ChartUtils.drawImage(
                                    context: context,
                                    image: icon,
                                    x: px,
                                    y: py,
                                    size: icon.size)
                            }
                        }
                        else
                        {
                            // draw stack values
                            
                            let vals = vals!
                            var transformed = [CGPoint]()
                            
                            var posY = 0.0
                            var negY = -e.negativeSum
                            
                            for k in 0 ..< vals.count
                            {
                                let value = vals[k]
                                var y: Double
                                
                                if value == 0.0 && (posY == 0.0 || negY == 0.0)
                                {
                                    // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
                                    y = value
                                }
                                else if value >= 0.0
                                {
                                    posY += value
                                    y = posY
                                }
                                else
                                {
                                    y = negY
                                    negY -= value
                                }
                                
                                transformed.append(CGPoint(x: 0.0, y: CGFloat(y * phaseY)))
                            }
                            
                            trans.pointValuesToPixel(&transformed)
                            
                            for k in 0 ..< transformed.count
                            {
                                let val = vals[k]
                                let drawBelow = (val == 0.0 && negY == 0.0 && posY > 0.0) || val < 0.0
                                let y = transformed[k].y + (drawBelow ? negOffset : posOffset)
                                
                                if !viewPortHandler.isInBoundsRight(x)
                                {
                                    break
                                }
                                
                                if !viewPortHandler.isInBoundsY(y) || !viewPortHandler.isInBoundsLeft(x)
                                {
                                    continue
                                }
                                
                                if dataSet.isDrawValuesEnabled
                                {
                                    drawValue(
                                        context: context,
                                        value: formatter.stringForValue(
                                            vals[k],
                                            entry: e,
                                            dataSetIndex: dataSetIndex,
                                            viewPortHandler: viewPortHandler),
                                        xPos: x,
                                        yPos: y,
                                        font: valueFont,
                                        align: .center,
                                        color: dataSet.valueTextColorAt(index))
                                }
                                
                                if let icon = e.icon, dataSet.isDrawIconsEnabled
                                {
                                    ChartUtils.drawImage(
                                        context: context,
                                        image: icon,
                                        x: x + iconsOffset.x,
                                        y: y + iconsOffset.y,
                                        size: icon.size)
                                }
                            }
                        }
                        
                        bufferIndex = vals == nil ? (bufferIndex + 1) : (bufferIndex + vals!.count)
                    }
                }
            }
        }
    }
    
    @objc open override func drawDataSet(context: CGContext, dataSet: IBarChartDataSet, index: Int)
    {
        guard let dataProvider = dataProvider else { return }
        
        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
        
        prepareBuffer(dataSet: dataSet, index: index)
        trans.rectValuesToPixel(&_buffers[index].rects)
        
        let borderWidth = dataSet.barBorderWidth
        let borderColor = dataSet.barBorderColor
        let drawBorder = borderWidth > 0.0
        
        context.saveGState()
        
        // draw the bar shadow before the values
        if dataProvider.isDrawBarShadowEnabled
        {
            guard let barData = dataProvider.barData else { return }
            
            let barWidth = barData.barWidth
            let barWidthHalf = barWidth / 2.0
            var x: Double = 0.0
            
            for i in stride(from: 0, to: min(Int(ceil(Double(dataSet.entryCount) * animator.phaseX)), dataSet.entryCount), by: 1)
            {
                guard let e = dataSet.entryForIndex(i) as? BarChartDataEntry else { continue }
                
                x = e.x
                
                _barShadowRectBuffer.origin.x = CGFloat(x - barWidthHalf)
                _barShadowRectBuffer.size.width = CGFloat(barWidth)
                
                trans.rectValueToPixel(&_barShadowRectBuffer)
                
                if !viewPortHandler.isInBoundsLeft(_barShadowRectBuffer.origin.x + _barShadowRectBuffer.size.width)
                {
                    continue
                }
                
                if !viewPortHandler.isInBoundsRight(_barShadowRectBuffer.origin.x)
                {
                    break
                }
                
                _barShadowRectBuffer.origin.y = viewPortHandler.contentTop
                _barShadowRectBuffer.size.height = viewPortHandler.contentHeight
                
                context.setFillColor(dataSet.barShadowColor.cgColor)
                context.fill(_barShadowRectBuffer)
            }
        }
        
        let buffer = _buffers[index]
        
        // draw the bar shadow before the values
        if dataProvider.isDrawBarShadowEnabled
        {
            for j in stride(from: 0, to: buffer.rects.count, by: 1)
            {
                let barRect = buffer.rects[j]
                
                if (!viewPortHandler.isInBoundsLeft(barRect.origin.x + barRect.size.width))
                {
                    continue
                }
                
                if (!viewPortHandler.isInBoundsRight(barRect.origin.x))
                {
                    break
                }
                
                context.setFillColor(dataSet.barShadowColor.cgColor)
                context.fill(barRect)
            }
        }
        
        let isSingleColor = dataSet.colors.count == 1
        
        if isSingleColor
        {
            context.setFillColor(dataSet.color(atIndex: 0).cgColor)
        }
        
        for j in stride(from: 0, to: buffer.rects.count, by: 1)
        {
            var barRect = buffer.rects[j]
            
            if (!viewPortHandler.isInBoundsLeft(barRect.origin.x + barRect.size.width))
            {
                continue
            }
            
            if (!viewPortHandler.isInBoundsRight(barRect.origin.x))
            {
                break
            }
            
            if !isSingleColor
            {
                // Set the color for the currently drawn value. If the index is out of bounds, reuse colors.
                context.setFillColor(dataSet.color(atIndex: j).cgColor)
            }
            
            if dataSet.isStacked == true
            {
                context.fill(barRect)
            }
            else if self.dataProvider is ChartViewBase
            {
                if self.delegate != nil, self.delegate!.drawBarChartShape != nil
                {
                    var extraTopOffset = CGFloat(0.0);
                    if let chartView = self.dataProvider as? ChartViewBase
                    {
                        extraTopOffset = chartView.extraTopOffset;
                    }
//                    barRect.origin.y += viewPortHandler.contentTop + extraTopOffset;
                    barRect.origin.y += extraTopOffset;
                    self.delegate!.drawBarChartShape!(context: context, barRect: barRect, index: j)
                }
                else
                {
                    context.fill(barRect)
                }
            }
            else
            {
                context.fill(barRect)
            }
            
            if drawBorder
            {
                context.setStrokeColor(borderColor.cgColor)
                context.setLineWidth(borderWidth)
                context.stroke(barRect)
            }
        }
        
        context.restoreGState()
    }
    
    override func drawHighlighted(context: CGContext, indices: [Highlight]) {
        guard
            let dataProvider = dataProvider,
            let barData = dataProvider.barData
            else { return }
        
        context.saveGState()
        
        var barRect = CGRect()
        
        for high in indices
        {
            guard
                let set = barData.getDataSetByIndex(high.dataSetIndex) as? IBarChartDataSet,
                set.isHighlightEnabled
                else { continue }
            
            if let e = set.entryForXValue(high.x, closestToY: high.y) as? BarChartDataEntry
            {
                if !isInBoundsX(entry: e, dataSet: set)
                {
                    continue
                }
                
                let trans = dataProvider.getTransformer(forAxis: set.axisDependency)
                
                context.setFillColor(set.highlightColor.cgColor)
                context.setAlpha(set.highlightAlpha)
                
                let isStack = high.stackIndex >= 0 && e.isStacked
                
                let y1: Double
                let y2: Double
                
                if isStack
                {
                    if dataProvider.isHighlightFullBarEnabled
                    {
                        y1 = e.positiveSum
                        y2 = -e.negativeSum
                    }
                    else
                    {
                        let range = e.ranges?[high.stackIndex]
                        
                        y1 = range?.from ?? 0.0
                        y2 = range?.to ?? 0.0
                    }
                }
                else
                {
                    y1 = e.y
                    y2 = 0.0
                }
                
                prepareBarHighlight(x: e.x, y1: y1, y2: y2, barWidthHalf: barData.barWidth / 2.0, trans: trans, rect: &barRect)
                
                setHighlightDrawPos(highlight: high, barRect: barRect)
                
                if isStack {
                    context.fill(barRect)
                }
                else if self.dataProvider is ChartViewBase
                {
                    if self.delegate != nil, self.delegate!.drawBarChartHighlightShape != nil
                    {
                        var extraTopOffset = CGFloat(0.0);
                        if let chartView = self.dataProvider as? ChartViewBase
                        {
                            extraTopOffset = chartView.extraTopOffset;
                        }
//                        barRect.origin.y += viewPortHandler.contentTop + extraTopOffset;
                        barRect.origin.y += extraTopOffset;
                        self.delegate!.drawBarChartHighlightShape!(context: context, barRect: barRect ,index:Int(high.x))
                    }
                    else
                    {
                        context.fill(barRect)
                    }
                }
                else
                {
                    context.fill(barRect)
                }
            }
        }
        
        context.restoreGState()
    }
    
    // Sets the drawing position of the highlight object based on the riven bar-rect.
    internal func setHighlightDrawPos(highlight high: Highlight, barRect: CGRect)
    {
        high.setDraw(x: barRect.midX, y: barRect.origin.y)
    }
    
    // Checks if the provided entry object is in bounds for drawing considering the current animation phase.
    internal func isInBoundsX(entry e: ChartDataEntry, dataSet: IBarLineScatterCandleBubbleChartDataSet) -> Bool
    {
        let entryIndex = dataSet.entryIndex(entry: e)
        return Double(entryIndex) < Double(dataSet.entryCount) * animator.phaseX
    }
    
    // - returns: `true` if the DataSet values should be drawn, `false` if not.
    internal func shouldDrawValues(forDataSet set: IChartDataSet) -> Bool
    {
        return set.isVisible && (set.isDrawValuesEnabled || set.isDrawIconsEnabled)
    }
}
