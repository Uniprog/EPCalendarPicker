//
//  EPCalendarViewController.swift
//  EPCalendar
//
//

import UIKit

private let reuseIdentifier = "DateCell"

@objc public protocol EPCalendarPickerDelegate{
    
    @objc optional    func epCalendar(_: EPCalendarViewController, didSelectDate date : Date)
    @objc optional    func epCalendar(_: EPCalendarViewController, scrollViewDidScroll scrollView: UIScrollView)
    @objc optional    func epCalendar(_: EPCalendarViewController, shouldSelectDate date : Date) -> Bool
}

open class EPCalendarViewController: UICollectionViewController {
    
    let headerSize = CGSize(width: 100,height: 40)
    
    open var calendarDelegate : EPCalendarPickerDelegate?
    open var showsTodaysButton: Bool = true
    open var isWeekendsSelectable: Bool = false
    
    var arrSelectedDates = [Date]()
    var arrIgnoredDates = [Date]()
    
    // new options
    open var startDate: Date?
    open var hightlightsToday: Bool = true
    open var hideDaysFromOtherMonth: Bool = false
    
    fileprivate(set) open var startYear: Int
    fileprivate(set) open var endYear: Int
    
    var currentYear: Int?
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // setup collectionview
        self.collectionView?.delegate = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "EPCalendarCell", bundle: Bundle(for: EPCalendarViewController.self )), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "EPCalendarHeaderView", bundle: Bundle(for: EPCalendarViewController.self )), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        DispatchQueue.main.async { () -> Void in
            self.scrollToToday()
        }
        
        self.collectionView?.backgroundColor = UIColor.white
    }
    
    
    
    public convenience init(startYear: Int, endYear: Int) {
        self.init(startYear:startYear, endYear:endYear, selectedDates: nil, ignoredDates: nil)
    }
    
    
    public init(startYear: Int, endYear: Int, selectedDates: [Date]?, ignoredDates: [Date]?) {
        
        self.startYear = startYear
        self.endYear = endYear
        
        //Layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = headerSize
        if let _ = selectedDates  {
            self.arrSelectedDates.append(contentsOf: selectedDates!)
        }
        if let _ = ignoredDates  {
            self.arrIgnoredDates.append(contentsOf: ignoredDates!)
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UICollectionViewDataSource
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if startYear > endYear {
            return 0
        }
        
        let numberOfMonths = 12 * (endYear - startYear) + 12
        return numberOfMonths
    }
    
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let startDate = Date(year: startYear, month: 1, day: 1)
        
        let firstDayOfMonth = startDate.dateByAddingMonths(section)
        
        let addingPrefixDaysWithMonthDyas = ( firstDayOfMonth.numberOfDaysInMonth() + firstDayOfMonth.weekday() - Calendar.current.firstWeekday )
        let addingSuffixDays = addingPrefixDaysWithMonthDyas % 7
        var totalNumber  = addingPrefixDaysWithMonthDyas
        if addingSuffixDays != 0 {
            totalNumber = totalNumber + (7 - addingSuffixDays)
        }
        
        return totalNumber
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EPCalendarCell
        
        cell.isCellSelectable = true
        
        let calendarStartDate = Date(year:startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths((indexPath as NSIndexPath).section)
        let prefixDays = ( firstDayOfThisMonth.weekday() - Calendar.current.firstWeekday)
        
        if (indexPath as NSIndexPath).row >= prefixDays {
            
            let currentDate = firstDayOfThisMonth.dateByAddingDays((indexPath as NSIndexPath).row - prefixDays)
            let nextMonthFirstDay = firstDayOfThisMonth.dateByAddingDays(firstDayOfThisMonth.numberOfDaysInMonth() - 1)
            
            cell.currentDate = currentDate
            cell.lblDay.text = "\(currentDate.day())"
            
            
            if arrSelectedDates.filter({ $0.isDateSameDay(currentDate)
            }).count > 0 && (firstDayOfThisMonth.month() == currentDate.month()) {
                
                if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
                    if isWeekendsSelectable {
                        cell.setCellState(.Selected)
                    }
                }else{
                    cell.setCellState(.Selected)
                }
                
            }
            else{
                
                cell.setCellState(.Weekday)
                
                if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
                    if !isWeekendsSelectable {
                        cell.isCellSelectable = false
                    }
                    cell.setCellState(.Weekend)
                }
                
                if (currentDate > nextMonthFirstDay) {
                    cell.isCellSelectable = false
                    cell.setCellState(.OtherMonth)
                }
                
                //! Today
                if currentDate.isToday() && hightlightsToday {
                    cell.setCellState(.Today)
                }
                
                if startDate != nil {
                    if Calendar.current.startOfDay(for: cell.currentDate as Date) < Calendar.current.startOfDay(for: startDate!) {
                        cell.isCellSelectable = false
                        cell.setCellState(.OutOfDate)
                    }
                }
                
            }
            
            if arrIgnoredDates.filter({ $0.isDateSameDay(currentDate)
            }).count > 0 && (firstDayOfThisMonth.month() == currentDate.month()) {
                
                cell.setCellState(.Ignored)
                
            }
            
        }
        else {
            
            let previousDay = firstDayOfThisMonth.dateByAddingDays(-( prefixDays - (indexPath as NSIndexPath).row))
            cell.currentDate = previousDay
            cell.lblDay.text = "\(previousDay.day())"
            
            cell.isCellSelectable = false
            cell.setCellState(.OtherMonth)
        }
        
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        let rect = UIScreen.main.bounds
        let screenWidth = rect.size.width - 7 - 20
        return CGSize(width: screenWidth/7, height: screenWidth/7);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(0, 10, 5, 10); //top,left,bottom,right
    }
    
    override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! EPCalendarHeaderView
            
            let startDate = Date(year: startYear, month: 1, day: 1)
            let firstDayOfMonth = startDate.dateByAddingMonths((indexPath as NSIndexPath).section)
            
            header.lblTitle.text = firstDayOfMonth.monthNameShort()
            header.lblTitle.textColor = EPConfig.headerMonthColor
            
            return header;
        }
        
        return UICollectionReusableView()
    }
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EPCalendarCell
        
        let calendarStartDate = Date(year:startYear, month: 1, day: 1)
        let firstDayOfThisMonth = calendarStartDate.dateByAddingMonths((indexPath as NSIndexPath).section)
        if arrIgnoredDates.filter({ $0.isDateSameDay(cell.currentDate)
        }).count > 0 && (firstDayOfThisMonth.month() == cell.currentDate.month()) {
            
            cell.setCellState(.Ignored)
            return
        }
        
        if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
            
            cell.setCellState(.Weekend)
            return
        }
        
        if startDate != nil {
            if Calendar.current.startOfDay(for: cell.currentDate as Date) < Calendar.current.startOfDay(for: startDate!) {
                cell.setCellState(.OutOfDate)
                return
            }
        }
        
        if (calendarDelegate?.epCalendar!(self, shouldSelectDate: cell.currentDate))! {
            
            if cell.isCellSelectable! {
                
                if arrSelectedDates.filter({ $0.isDateSameDay(cell.currentDate)
                }).count == 0 {
                    arrSelectedDates.append(cell.currentDate)
                    
                    cell.setCellState(.Selected)
                }
                else {
                    arrSelectedDates = arrSelectedDates.filter(){
                        return  !($0.isDateSameDay(cell.currentDate))
                    }
                    
                    if cell.currentDate.isSaturday() || cell.currentDate.isSunday() {
                        
                        cell.setCellState(.Weekend)
                    }
                    else {
                        cell.setCellState(.Weekday)
                    }
                    
                    if cell.currentDate.isToday() && hightlightsToday{
                        cell.setCellState(.Today)
                    }
                }
                
            }
        }
        
    }
    
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let firstCell = self.collectionView?.visibleCells.first as! EPCalendarCell
        
        currentYear = firstCell.currentDate.year()
        calendarDelegate?.epCalendar!(self, scrollViewDidScroll: scrollView)
    }
    
    open func scrollToToday () {
        let today = Date()
        scrollToMonthForDate(today)
    }
    
    open func scrollToMonthForDate (_ date: Date) {
        
        let month = date.month()
        let year = date.year()
        let section = ((year - startYear) * 12) + month
        let indexPath = IndexPath(row:1, section: section-1)
        
        self.collectionView?.scrollToIndexpathByShowingHeader(indexPath)
    }
    
    func clearSelectedDates() {
        arrSelectedDates.removeAll()
        collectionView?.reloadData()
    }
    
    func setSelectedDates(_ dates: [Date]) {
        arrSelectedDates = dates
        collectionView?.reloadData()
    }
    
}
