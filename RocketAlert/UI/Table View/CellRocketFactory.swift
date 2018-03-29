//
//  CellRocketFactory.swift
//  RocketAlert
//
//  Created by Giuseppe Sapienza on 22/03/18.
//  Copyright © 2018 Giuseppe Sapienza. All rights reserved.
//

import UIKit

struct CellRocketFactory {
    init(block: RocketBlock, tableView: UITableView, indexPath: IndexPath) {
        self.block = block
        self.tableView = tableView
        self.indexPath = indexPath
    }
    
    fileprivate let block: RocketBlock
    fileprivate weak var tableView: UITableView!
    fileprivate let indexPath: IndexPath
    
    func cell() -> UITableViewCell {
        switch block {
        case let b as TextRocketBlock:
            let cell = self.dequeue(t: TextRocketBlock.self) as! TextRocketCell
            cell.currentBlock = b
            return cell
            
        case let b as ButtonRocketBlock:
            let cell = self.dequeue(t: ButtonRocketCell.self) as! ButtonRocketCell
            cell.currentBlock = b
            return cell
            
        case let b as DoubleButtonRocketBlock:
            let cell = self.dequeue(t: DoubleButtonRocketCell.self) as! DoubleButtonRocketCell
            cell.currentBlock = b
            return cell
            
            
        default:
            return self.dequeue(t: RocketBlock.self)
        }
    }
    
    fileprivate func dequeue<T>(t: T.Type) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "\(t.self)", for: indexPath)
    }
    
}
