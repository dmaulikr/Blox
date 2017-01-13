//
//  level1.swift
//  Blox
//
//  Created by Jeffrey Li on 1/4/17.
//  Copyright © 2017 Jeffrey Li. All rights reserved.
//

import Foundation
import UIKit

class level1: UIViewController {
    var map = levels.Static.level1
    
    var refMap: [[Int]] = []
    var mapNumber = 1
    
    var restID = String()
    
    let slideAnimator = slideAnimate()
    
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
    
    var minRowsCols: [Int] = []
    
    var allImageViews : [UIImageView] = []
    
    var movess = 0
    
    var won = false
    
    var checkWinRowCol: [Int] = []
    
    var together = [Int:[Int]]()
    
    var hitMine = false
    
    @IBOutlet weak var level1: UILabel!
    @IBOutlet weak var moves: UILabel!
    @IBOutlet weak var nextLevel: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var levelsBTN: UIButton!
    @IBOutlet weak var wellDone: UILabel!
    
    @IBAction func restart(_ sender: Any) {
        map = refMap
        for i in 0..<allImageViews.count {
            self.allImageViews[i].removeFromSuperview()
        }
        allImageViews = []
        together = [Int:[Int]]()
        drawBlocks()
        movess = 0
        self.moves.text = "Moves: \(movess)"
    }
    
    func animateLevel() {
        self.level1.alpha = 1
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 7, options: UIViewAnimationOptions.curveLinear , animations: ( {
            self.level1.center.y = 60
        }), completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveLinear , animations: ( {
            self.restartButton.center.y = 600
        }), completion: nil)
        
