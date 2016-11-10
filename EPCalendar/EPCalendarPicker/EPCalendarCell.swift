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
            
            lblDay.textColor = EPConfig.weekdayDateColor
            break
            
        case .Weekend:
            
            lblDay.textColor = EPConfig.weekendDateColor
            break
            
        case .Today:
            
            backImageView.image = EPConfig.todayClendarIconImage
            lblDay.text = EPConfig.TodayDateText
            lblDay.textColor = EPConfig.todayDateColor
            break
            
        case .Selected:
            
            coverImageView.image = UIImage.calendarCowHeadIconImage()
            lblDay.textColor = EPConfig.selectedDateColor
            break
            
        case .Ignored:
            
            lblDay.textColor = EPConfig.ignoredDateColor
            break
            
        case .Hidded:
            
            lblDay.textColor = EPConfig.dayDisabledDateColor
            break
            
        case .OtherMonth:
            
            lblDay.textColor = EPConfig.otherMonthDateColor
            break
            
        case .OutOfDate:
            
            lblDay.textColor = EPConfig.outOfDateColor
            break
        }
    }
    
}
