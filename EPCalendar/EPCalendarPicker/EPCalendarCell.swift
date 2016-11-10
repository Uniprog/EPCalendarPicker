//
//  EPCalendarCell.swift
//  EPCalendar
//
//

import UIKit

enum CalendarCellState {
    case Weekday
    case Weekend
    case Selected
    case Ignored
    case Hidded
    case Today
    case OtherMonth
    case OutOfDate
}

class EPCalendarCell: UICollectionViewCell {
    
    var currentDate: Date!
    var isCellSelectable: Bool?
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCellState(_ state: CalendarCellState) {
        
        backImageView.image = nil
        coverImageView.image = nil
        
        switch state {
        case .Weekday:
            
            lblDay.textColor = UIColor.weekdayDateColor()
            break
            
        case .Weekend:
            
            lblDay.textColor = UIColor.weekendDateColor()
            break
            
        case .Today:
            
            backImageView.image = UIImage.todayClendarIconImage()
            lblDay.text = "TODAY".localized
            lblDay.textColor = UIColor.todayDateColor()
            break
            
        case .Selected:
            
            coverImageView.image = UIImage.calendarCowHeadIconImage()
            lblDay.textColor = UIColor.selectedDateColor()
            break
            
        case .Ignored:
            
            lblDay.textColor = UIColor.ignoredDateColor()
            break
            
        case .Hidded:
            
            lblDay.textColor = UIColor.dayDisabledDateColor()
            break
            
        case .OtherMonth:
            
            lblDay.textColor = UIColor.otherMonthDateColor()
            break
            
        case .OutOfDate:
            
            lblDay.textColor = UIColor.outOfDateColor()
            break
        }
    }
    
}
