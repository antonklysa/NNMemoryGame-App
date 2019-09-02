//
//  MemoryGameViewController.swift
//  NNMemoryGame
//
//  Created by  on 6/18/18.
//  Copyright © 2018 . All rights reserved.
//

import Foundation
import UIKit
import Mantle

class MemoryGameViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var seconds: Double = 30.0
    private var gameTimer: Timer!

    @IBOutlet private weak var counterValueLabel: UILabel!
    @IBOutlet private weak var titleImageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var collectionViewDataSourceArray: [Card] = []
    private var selectedArray: [Card] = []
    private weak var firstSelectedCell: CardCollectionViewCell?
    var shouldShowCoachMarks: Bool = true
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.counterValueLabel.text = String(format:"00:%02d", Int(self.seconds))

        if LocalizationManagers.isArabic() {
            counterValueLabel.semanticContentAttribute = .forceRightToLeft
            counterValueLabel.font = UIFont(name: "MyriadPro-Bold", size: counterValueLabel.font.pointSize)
        }
        
        self.collectionView.alpha = 0.0
        
        titleImageView.image = UIImage(named: LocalizationManagers.isArabic() ? "ar_title" : "fr_title")
        
        //setup data source array
        //parsing json into an collection view data source array
        let path: String = Bundle.main.path(forResource:"package_json", ofType: "json")!
        let url: URL = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let jsonDict = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        collectionViewDataSourceArray = try! MTLJSONAdapter.models(of: Card.self, fromJSONArray: jsonDict as! [Any]) as! [Card]

        //randomize collection view data array
//        collectionViewDataSourceArray.shuffle()
        collectionViewDataSourceArray = collectionViewDataSourceArray.shuffled()
        
        //setup collection view layout
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 35
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.shouldShowCoachMarks {
            self.showCoachmarks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.alpha = 1.0
        self.view.layoutIfNeeded()
    }
    
    func showAllItemsUnflipped() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        for cellIndex in 0 ..< collectionViewDataSourceArray.count {
            let cell = self.collectionView.cellForItem(at: IndexPath(item: cellIndex, section: 0)) as! CardCollectionViewCell
            cell.flip(onCellState: .open) { (flag) in
                let deadlineTime = DispatchTime.now() + .seconds(5)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    cell.flip(onCellState: .close, completionHandler: { (flag) in
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if flag && self.gameTimer == nil {
                            self.beginTimerUpdates()
                        }
                    })
                }
            }
        }
    }
    
    //MARK: Router
    
    private func showCoachmarks() {
        let coachMarksVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: AppSettings.defaultSettings.language.isArabic() ? "CoachMarksViewController_ar" : "CoachMarksViewController")) as! CoachMarksViewController
        coachMarksVC.delegate = self
        self.present(coachMarksVC, animated: true, completion: nil)
        
        self.shouldShowCoachMarks = false
    }
    
    //MARK: actions
    
    private func flipCard(indexPath: IndexPath, time: TimeInterval = 0.3) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let selectedCell: CardCollectionViewCell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        if selectedArray.contains(where: { (card) -> Bool in
            return card.addressHeap(o: card) == selectedCell.cardModel.addressHeap(o: selectedCell.cardModel)
        }) {
            UIApplication.shared.endIgnoringInteractionEvents()
            return
        }
        
        if firstSelectedCell == nil {
            firstSelectedCell = selectedCell
        }
        
        selectedCell.flip(onCellState: .open, time: time) { [weak self] (bool) in
            self?.selectedArray.append(selectedCell.cardModel)
            
            if (self?.selectedArray.count)! % 2 == 0 {
                let filteredArray: [Card] = (self?.selectedArray.filter { (card) -> Bool in
                    return card.group_id == selectedCell.cardModel.group_id
                    })!
                if filteredArray.count != 2 {
                    selectedCell.flip(onCellState: .close) {(bool) in
                        if bool {
                            //remove second selected cell
                            self?.selectedArray.removeLast()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }
                    self?.firstSelectedCell?.flip(onCellState: .close) { (bool) in
                        if bool {
                            //remove first selected cell
                            self?.selectedArray.removeLast()
                            self?.firstSelectedCell = nil
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    }
                } else {
                    self?.firstSelectedCell = nil
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if self?.selectedArray.count == self?.collectionViewDataSourceArray.count {
//                        self?.winAction()
                        let popupVC = self?.storyboard?.instantiateViewController(withIdentifier: String(describing: GamePopupViewController.self)) as! GamePopupViewController
                        popupVC.delegate = self
                        let textImage = UIImage(named: "popup_image_\(arc4random()%4)_\(AppSettings.defaultSettings.language.prefixLanguage())")
                        popupVC.textImage = textImage
                        self?.present(popupVC, animated: true, completion: nil)
                        
                        self?.gameTimer.invalidate()
                    }
                }
            } else {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
//        
//        if selectedArray.count == collectionViewDataSourceArray.count {
//            UIApplication.shared.endIgnoringInteractionEvents()
//            winAction()
//        }
    }
    
    
    //MARK: Timer
    
    private func beginTimerUpdates() {
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        self.seconds -= 0.1
        self.counterValueLabel.text = String(format:"00:%02d", Int(self.seconds))
        
        if self.seconds <= 0 {
            self.loseAction()
        }
    }
    
    private func winAction() {
        if gameTimer != nil {
            self.gameTimer.invalidate()
            self.gameTimer = nil
        }
        
        let vc: TuDecidePopupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TuDecidePopupViewController") as! TuDecidePopupViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func loseAction() {
        if self.gameTimer != nil {
            self.gameTimer.invalidate()
            self.gameTimer = nil
        }
        
        let vc: LoseViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoseViewController") as! LoseViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        flipCard(indexPath: indexPath)
    }
    
    //MARK: UICollectionViewDataSource
    
    private func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSourceArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String = "collectionViewCellIdentifier"
        let cell: CardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CardCollectionViewCell
        cell.setCardModel(model: collectionViewDataSourceArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 178.0, height: 243.0)
    }
    
}


//for shuffle cards array

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
//        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
//            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
//            let i = index(firstUnshuffled, offsetBy: d)
//            swapAt(firstUnshuffled, i)
//        }
    }
}

extension MemoryGameViewController : GamePopupViewControllerDelegate {
    
    func gamePopupDidFinish(_ vc: GamePopupViewController) {
        vc.dismiss(animated: true) {
            self.winAction()
        }
    }
    
}

extension MemoryGameViewController: CoachMarksViewControllerDelegate {
    
    func coachMarksViewControllerDidFinish(_ vc: CoachMarksViewController) {
        vc.dismiss(animated: true) {
            self.showAllItemsUnflipped()
        }
    }
    
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
//        result.shuffle()
        result.swapAt(0, 7)
        result.swapAt(2, 4)
        result.swapAt(3, 6)
        result.swapAt(4, 7)
        result.swapAt(5, 6)
        
        return result
    }
}
