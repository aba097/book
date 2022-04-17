//
//  CollectionViewCell.swift
//  Book
//
//  Created by 相場智也 on 2021/09/01.
//

//検索結果表示cellと紐づいている

import UIKit


class CollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var TitleTextView: UITextView!
    
    @IBOutlet weak var WriterTextView: UITextView!
    
    @IBOutlet weak var PublisherTextView: UITextView!
    
    @IBOutlet weak var BorrowerLabel: UILabel!
    
    @IBOutlet weak var CommentTextView: UITextView!
    
    @IBOutlet weak var BorrowReturnButton: UIButton!
    
    @IBOutlet weak var ImageView: UIImageView!
    
  
}
