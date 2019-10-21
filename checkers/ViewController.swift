//
//  ViewController.swift
//  checkers
//
//  Created by Сергей on 03/10/2019.
//  Copyright © 2019 Sergei. All rights reserved.
//


//Вот такой вот урок по тачам. Решил жесты и тачи в один урок не объединять, а относительно простой функционал тачей решил дополнить практическим примером :)
//
//Уровень супермен (остальных уровней не будет)
//
//1. Создайте шахматное поле (8х8), используйте черные сабвьюхи
//2. Добавьте балые и красные шашки на черные клетки (используйте начальное расположение в шашках)
//3. Реализуйте механизм драг'н'дроп подобно тому, что я сделал в примере, но с условиями:
//4. Шашки должны ставать в центр черных клеток.
//5. Даже если я отпустил шашку над центром белой клетки - она должна переместиться в центр ближайшей к отпусканию черной клетки.
//6. Шашки не могут становиться друг на друга
//7. Шашки не могут быть поставлены за пределы поля.
//
//Вот такое вот веселое практическое задание :)

import UIKit
@IBDesignable

class ViewController: UIViewController {
    
    var alertWarning: UIAlertController?
    var alertAction = UIAlertAction(title: "Understand", style: .destructive, handler: nil)
    
    var checkerForDragging: UIView? = nil
    var touchOffset: CGPoint! = nil
    var startPointTouch: CGPoint! = nil
    
    var togetherCheckers: [Checker]?
    
    @IBOutlet var checkersBlack: [CheckerBlack]!
    @IBOutlet var checkersWhite: [CheckerWhite]!
    
    @IBOutlet var blackCells: [BlackCell]!
    
    @IBOutlet weak var woodenPlank: UIImageView!
    @IBOutlet weak var checkerBoard: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.togetherCheckers = self.checkersWhite + self.checkersBlack
        
    }
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        self.printingPoint(touches: touches, self.view, "touchesBegan")
        
        let touchPointOnMain = self.getPointLocation(touches, self.view)
        
        let viewWhichContainTouch = self.view.hitTest(touchPointOnMain, with: event) ?? UIView()
         
        if !viewWhichContainTouch.isEqual(self.view) && viewWhichContainTouch.tag != 2 {
            
            self.checkerForDragging = viewWhichContainTouch
            self.checkerForDragging?.tag = 5
            let indexOfRemove = (self.togetherCheckers ?? [Checker()]).firstIndex(of: self.checkerForDragging as! Checker)
            self.togetherCheckers?.remove(at: indexOfRemove ?? 0)
            self.view.bringSubviewToFront(self.checkerForDragging ?? UIView())
            self.startPointTouch = self.checkerForDragging?.center
            self.touchOffset = CGPoint(x: (self.checkerForDragging?.center.x ?? 0.0) - touchPointOnMain.x,
                                       y: (self.checkerForDragging?.center.y ?? 0.0) - touchPointOnMain.y)
            
            UIView.animate(withDuration: 0.3) {
                self.checkerForDragging?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
            
        } else {
            
            self.checkerForDragging = nil
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.printingPoint(touches: touches, self.view, "touchesMoved")
        
        let touchPointOnMain = self.getPointLocation(touches, self.view)
        
        if self.checkerForDragging != nil {
            
            let pointCorrect = CGPoint(x: self.touchOffset.x + touchPointOnMain.x,
                                       y: self.touchOffset.y + touchPointOnMain.y)
            
            self.checkerForDragging?.center = pointCorrect
            
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.printingPoint(touches: touches, self.view, "touchesEnded")
        
        let unwrappedCheckerForDragging = self.checkerForDragging ?? UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
         
        self.defaultStateFor(view: self.checkerForDragging)
    
        
        if !unwrappedCheckerForDragging.frame.intersects(self.checkerBoard.frame.insetBy(dx: 150.0, dy: 150.0)) {
            
            self.alertWarning = UIAlertController(title: "✋ATTENTION✋", message: "You cannot go outside the board!\n❌", preferredStyle: .alert)
            self.alertWarning?.addAction(self.alertAction)
            self.present(self.alertWarning ?? UIAlertController(), animated: true, completion: nil)
            
            UIView.animate(withDuration: 0.3) {
                unwrappedCheckerForDragging.center = self.startPointTouch
            }
        }
        
        let (intersCheckerAndBlackCells, intersBlackCell) = self.definesIntersections(element: self.checkerForDragging, withOneFrom: self.blackCells)
        let (intersCheckerAndCheker, _) = self.definesIntersections(element: self.checkerForDragging, withOneFrom: self.togetherCheckers ?? [Checker()])
        
        if intersCheckerAndCheker {
            
            UIView.animate(withDuration: 0.3) {
                unwrappedCheckerForDragging.center = self.startPointTouch
            }
            
            self.alertWarning = UIAlertController(title: "✋ATTENTION✋", message: "Cannot be placed on anoter checker!\n❌", preferredStyle: .alert)
            self.alertWarning?.addAction(self.alertAction)
            self.present(self.alertWarning ?? UIAlertController(), animated: true, completion: nil)
            
            self.togetherCheckers?.append(unwrappedCheckerForDragging as! Checker)
    
        } else if intersCheckerAndBlackCells && !intersCheckerAndCheker {
            
            UIView.animate(withDuration: 0.3) {
                unwrappedCheckerForDragging.center = intersBlackCell?.center ?? self.startPointTouch
            }
            
            self.togetherCheckers?.append(unwrappedCheckerForDragging as! Checker)
            
        } else {
            
            UIView.animate(withDuration: 0.3) {
                unwrappedCheckerForDragging.center = self.startPointTouch
            }

            self.alertWarning = UIAlertController(title: "✋ATTENTION✋", message: "Сannot be placed on a white cage!\n❌", preferredStyle: .alert)
            self.alertWarning?.addAction(self.alertAction)
            self.present(self.alertWarning ?? UIAlertController(), animated: true, completion: nil)
            
            self.togetherCheckers?.append(unwrappedCheckerForDragging as? Checker ?? Checker())
            
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.printingPoint(touches: touches, self.view, "touchesCancelled")
        
        UIView.animate(withDuration: 0.3) {
            self.checkerForDragging?.center = self.startPointTouch
        }
        
        
    }
    
    //MARK: Help function
   private func printingPoint(touches: Set<UITouch>, _ onView: UIView, _ inMethod: String) {
        
        var string = inMethod
        
        for t in touches {
            
            let pointOnView = t.location(in: view)
            string.append(" \(NSCoder.string(for: pointOnView))")
        }
        print(string)
    }
    
    private func defaultStateFor(view: UIView?) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            view?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            view?.alpha = 1.0
            
        })
    }
    
    private func getPointLocation(_ touches: Set<UITouch>, _ onView: UIView) -> CGPoint {
        
        let touch = touches.first ?? UITouch()
        let pointOnView = touch.location(in: self.view)
        
        return pointOnView
    }
    
    private func definesIntersections(element: UIView?, withOneFrom arrayViews: Array<UIView>) -> (Bool, UIView?) {
        
        let unwrappedElement = element ?? UIView()
        let elementFrame = unwrappedElement.frame
        
        
        for view in arrayViews {

            if (elementFrame.intersects(view.frame)) {
                
                return (true, view)
                
            }
        }
        
        return (false, nil)
    }
}