        UIView.animate(withDuration: 1.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveLinear , animations: ( {
            self.levelsBTN.center.y = 595
        }), completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restID = self.restorationIdentifier!
        
        if (self.restorationIdentifier! == "level2id") {
            map = levels.Static.level2
            restID = self.restorationIdentifier!
            mapNumber = 2
        }
        else if (self.restorationIdentifier! == "level3id") {
            map = levels.Static.level3
            restID = self.restorationIdentifier!
            mapNumber = 3
        }
        else if (self.restorationIdentifier! == "level4id") {
            map = levels.Static.level4
            restID = self.restorationIdentifier!
            mapNumber = 4
        }
        else if (self.restorationIdentifier! == "level5id") {
            map = levels.Static.level5
            restID = self.restorationIdentifier!
            mapNumber = 5
        }
        else if (self.restorationIdentifier! == "level6id") {
            map = levels.Static.level6
            restID = self.restorationIdentifier!
            mapNumber = 6
        }
        else if (self.restorationIdentifier! == "level7id") {
            map = levels.Static.level7
            restID = self.restorationIdentifier!
            mapNumber = 7
        }
        else if (self.restorationIdentifier! == "level8id") {
            map = levels.Static.level8
            restID = self.restorationIdentifier!
            mapNumber = 8
        }
        else if (self.restorationIdentifier! == "level9id") {
            map = levels.Static.level9
            restID = self.restorationIdentifier!
            mapNumber = 9
        }
        else if (self.restorationIdentifier! == "level10id") {
            map = levels.Static.level10
            restID = self.restorationIdentifier!
            mapNumber = 10
        }
        
        refMap = map
        
        self.restartButton.center.y = view.frame.height + 50
        self.levelsBTN.center.y = view.frame.height + 50
        self.wellDone.center.x = -150
        self.level1.center.y = -100
        self.level1.alpha = 0
        self.wellDone.alpha = 0
        
        nextLevel.center.x = view.frame.width + 50
        
        nextLevel.alpha = 0.2
        nextLevel.isEnabled = false
        
        rows = map.count
        cols = map[0].count
        
        for row in 0..<rows {
            for col in 0..<cols {
                if (map[row][col] == 2) {
                    checkWinRowCol.append(row)
                    checkWinRowCol.append(col)
                }
            }
        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        animateLevel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        destination.transitioningDelegate = slideAnimator
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if (won == false) {
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                movess += 1
                self.moves.text = "Moves: \(movess)"
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
    }
    
    
    func checkLose() -> Bool {
        var num = 0
        for row in 0..<rows {
            for col in 0..<cols {
                if (map[row][col] == 3) {
                    num += 1
                }
            }
        }
        if (num == 0) {
            map = refMap
            for i in 0..<allImageViews.count {
                self.allImageViews[i].removeFromSuperview()
            }
            allImageViews = []
            together = [Int:[Int]]()
            drawBlocks()
            movess = 0
            self.moves.text = "Moves: \(movess)"
            currRowCol = []
            testBefore = []
            minRowsCols = []
            return true
        }
        return false
    }
    
    func findCurrCol(dir: Int, currRow: Int, currCol: Int, array: [Int]) -> Int {
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
        for j in 0..<array.count {
            if (j % 2 == 0) {
                if (dir == 0 || dir == 2) {
                    if (array[j] == currRow) {
                        if (dir == 0) {
                            if (array[j + 1] > currCol) {
                                currCol = array[j + 1]
                            }
                        }
                        else {
                            if (array[j + 1] < currCol) {
                                currCol = array[j + 1]
                            }
                        }
                    }
                }
                else {
                    if (array[j + 1] == currCol) {
                        if (dir == 1) {
                            if (array[j] > currRow) {
                                currRow = array[j]
                            }
                        }
                        else {
                            if (array[j] < currRow) {
                                currRow = array[j]
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
            minRowsCols = [minRow, minCol, maxRow, maxCol]
        }
        
        let colWidth = maxCol - minCol + 1
        let rowWidth = maxRow - minRow + 1
        
        return [rowWidth, colWidth, minRow, minCol]
    }
    
    func changePieceColor(colDir: Int, rowDir: Int, tag: Int) {
        for i in 0..<allImageViews.count {
            if (allImageViews[i].tag == tag) {
                print(tag)
                self.allImageViews[i].removeFromSuperview()
                allImageViews.remove(at: i) 
                
                let xVal = (colDir * blockWidth) + (marginBetweenBlock * colDir) + leftMargin
                let yVal = ((rowDir) * blockWidth) + (marginBetweenBlock * (rowDir)) + topMargin
                
                var imageView: UIImageView!
                let green = UIImage(named: "green")
                
                imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
                imageView.image = green
                
                imageView.tag = 3
                
                print("added")
                
                view.addSubview(imageView)
                allImageViews.append(imageView)
            }
        }
    }
    func foundPiece(dir: Int, currRow: Int, currCol: Int, pieceTrue: Bool, mine: Bool) {
        
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
        
        
        if (mine == true) {
            hitMine = true
            map[currRow][currCol] = 0
            
            print(currRow, currCol)
            
            var iVal = 0
            
            for i in 0..<currRowCol.count {
                if (i % 2 == 0) {
                    if (currRowCol[i] == currRow && currRowCol[i + 1] == currCol) {
                        iVal = i
                    }
                }
            }
            
            var row = currRow
            var col = currCol
            if (dir == 0) {
                col = findCurrCol(dir: 0, currRow: row, currCol: col, array: testBefore)
            }
            else if (dir == 1) {
                row = findCurrCol(dir: 1, currRow: row, currCol: col, array: testBefore)
            }
            else if (dir == 2) {
                col = findCurrCol(dir: 2, currRow: row, currCol: col, array: testBefore)
            }
            else if (dir == 3) {
                row = findCurrCol(dir: 3, currRow: row, currCol: col, array: testBefore)
            }
            
            currRowCol.remove(at: iVal)
            currRowCol.remove(at: iVal)
        
            print(row, col)
            let xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
            let yVal = ((row) * blockWidth) + (marginBetweenBlock * (row)) + topMargin
            
            print(xVal, yVal)
            
            for i in 0..<allImageViews.count {
                let x = Double(allImageViews[i].center.x)
                let y = Double(allImageViews[i].center.y)
                
                if (x == Double(xVal) + 12.5 && y == Double(yVal) + 12.5 && allImageViews[i].tag == 3) {
                    allImageViews[i].removeFromSuperview()
                    allImageViews.remove(at: i)
                    break
                }
            }
            
            checkLose()
            checkWin()
        }
        else if (pieceTrue == false) {
            map[rowDir][colDir] = 3
            currRowCol.append(rowDir)
            currRowCol.append(colDir)
            let tag = makeTag(beforemodRow: rowDir, tag: colDir)
            changePieceColor(colDir: colDir, rowDir: rowDir, tag: tag)
        }
        else {
            let num = map[rowDir][colDir]
            let array = together[num]!
            for i in 0..<array.count {
                if (i % 2 == 0) {
                    let row = array[i]
                    let col = array[i + 1]
                    map[row][col] = 3
                    currRowCol.append(row)
                    currRowCol.append(col)
                    let tag = makeTag(beforemodRow: row, tag: col)
                    changePieceColor(colDir: col, rowDir: row, tag: tag)
                }
            }
            for i in 0..<allImageViews.count {
                if (allImageViews[i].tag == num) {
                    self.allImageViews[i].removeFromSuperview()
                }
            }
        }
    }
    
    var distance = 0
    
    func checkWin() -> Bool {
        var tempCheck: [Int] = []
        for row in 0..<rows {
            for col in 0..<cols {
                if (map[row][col] == 3) {
                    tempCheck.append(row)
                    tempCheck.append(col)
                }
            }
        }
        if (checkWinRowCol == tempCheck) {
            
            let defaults = UserDefaults.standard
            
            if (defaults.value(forKey: "maxLevel") == nil) {
                defaults.set(1, forKey: "maxLevel")
            }
            else {
                let levelNum = defaults.integer(forKey: "maxLevel")
                if (mapNumber + 1 > levelNum) {
                    defaults.set(mapNumber + 1, forKey: "maxLevel")
                }
            }
            
            print(defaults.integer(forKey: "maxLevel"))
        
            if (restID == "level1id") {
                defaults.set(true, forKey: "level1")
            }
            else if (restID == "level2id") {
                defaults.set(true, forKey: "level2")
            }
            else if (restID == "level3id") {
                defaults.set(true, forKey: "level3")
            }
            else if (restID == "level4id") {
                defaults.set(true, forKey: "level4")
            }
            else if (restID == "level5id") {
                defaults.set(true, forKey: "level5")
            }
            else if (restID == "level6id") {
                defaults.set(true, forKey: "level6")
            }
            else if (restID == "level7id") {
                defaults.set(true, forKey: "level7")
            }
            else if (restID == "level8id") {
                defaults.set(true, forKey: "level8")
            }
            else if (restID == "level9id") {
                defaults.set(true, forKey: "level9")
            }
            else if (restID == "level10id") {
                defaults.set(true, forKey: "level10")
            }
            
            won = true
            nextLevel.alpha = 1
            nextLevel.isEnabled = true
            restartButton.isEnabled = false
            level1.textColor = UIColor.black
            self.wellDone.alpha = 1
            
            
            UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: UIViewAnimationOptions.curveEaseIn , animations: ( {
                self.nextLevel.center.x = 305
            }), completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: UIViewAnimationOptions.curveEaseIn , animations: ( {
                self.wellDone.center.x = self.view.frame.width / 2
            }), completion: nil)
            
            return true
        }
        return false
    }
    
    func swipe(dir: Int) {
        if (checkWin() == true) {
            animate(rowCols: currRowCol, dist: distance)
            return
        }
        if (checkLose() == true) {
            return
        }
        
        let maxMin = findPlayerBlocks()
        
        let rowWidth = maxMin[0]
        let colWidth = maxMin[1]
        let minRow = maxMin[2]
        let minCol = maxMin[3]
        
        //print(rowWidth, colWidth, minRow, minCol)
        
        if (dir == 0 || dir == 2) {
            var found = false
            var piece = false
            firstSwipe = false
            var currentCols: [Int] = []
            var currentRows: [Int] = []
            
            
            for i in 0..<rowWidth {
                var currCol = 0
                let currRow = minRow + i
                currCol = findCurrCol(dir: dir, currRow: currRow, currCol: currCol, array: currRowCol)
                currentCols.append(currCol)
                currentRows.append(currRow)
                
                var colDir = 0
                
                if (dir == 0) {
                    colDir = currCol + 1
                }
                else {
                    colDir = currCol - 1
                }
                
                let currNum = map[currRow][colDir]
                
                let length = numLength(num: currNum)
                
                if (currNum == 1) {
                    found = true
                }
                
                if (currNum == 4 || length == 5 || length == 4) {
                    piece = true
                }
            }
            
            if (found == false && piece == false) {
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
                            foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: false, mine: false)
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
                    
                    let currNum = map[currRow][colDir]
                    
                    let length = numLength(num: currNum)
                    
                    if (length == 4) {
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: false, mine: true)
                    }
                    else if (length == 5) {
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: true, mine: false)
                    }
                    else if (currNum == 4) {
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: false, mine: false)
                    }
                }
            }
            
        } else if (dir == 1 || dir == 3) {
            
            var piece = false
            var found = false
            firstSwipe = false
            var currentCols: [Int] = []
            var currentRows: [Int] = []
        
            for i in 0..<colWidth {
                let currCol = minCol + i
                var currRow = 0
                currRow = findCurrCol(dir: dir, currRow: currRow, currCol: currCol, array: currRowCol)
                currentCols.append(currCol)
                currentRows.append(currRow)
                
                var rowDir = 0
                
                if (dir == 1) {
                    rowDir = currRow + 1
                }
                else {
                    rowDir = currRow - 1
                }
                
                let currNum = map[rowDir][currCol]
                
                let length = numLength(num: currNum)
                
                if (currNum == 1) {
                    found = true
                }
                
                if (currNum == 4 || length == 5 || length == 4) {
                    piece = true
                }
            }
            
            
            if (found == false && piece == false) {
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
                            foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: false, mine: false)
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
                    
                    let currNum = map[rowDir][currCol]
                    
                    let length = numLength(num: currNum)
                    
                    if (length == 4) {
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: false, mine: true)
                    }
                    
                    if (length == 5) {
        
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: true, mine: false)
                    }
                    
                    if (currNum == 4) {
                        
                        foundPiece(dir: dir, currRow: currRow, currCol: currCol, pieceTrue: false, mine: false)
                    }
                }
            }
        }
        
        if (testBefore != currRowCol){
            shake()
        }
        
        print(map)
        
        if (currRowCol.count != 0 && testBefore != currRowCol) {
            animate(rowCols: currRowCol, dist: distance)
        }
    
        if (hitMine == true) {
            checkSeperate()
            hitMine = false
        }
        
        checkLose()
        
        distance = 0
        
        //print(currRowCol)
    
        currRowCol = []
        testBefore = []
    }
    
    func checkSeperate() {
        var safe: [[Int]] = [[-1, -1]]
        for i in 0..<currRowCol.count {
            if (i % 2 == 0) {
                print(safe)
                print(currRowCol)
                if (safe[0][0] == -1) {
                    safe[0][0] = currRowCol[0]
                    safe[0][1] = currRowCol[1]
                    continue
                }
                var good = false
                for j in 0..<safe.count {
                    var num = 0
                    if (abs(safe[j][0] - currRowCol[i]) == 1) {
                        num += 1
                    }
                    if (abs(safe[j][1] - currRowCol[i + 1]) == 1) {
                        num += 1
                    }
                    if (num == 1) {
                        good = true
                    }
                }
                if (good == true) {
                    safe.append([currRowCol[i], currRowCol[i + 1]])
                }
            }
        }
        
        for row in 0..<rows {
            for col in 0..<cols {
                var good = false
                for i in 0..<safe.count {
                    if (safe[i][0] == row && safe[i][1] == col) {
                        good = true
                    }
                }
                if (map[row][col] == 3 && good == false) {
                    map[row][col] = 4
                    let xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
                    let yVal = ((row) * blockWidth) + (marginBetweenBlock * (row)) + topMargin
                    
                    
                    for i in 0..<allImageViews.count {
                        let x = Double(allImageViews[i].center.x)
                        let y = Double(allImageViews[i].center.y)
                        
                        if (x == Double(xVal) + 12.5 && y == Double(yVal) + 12.5 && allImageViews[i].tag == 3) {
                            allImageViews[i].removeFromSuperview()
                            allImageViews.remove(at: i)
                            
                            let tag = makeTag(beforemodRow: row, tag: col)
                            
                            let imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
                            imageView.image = UIImage(named: "darkgreen")
                            imageView.tag = tag
                            print(tag)
                            
                            view.addSubview(imageView)
                            allImageViews.append(imageView)
                        }
                    }
                }
            }
        }
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
                print("hi")
            }
        }
        
        print(currRowCol)
        
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
    
    func findDirSpike(num: Int) -> Int{
        var num = num
        var pos = 3
        while (Double(num) > 0.99) {
            if (num % 10 == 1) {
                break
            }
            pos -= 1
            num /= 10
        }
        return pos
    }
    
    func drawBlocks() {
        
        var imageView: UIImageView!
        let red = UIImage(named: "block")
        let blue = UIImage(named: "blockk")
        let wall = UIImage(named: "wall")
        let yellow = UIImage(named: "yello")
        let green = UIImage(named: "green")
        let darkgreen = UIImage(named: "darkgreen")
        let spike = UIImage(named: "spike")
        
        var togetherBlocks: [[Int]] = []
        
        var spikes: [[Int]] = []
        
        for row in 0..<rows {
            for col in 0..<cols {
                let currNum = map[row][col]
                let xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
                let yVal = (row * blockWidth) + (marginBetweenBlock * row) + topMargin
                
                let length = numLength(num: currNum)
                
                if (length == 5) {
                    togetherBlocks.append([currNum, row, col])
                }
                
                if (length == 4) {
                    let num = currNum
                    let dir = findDirSpike(num: num)
                    var spikeRow = row
                    var spikeCol = col
                    if (dir == 0) {
                        spikeRow -= 1
                    }
                    if (dir == 1) {
                        spikeCol += 1
                    }
                    if (dir == 2) {
                        spikeRow += 1
                    }
                    if (dir == 3) {
                        spikeCol -= 1
                    }
                    
                    let spikeX = (spikeCol * blockWidth) + (marginBetweenBlock * spikeCol) + leftMargin
                    let spikeY = (spikeRow * blockWidth) + (marginBetweenBlock * spikeRow) + topMargin
                    
                    spikes.append([spikeX, spikeY, dir])
                }
                
                if (currNum == 0 || currNum == 4 || currNum == 3 || length == 5) {
                    imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
                    imageView.image = blue
                    
                    view.addSubview(imageView)
                    allImageViews.append(imageView)
                }
                
                if (currNum == 1 || length == 4){
                    imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
                    imageView.image = wall
                    
                    view.addSubview(imageView)
                    allImageViews.append(imageView)
                }
                else if (currNum == 2){
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

        
        for i in 0..<togetherBlocks.count {
        
            let currNum = togetherBlocks[i][0]
            
            if (together[currNum] == nil) {
                together[currNum] = [Int]()
            }
            
            var array = together[currNum]!
            array.append(togetherBlocks[i][1])
            array.append(togetherBlocks[i][2])
            together[currNum] = array
            
            let row = togetherBlocks[i][1]
            let col = togetherBlocks[i][2]
            
            let xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
            let yVal = (row * blockWidth) + (marginBetweenBlock * row) + topMargin
            
            let tag = makeTag(beforemodRow: row, tag: col)
            addSquare(imageView: imageView, color: darkgreen!, xVal: xVal, yVal: yVal, tag: tag)
        }
        
        for (id, array) in together {
            var coords = [[Int]]()
            
            for i in 0..<array.count {
                if (i % 2 == 0) {
                    coords.append([array[i], array[i + 1]])
                }
            }
            
            for i in 0..<coords.count {
                let coord = coords[i]
                var bools = [Bool]()
                var dirs = [false, false, false, false] //up, right, down, left
                
                for j in 0..<coords.count {
                    bools.append(false)
                }
                
                for j in 0..<coords.count {
                    var counter = 0
                    if (abs(coords[j][0] - coord[0]) == 1) {
                        counter += 1
                    }
                    else if (abs(coords[j][0] - coord[0]) == 0) {
                        counter += 0
                    }
                    else {
                        counter = 100
                    }
                    
                    if (abs(coords[j][1] - coord[1]) == 1) {
                        counter += 1
                    }
                    else if (abs(coords[j][1] - coord[1]) == 0) {
                        counter += 0
                    }
                    else {
                        counter = 100
                    }
                    
                    if (counter == 1) {
                        bools[j] = true
                    }
                    
                }
                
                print(bools)
                
                for j in 0..<bools.count {
                    if (bools[j] == true) {
                        let row = coord[0] - coords[j][0]
                        let col = coord[1] - coords[j][1]
                    
                        if (row == 0) {
                            if (col == 1) {
                                dirs[3] = true
                            }
                            else {
                                dirs[1] = true
                            }
                        }
                        else {
                            if (row == 1) {
                                dirs[0] = true
                            }
                            else {
                                dirs[2] = true
                            }
                        }
                    }
                }
                
                for j in 0..<dirs.count {
                    if (dirs[j] == true) {
                        let row = coord[0]
                        let col = coord[1]
                        
                        var xVal = (col * blockWidth) + (marginBetweenBlock * col) + leftMargin
                        var yVal = (row * blockWidth) + (marginBetweenBlock * row) + topMargin
                        
                        if (j == 0) {
                            yVal -= 13
                        }
                        if (j == 1) {
                            xVal += 13
                        }
                        if (j == 2) {
                            yVal += 13
                        }
                        if (j == 3) {
                            xVal -= 13
                        }
                        addSquare(imageView: imageView, color: darkgreen!, xVal: xVal, yVal: yVal, tag: id)
                    }
                }
            }
        }
        
        for i in 0..<spikes.count {
            let dir = spikes[i][2]
            imageView = UIImageView(frame: CGRect(x: spikes[i][0], y: spikes[i][1], width: 25, height: 25))
            imageView.image = spike
            
            imageView.transform = CGAffineTransform(rotationAngle: ((CGFloat(dir) * 90.0) * CGFloat(M_PI)) / 180.0)
            
            view.addSubview(imageView)
            allImageViews.append(imageView)
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
    
    func numLength(num: Int) -> Int {
        var num = num
        var length = 0
        
        while(Double(num) > 0.99) {
            length += 1
            num /= 10
        }
        
        return length
    }
    
}

/*
 map[currRow + 1][currCol] = 2
 map[ogRow + 1][currCol] = 3
 for i in 0..<allImageViews.count {
 
 let tag = makeTag(beforemodRow: currRow + 1, tag: currCol)
 if (allImageViews[i].tag == tag) {
 self.allImageViews[i].removeFromSuperview()x
 
 let xVal = (currCol * blockWidth) + (marginBetweenBlock * currCol) + leftMargin
 let yVal = ((currRow + 1) * blockWidth) + (marginBetweenBlock * (currRow + 1)) + topMargin
 
 imageView = UIImageView(frame: CGRect(x: xVal, y: yVal, width: 25, height: 25))
 imageView.image = green
 
 imageView.tag = 3
 
 view.addSubview(imageView)
 allImageViews.append(imageView)
 }
 
 } */
