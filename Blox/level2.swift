//
//  level2.swift
//  Blox
//
//  Created by Jeffrey Li on 1/7/17.
//  Copyright © 2017 Jeffrey Li. All rights reserved.
//

import Foundation
import UIKit

class level2: UIViewController {
    
    var map = levels.Static.level2
    
    var firstSwipe = false
    
    var rows = 0
    var cols = 0
    
    let blockWidth = Int((UIImage(named: "block")?.size.width)!) / 2
    let marginBetweenBlock = 2
    
    var width = Int()
    var height = Int()
    
    var leftMargin = Int()
    var topMargin = Int()
    
    var currRowCol: [Int] = []
    
    var testBefore: [Int] = []
    
    var allImageViews : [UIImageView] = []
    
    @IBAction func restart(_ sender: Any) {
        map = levels.Static.level2
        for i in 0..<allImageViews.count {
            self.allImageViews[i].removeFromSuperview()
        }
        allImageViews = []
        drawBlocks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rows = map.count
        cols = map[0].count
        
        
        width = Int(view.frame.size.width)
        height = Int(view.frame.size.height)
        
        leftMargin = (width / 2) - ((cols * Int(blockWidth)) + (marginBetweenBlock * cols)) / 2
        topMargin = (height / 2) - ((rows * Int(blockWidth)) + (marginBetweenBlock * cols)) / 2 + 10
        
        drawBlocks()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                firstSwipe = true
                swipe(dir: 0)
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                firstSwipe = true
                swipe(dir: 1)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                firstSwipe = true
                swipe(dir: 2)
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
                firstSwipe = true
                swipe(dir: 3)
            default:
                break
            }
        }
    }
    
    func findCurrCol(dir: Int, currRow: Int, currCol: Int) -> Int {
        var currRow = currRow
        var currCol = currCol
        if (dir == 0) {
            currCol = 0
        }
        if (dir == 1) {
            currRow = 0
        }
        if (dir == 2) {
            currCol = cols
        }
        if (dir == 3){
            currRow = rows
        }
        for j in 0..<currRowCol.count {
            if (j % 2 == 0) {
                if (dir == 0 || dir == 2) {
                    if (currRowCol[j] == currRow) {
                        if (dir == 0) {
                            if (currRowCol[j + 1] > currCol) {
                                currCol = currRowCol[j + 1]
                            }
                        }
                        else {
                            if (currRowCol[j + 1] < currCol) {
                                currCol = currRowCol[j + 1]
                            }
                        }
                    }
                }
                else {
                    if (currRowCol[j + 1] == currCol) {
                        if (dir == 1) {
                            if (currRowCol[j] > currRow) {
                                currRow = currRowCol[j]
                            }
                        }
                        else {
                            if (currRowCol[j] < currRow) {
                                currRow = currRowCol[j]
                            }
                        }
                    }
                    
                }
            }
        }
        if (dir == 0 || dir == 2) {
            return currCol
        }
        else {
            return currRow
        }
    }
    
    func moveBlocks(dir: Int) {
        
        for i in 0..<currRowCol.count {
            if (i % 2 == 0) {
                map[currRowCol[i]][currRowCol[i + 1]] = 0
                if (dir == 0) {
                    currRowCol[i + 1] += 1
                } else if (dir == 1) {
                    currRowCol[i] += 1
                } else if (dir == 2) {
                    currRowCol[i + 1] -= 1
                } else if (dir == 3) {
                    currRowCol[i] -= 1
                }
            }
        }
        for i in 0..<currRowCol.count {
            if (i % 2 == 0) {
                map[currRowCol[i]][currRowCol[i + 1]] = 3
            }
        }
        
    }
    
    func findPlayerBlocks() -> [Int]{
        
        var maxRow = 0
        var maxCol = 0
        var minRow = rows
        var minCol = cols
        
        for row in 0..<rows {
            for col in 0..<cols {
                if (map[row][col] == 3) {
                    if (firstSwipe == true) {
                        currRowCol.append(row)
                        currRowCol.append(col)
                    }
                    
                    if (row >= maxRow) {
                        maxRow = row
                    }
                    if (row <= minRow) {
                        minRow = row
                    }
                    if (col >= maxCol) {
                        maxCol = col
                    }
                    if (col <= minCol) {
                        minCol = col
                    }
                    
                }
            }
        }
        if (firstSwipe == true) {
            testBefore = currRowCol
        }
        
        let colWidth = maxCol - minCol + 1
        let rowWidth = maxRow - minRow + 1
        
        return [rowWidth, colWidth, minRow, minCol]
    }
    
    func foundPiece(dir: Int, currRow: Int, currCol: Int) {
        
        var rowDir = 0
        var colDir = 0
        
        if (dir == 0) {
            colDir = currCol + 1
            rowDir = currRow
        }
        if (dir == 1) {
            rowDir = currRow + 1
            colDir = currCol
        }
        if (dir == 2) {
            colDir = currCol - 1
            rowDir = currRow
        }
        if (dir == 3) {
            rowDir = currRow - 1
            colDir = currCol
        }
        
        map[rowDir][colDir] = 3
        currRowCol.append(rowDir)
        currRowCol.append(colDir)
        let tag = makeTag(beforemodRow: rowDir, tag: colDir)
        for i in 0..<allImageViews.count {
            if (allImageViews[i].tag == tag) {
                self.allImageViews[i].removeFromSuperview()
                
                let xVal = (colDir * blockWidth) + (marginBetweenBlock * colDir) + leftMargin
                let yVal = ((rowDir) * blockWidth) + (marginBetweenBlock * (rowDir)) + topMargin
                
                var imageView: UIImageView!
                let green = UIImage(named: "green")
                
                imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
                imageView.image = green
                
                imageView.tag = 3
                
                view.addSubview(imageView)
                allImageViews.append(imageView)
            }
            
        }
    }
    
    var distance = 0
    
    func swipe(dir: Int) {
        
        let maxMin = findPlayerBlocks()
        
        let rowWidth = maxMin[0]
        let colWidth = maxMin[1]
        let minRow = maxMin[2]
        let minCol = maxMin[3]
        
        //print(rowWidth, colWidth, minRow, minCol)
        
        if (dir == 0 || dir == 2) {
            var found = false
            firstSwipe = false
            var currentCols: [Int] = []
            var currentRows: [Int] = []
            
            
            for i in 0..<rowWidth {
                var currCol = 0
                let currRow = minRow + i
                currCol = findCurrCol(dir: dir, currRow: currRow, currCol: currCol)
                currentCols.append(currCol)
                currentRows.append(currRow)
                
                var colDir = 0
                
                if (dir == 0) {
                    colDir = currCol + 1
                }
                else {
                    colDir = currCol - 1
                }
                
                if (map[currRow][colDir] == 1) {
                    found = true
                }
            }
            print(currentRows)
            print(currentCols)
            
            print(found)
            
            if (found == false) {
                var shouldMove = false
                var bools: [Bool] = []
                
                for i in 0..<rowWidth {
                    let currCol = currentCols[i]
                    let currRow = currentRows[i]
                    
                    var colDir = 0
                    
                    if (dir == 0) {
                        colDir = currCol + 1
                    }
                    else {
                        colDir = currCol - 1
                    }
                    
                    if (map[currRow][colDir] == 4) {
                        map[currRow][colDir] = 3
                        shouldMove = true
                        bools.append(true)
                    }
                    else {
                        bools.append(false)
                    }
                }
                if (shouldMove == false) {
                    moveBlocks(dir: dir)
                    distance += 1
                    swipe(dir: dir)
                    return
                }
                else {
                    for i in 0..<rowWidth {
                        let currCol = currentCols[i]
                        let currRow = currentRows[i]
                        
                        if (bools[i] == true) {
                            foundPiece(dir: dir, currRow: currRow, currCol: currCol)
                        }
                    }
                    swipe(dir: dir)
                    return
                }
            }
            else {
                for i in 0..<rowWidth {
                    let currCol = currentCols[i]
                    let currRow = currentRows[i]
                    
                    var colDir = 0
                    
                    if (dir == 0) {
                        colDir = currCol + 1
                    }
                    else {
                        colDir = currCol - 1
                    }
                    
                    if (map[currRow][colDir] == 4) {
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol)
                    }
                }
            }
            
        } else if (dir == 1 || dir == 3) {
            var found = false
            firstSwipe = false
            var currentCols: [Int] = []
            var currentRows: [Int] = []
            
            for i in 0..<colWidth {
                let currCol = minCol + i
                var currRow = 0
                currRow = findCurrCol(dir: dir, currRow: currRow, currCol: currCol)
                currentCols.append(currCol)
                currentRows.append(currRow)
                
                print(currRow)
                
                if (dir == 1) {
                    if (map[currRow + 1][currCol] == 1) {
                        found = true
                    }
                }
                else {
                    if (map[currRow - 1][currCol] == 1) {
                        found = true
                    }
                }
            }
            
            
            if (found == false) {
                var shouldMove = false
                var bools: [Bool] = []
                
                for i in 0..<colWidth {
                    let currCol = currentCols[i]
                    let currRow = currentRows[i]
                    
                    var rowDir = 0
                    
                    if (dir == 1) {
                        rowDir = currRow + 1
                    }
                    else {
                        rowDir = currRow - 1
                    }
                    
                    if (map[rowDir][currCol] == 4) {
                        map[rowDir][currCol] = 3
                        shouldMove = true
                        bools.append(true)
                    }
                    else {
                        bools.append(false)
                    }
                }
                if (shouldMove == false) {
                    moveBlocks(dir: dir)
                    distance += 1
                    swipe(dir: dir)
                    return
                }
                else {
                    for i in 0..<colWidth {
                        let currCol = currentCols[i]
                        let currRow = currentRows[i]
                        
                        if (bools[i] == true) {
                            foundPiece(dir: dir, currRow: currRow, currCol: currCol)
                        }
                    }
                    swipe(dir: dir)
                    return
                }
            }
            else {
                for i in 0..<colWidth {
                    let currCol = currentCols[i]
                    let currRow = currentRows[i]
                    
                    var rowDir = 0
                    
                    if (dir == 1) {
                        rowDir = currRow + 1
                    }
                    else {
                        rowDir = currRow - 1
                    }
                    
                    if (map[rowDir][currCol] == 4) {
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol)
                    }
                }
            }
        }
        
        if (testBefore != currRowCol){
            shake()
        }
        
        animate(rowCols: currRowCol, dist: distance)
        distance = 0
        
        //print(currRowCol)
        
        currRowCol = []
        testBefore = []
    }
    
    func shake() {
        
        let random = Int(arc4random_uniform(6))
        let random1 = Int(arc4random_uniform(6))
        
        for i in 0..<allImageViews.count {
            
            let xVal = self.allImageViews[i].center.x
            let yVal = self.allImageViews[i].center.y
            
            UIImageView.animate(withDuration: 0.05, delay: 0, options: UIViewAnimationOptions.curveLinear , animations: {
                
                self.allImageViews[i].center = CGPoint(x: Double(xVal) + Double(random), y: Double(yVal) + Double(random1))
                
            }, completion: nil)
            
            UIImageView.animate(withDuration: 0.05, delay: 0.05, options: UIViewAnimationOptions.curveLinear , animations: {
                
                self.allImageViews[i].center = CGPoint(x: Double(xVal) - Double(random1), y: Double(yVal) - Double(random))
                
            }, completion: nil)
            
            UIImageView.animate(withDuration: 0.05, delay: 0.1, options: UIViewAnimationOptions.curveLinear , animations: {
                
                self.allImageViews[i].center = CGPoint(x: Double(xVal), y: Double(yVal))
                
            }, completion: nil)
            
        }
    }
    
    func animate(rowCols: [Int], dist: Int) {
        
        var counter = 0
        
        for i in 0..<allImageViews.count {
            if (allImageViews[i].tag == 3) {
                
                let row = rowCols[counter]
                let col = rowCols[counter + 1]
                counter += 2
                
                let xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
                let yVal = (row * blockWidth) + (marginBetweenBlock * row) + topMargin
                
                //print(xVal, yVal)
                //print(self.allImageViews[i].center.x)
                
                
                UIImageView.animate(withDuration: 0.02 * Double(dist), delay: 0, options: UIViewAnimationOptions.curveLinear , animations: {
                    
                    self.allImageViews[i].center = CGPoint(x: Double(xVal) + 12.5, y: Double(yVal) + 12.5)
                    
                }, completion: nil)
                
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func drawBlocks() {
        
        var imageView: UIImageView!
        let red = UIImage(named: "block")
        let blue = UIImage(named: "blockk")
        let yellow = UIImage(named: "yello")
        let green = UIImage(named: "green")
        let darkgreen = UIImage(named: "darkgreen")
        
        for row in 0..<rows {
            for col in 0..<cols {
                let xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
                let yVal = (row * blockWidth) + (marginBetweenBlock * row) + topMargin
                
                if (map[row][col] == 0 || map[row][col] == 3 || map[row][col] == 4){
                    imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
                    imageView.image = red
                    
                    view.addSubview(imageView)
                    allImageViews.append(imageView)
                }
                else if (map[row][col] == 1){
                    imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
                    imageView.image = blue
                    
                    view.addSubview(imageView)
                    allImageViews.append(imageView)
                }
                else if (map[row][col] == 2){
                    let tag = 2
                    addSquare(imageView: imageView, color: yellow!, xVal: xVal, yVal: yVal, tag: tag)
                }
            }
        }
        for row in 0..<rows {
            for col in 0..<cols {
                
                let xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
                let yVal = (row * blockWidth) + (marginBetweenBlock * row) + topMargin
                if (map[row][col] == 3){
                    
                    let tag = 3
                    addSquare(imageView: imageView, color: green!, xVal: xVal, yVal: yVal, tag: tag)
                }
                else if (map[row][col] == 4){
                    
                    let tag = makeTag(beforemodRow: row, tag: col)
                    addSquare(imageView: imageView, color: darkgreen!, xVal: xVal, yVal: yVal, tag: tag)
                }
            }
        }
    }
    
    func addSquare(imageView: UIImageView, color: UIImage, xVal: Int, yVal: Int, tag: Int) {
        var imageView = imageView
        imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
        imageView.image = color
        imageView.tag = tag
        
        view.addSubview(imageView)
        allImageViews.append(imageView)
    }
    
    func makeTag(beforemodRow: Int, tag: Int) -> Int{
        
        var beforemodRow = beforemodRow
        var tag = tag
        
        var modRow = 0
        
        while (Double(beforemodRow) > 0.99) {
            let rem = beforemodRow % 10
            modRow *= 10
            modRow += rem
            beforemodRow -= rem
            beforemodRow /= 10
        }
        
        while(Double(modRow) > 0.99) {
            let mod = modRow % 10
            tag *= 10
            tag += mod
            modRow -= mod
            modRow /= 10
        }
        
        return tag
        
    }
    
}

/*
 map[currRow + 1][currCol] = 2
 map[ogRow + 1][currCol] = 3
 for i in 0..<allImageViews.count {
 
 let tag = makeTag(beforemodRow: currRow + 1, tag: currCol)
 if (allImageViews[i].tag == tag) {
 self.allImageViews[i].removeFromSuperview()
 
 let xVal = (currCol * blockWidth) + (marginBetweenBlock * currCol) + leftMargin
 let yVal = ((currRow + 1) * blockWidth) + (marginBetweenBlock * (currRow + 1)) + topMargin
 
 imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
 imageView.image = green
 
 imageView.tag = 3
 
 view.addSubview(imageView)
 allImageViews.append(imageView)
 }
 
 } */

