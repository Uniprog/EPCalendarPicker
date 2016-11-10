//
//  ViewController.swift
//  EPCalendar
//
//  Created by Prabaharan Elangovan on 02/11/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EPCalendarPickerDelegate {

    @IBOutlet weak var txtViewDetail: UITextView!
    @IBOutlet weak var btnShowMeCalendar: UIButton!
    
    var calendarPicker: EPCalendarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTouchShowMeCalendarButton(sender: AnyObject) {
        
        let currentDate = Date()
        self.calendarPicker = EPCalendarViewController(startYear: currentDate.year(), endYear: currentDate.year() + 1, selectedDates: [], ignoredDates: [])
        calendarPicker.calendarDelegate = self
        calendarPicker.startDate = Date()
        calendarPicker.hightlightsToday = true
        calendarPicker.showsTodaysButton = true
        calendarPicker.hideDaysFromOtherMonth = true
        
        calendarPicker.view.frame = self.view.bounds;
        calendarPicker.willMove(toParentViewController: self)
        self.view.addSubview(calendarPicker.view)
        self.addChildViewController(calendarPicker)
        calendarPicker.didMove(toParentViewController: self)
        

    }
    
    //! MARK: EPCalendarPickerDelegate
    func epCalendar(_ calendar: EPCalendarViewController, scrollViewDidScroll scrollView: UIScrollView) {
        
    }
    
    func epCalendar(_ calendar: EPCalendarViewController, shouldSelectDate date: Date) -> Bool {
        
        return true
    }

}

