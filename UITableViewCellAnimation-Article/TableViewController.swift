//
//  TableViewController.swift
//  UITableViewCellAnimation-Article
//
//  Created by Vadym Bulavin on 9/4/18.
//  Copyright © 2018 Vadim Bulavin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

	@IBAction func onRefresh(_ sender: UIBarButtonItem) {
		tableView.reloadData()
	}

	// MARK: - Table view data source and delegate methods

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
//        let animation = AnimationFactory.makeFadeAnimation(duration: 0.5, delayFactor: 0.05)
//        let animation = AnimationFactory.makeMoveUpWithBounce(rowHight: cell.frame.height, duration: 1.0, delayFactor: 0.05)
//        let animation = AnimationFactory.makeMoveUpWithFade(rowHight: cell.frame.height, duration: 1.0, delayFactor: 0.05)
        let animation = AnimationFactory.makeSlideIn(duration: 1.0, delayFactor: 0.05)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
}

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation
    
    init(animation: @escaping Animation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        animation(cell, indexPath, tableView)
        
        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
}

enum AnimationFactory {
    static func makeFadeAnimation(duration: TimeInterval, delayFactor: Double) -> Animation {
        return {
            cell, IndexPath, _ in
            cell.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(IndexPath.row),
                animations: {
                    cell.alpha = 1
            })
        }
    }
    
    static func makeMoveUpWithBounce(rowHight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return {
            cell, IndexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHight)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(IndexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
        }
    }
    
    static func makeMoveUpWithFade(rowHight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation {
        return {
            cell, IndexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHight / 2)
            cell.alpha = 0
            
        UIView.animate(
            withDuration: duration,
            delay: delayFactor * Double(IndexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            })
        }
    }
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> Animation {
        return {
            cell, IndexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(IndexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}

