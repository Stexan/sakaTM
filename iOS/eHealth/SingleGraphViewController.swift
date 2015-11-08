//
//  SingleGraphViewController.swift
//  eHealth
//
//  Created by Stefan Iarca on 11/7/15.
//  Copyright © 2015 Stefan Iarca. All rights reserved.
//

import UIKit
import Charts

class SingleGraphViewController: UIViewController,APIDelegate {

    var category:Category! = Category();
    
    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var valueTextField: UITextField!
    let handler = GoogleAPIHandler();
    var vect:Array<Data> = Array<Data>();
    
    @IBOutlet weak var measurementLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = category.name;
        measurementLabel.text = category.measurement;
        // Do any additional setup after loading the view.
        handler.delegate = self;
        handler.getAllDataForCategory(String(category.id!));
        
        chartView.descriptionText = "";
        chartView.noDataTextDescription = "You need to provide data for the chart.";
        
        chartView.dragEnabled = true;
        chartView.pinchZoomEnabled = true;
        chartView.drawGridBackgroundEnabled = false;
        
        let ll1 = ChartLimitLine(limit: Double(category.maxValue!), label: "Upper Normal Limit");
        ll1.lineWidth = 4.0;
        ll1.lineDashLengths = [5.0, 5.0];
        ll1.labelPosition = .RightTop;
        ll1.valueFont = UIFont.systemFontOfSize(10.0);
        
        let ll2 = ChartLimitLine(limit: Double(category.minValue!), label: "Lower Normal Limit");
        ll2.lineWidth = 4.0;
        ll2.lineDashLengths = [5.0, 5.0];
        ll2.labelPosition = .RightBottom;
        ll2.valueFont = UIFont.systemFontOfSize(10.0);
        
        let leftAxis = chartView.leftAxis;
        leftAxis.removeAllLimitLines();
        leftAxis.addLimitLine(ll1);
        leftAxis.addLimitLine(ll2);
        leftAxis.customAxisMax = Double(category.maxValue! * 2);
        leftAxis.customAxisMin = 0;
        leftAxis.startAtZeroEnabled = false;
        leftAxis.gridLineDashLengths = [5.0, 5.0];
        leftAxis.drawLimitLinesBehindDataEnabled = true;
        
        chartView.xAxis.labelPosition = .Bottom;
        
        
        chartView.rightAxis.enabled = false;
        
        chartView.viewPortHandler.setMaximumScaleX(2.0);
        chartView.viewPortHandler.setMaximumScaleY(2.0);
        
        
        let marker = BalloonMarker(color: UIColor(white: 180/255.0, alpha: 1.0),font: UIFont.systemFontOfSize(12.0), insets:UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0));
        
        marker.minimumSize = CGSizeMake(80.0, 40.0);
        chartView.marker = marker;
        
        chartView.legend.form = .Line;
        
        chartView.animate(xAxisDuration: 1.5, easingOption:.EaseInOutQuart)
    }
    
    func setDataCount(dataArray:Array<Data>){
        
        if dataArray.count == 0 {
            return;
        }
        
        var xVals = Array<String>();
    
       
        for (var i:Int = 0; i < dataArray.count; i++)
        {
            xVals.append(String(i));
        }
    
    
        var yVals = Array<ChartDataEntry>();
    
 

        for (var i:Int = 0; i < dataArray.count; i++){
            let data = dataArray[i];
            yVals.append(ChartDataEntry(value: data.numericValue, xIndex: i));
        }
    
    
        let set1 = LineChartDataSet(yVals: yVals, label: "");
    
    
        set1.lineDashLengths = [5.0, 2.5];
    
        set1.highlightLineDashLengths = [5.0, 2.5];
    
        set1.setColor(UIColor.blackColor());
        set1.setCircleColor(UIColor.blackColor());
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = false;
        set1.valueFont = UIFont.systemFontOfSize(9.0);
        set1.fillAlpha = 65/255.0;
        set1.fillColor = UIColor.blackColor();
        
        
        let data = LineChartData(xVals: xVals, dataSets: [set1]);
        
        chartView.data = data;
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func handlerDidGetResults(results:Array<AnyObject>?){
        
        handler.delegate = nil;
        
        chartView.data = nil;
        setDataCount(results as! Array<Data>);
        vect = results as! Array<Data>;
    }
    
    func handlerDidFailWithError(error:NSError?,description:String?){
        
        handler.delegate = nil;
        let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: description, preferredStyle: .Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }

    @IBAction func addValue(sender: AnyObject) {
        handler.delegate = self;
        handler.postDataForCategory(String(category.id!), value: valueTextField.text!);
        self.valueTextField.resignFirstResponder();
    }
}
