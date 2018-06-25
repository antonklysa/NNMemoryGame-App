//
//  MemoryGameViewController.swift
//  NNMemoryGame
//
//  Created by Anton Klysa on 6/18/18.
//  Copyright © 2018 Anton Klysa. All rights reserved.
//

import Foundation
import UIKit
import Mantle

class MemoryGameViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var timer: Timer!
    private var seconds: Int = 60
    
    @IBOutlet private weak var topContainerView: UIView!
    @IBOutlet private weak var topCounterContainerView: UIView!
    @IBOutlet private weak var counterImageView: UIImageView!
    @IBOutlet private weak var counterValueLabel: UILabel!
    @IBOutlet private weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var collectionViewDataSourceArray: [Card] = []
    
    private var selectedArray: [Card] = []
    
    private weak var firstSelectedCell: CardCollectionViewCell?
    
    //MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup localization layout
        if LocalizationManagers.isArabic() {
            topContainerView.semanticContentAttribute = .forceRightToLeft
            topCounterContainerView.semanticContentAttribute = .forceRightToLeft
            counterValueLabel.semanticContentAttribute = .forceRightToLeft
            counterValueLabel.font = UIFont(name: "MyriadPro-Bold", size: counterValueLabel.font.pointSize)
        }
        
        self.collectionView.alpha = 0.0
        
        counterValueLabel.text = LocalizationManagers.isArabic() ? "\((self.seconds)) :" : ": \((self.seconds))"
        topCounterContainerView.layer.cornerRadius = 5
        
        titleImageView.image = UIImage(named: LocalizationManagers.isArabic() ? "ar_title" : "fr_title")
        counterImageView.image = UIImage(named: LocalizationManagers.isArabic() ? "ar_counter" : "fr_counter")
        
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
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.titleImageViewTopConstraint.constant = 55.0
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (flag) in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                self.collectionView.alpha = 1.0
            }, completion: { (flag) in
                self.beginTimeAction()
            })
        }
    }
    
    //MARK: actions
    
    private func flipCard(indexPath: IndexPath) {
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
        
        selectedCell.flip(onCellState: .open) { [weak self] (bool) in
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
                        self?.winAction()
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
    
    private func beginTimeAction() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] (timer) in
            self!.seconds -= 1
            self?.counterValueLabel.text = LocalizationManagers.isArabic() ? "\((self!.seconds)) :" : ": \((self!.seconds))"
            if self!.seconds <= 0 {
                timer.invalidate()
                self!.loseAction()
            }
        }
    }
    
    private func winAction() {
        self.timer.invalidate()
        self.timer = nil
        
        let vc: WinTextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(format:"WinTextViewController_%@", PMIDataSource.defaultDataSource.language.prefixFromLanguage())) as! WinTextViewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func loseAction() {
        self.timer.invalidate()
        self.timer = nil
        
        let vc: LoseViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(format:"LoseViewController_%@", PMIDataSource.defaultDataSource.language.prefixFromLanguage())) as! LoseViewController
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
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
