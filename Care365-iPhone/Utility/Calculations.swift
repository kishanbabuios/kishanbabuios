//
//  WeightCalculations.swift
//  care365_ckd
//
//  Created by Apple on 16/02/21.
//

import Foundation

class WeightCalculations {
    
    var lowerLimit : Double = 0.0
    var upperLimit : Double = 0.0
    var weightGained: Double = 0.0
    
    func getInDecimalPoints(value : Double) -> Double{
        return (String(format: "%.2f", value) as NSString).doubleValue
    }
    
    func weight(dryWeight : String, currentWeight : String, timeDuration: Double) -> Int {
        var flag : Int = 0
        let interDialyticPeriod = Int(interDialstolicPeriod)
        
        let parsedDryWeight = getInDecimalPoints(value: (dryWeight as NSString).doubleValue)
        let parsedCurrentWeight = getInDecimalPoints(value: (currentWeight as NSString).doubleValue)
        
        weightGained = getInDecimalPoints(value: (parsedCurrentWeight - parsedDryWeight))
        usrDefaults.setValue(weightGained, forKey: "weightGained")
        weightGainedDefaults = usrDefaults.double(forKey: "weightGained")
        
        
        lowerLimit = getInDecimalPoints(value: (parsedDryWeight * 0.05) / Double(interDialyticPeriod!))
        upperLimit = getInDecimalPoints(value: (parsedDryWeight * 0.075) / Double(interDialyticPeriod!))
        usrDefaults.setValue(upperLimit, forKey: "upperLimit")
        upperLimitDefaults = usrDefaults.double(forKey: "upperLimit")
        let lowerPermittedWeightGain = getInDecimalPoints(value: lowerLimit * timeDuration)
        let upperPermittedWeightGain = getInDecimalPoints(value: upperLimit * timeDuration)
        
        usrDefaults.setValue(lowerPermittedWeightGain, forKey: "permittedWeightGain")
        permittedWeightGainDefaults = usrDefaults.double(forKey: "permittedWeightGain")
        
        upperPermWtGain = String(upperPermittedWeightGain)
        lowerPermWtGain = String(lowerPermittedWeightGain)
        //usrDefaults.setValue(strUpper, forKey: "upperPermittedWtGain")
        //usrDefaults.setValue(strLower, forKey: "lowerPermittedWtGain")
        PrintLog.print(upperPermWtGain!,lowerPermWtGain!)
        PrintLog.print(weightGained,lowerPermittedWeightGain,upperPermittedWeightGain)
        
        if(weightGained <= lowerPermittedWeightGain){
            flag = Zone.green_flag.rawValue
        }
        else if(weightGained > lowerPermittedWeightGain && weightGained < upperPermittedWeightGain){
            flag = Zone.orange_flag.rawValue
        }
        else if(weightGained >= upperPermittedWeightGain){
            flag = Zone.red_flag.rawValue
        }
        let totalDryweight  = parsedDryWeight + parsedDryWeight * 0.075
        if Double(currentWeight)! >= totalDryweight{
            isExtraDialysis = true
        }else{
            isExtraDialysis = false
        }
        return flag
    }
}

class BpCalculations {
    var sysZoneValue = 0
    var diaZoneValue = 0
    
    let greenFlag = 3
    let orangeFlag =  2
    let RedFlag = 1
    
    var systolicBpType = ""
    var diastolicBpType = ""
    var resultBpType = ""
    
    let HYPER = "hyper"
    let HYPO = "hypo"
    let NORMAL = "normal"
    func getInDecimalPoints(value : Double) -> Double{
        return (String(format: "%.2f", value) as NSString).doubleValue
    }
    
    func SysBloodPressure(sys:String) -> Int {
        let parsedSys = getInDecimalPoints(value: (systolicBp as NSString).doubleValue)
        
        let currentSys = Int(sys)!
        let hypoSysGreenLim = parsedSys * 0.1
        
        let hyperSysOrangeLim = parsedSys * 0.2
        let p = ceil(hypoSysGreenLim)
        let c = ceil(hyperSysOrangeLim)
        
        let hypoSysOrangeValue = Double(systolicBp)! - p
        
        let hypoSysRedValue = Double(systolicBp)! - c
        
        
        let hyperSysOrangeValue = Double(systolicBp)! + p
        
        let hyperSysRedValue = Double(systolicBp)! + c
        
        PrintLog.print(hypoSysOrangeValue,hypoSysRedValue,hyperSysOrangeValue,hyperSysRedValue)
        if currentSys >= Int(hypoSysOrangeValue) && currentSys <= Int(hyperSysOrangeValue) {
            sysZoneValue = greenFlag
            systolicBpType = NORMAL
        }else if currentSys > Int(hyperSysOrangeValue) && currentSys <= Int(hyperSysRedValue) {
            sysZoneValue = orangeFlag
            systolicBpType = HYPER
        }else if currentSys >= Int(hypoSysRedValue) && currentSys < Int(hypoSysOrangeValue){
            sysZoneValue = orangeFlag
            systolicBpType = HYPO
        }else if currentSys > Int(hyperSysRedValue) {
            sysZoneValue = RedFlag
            systolicBpType = HYPER
        }else if currentSys < Int(hypoSysRedValue){
            sysZoneValue = RedFlag
            systolicBpType = HYPO
        }
        return sysZoneValue
    }
    
    func diaBloodPressure(dia : String) -> Int {
        let parsedDia = getInDecimalPoints(value: (diastolicBp as NSString).doubleValue)
        let currentDia = Int(dia)!
        
        let hypoDiaGreenLim = parsedDia * 0.1
        let hyperDiaOrangeLim = parsedDia * 0.2
        let p = ceil(hypoDiaGreenLim)
        let c = ceil(hyperDiaOrangeLim)
        
        let hypoDiaOrangeValue = Double(diastolicBp)! - p
        let hypoDiaRedValue = Double(diastolicBp)! - c
        let hyperDiaOrangeValue = Double(diastolicBp)! + p
        let hyperDiaRedValue = Double(diastolicBp)! + c
        PrintLog.print(hypoDiaOrangeValue,hypoDiaRedValue,hyperDiaOrangeValue,hyperDiaRedValue)
        
        if currentDia >= Int(hypoDiaOrangeValue) && currentDia <= Int(hyperDiaOrangeValue) {
            diaZoneValue = greenFlag
            diastolicBpType = NORMAL
        }else if currentDia > Int(hyperDiaOrangeValue) && currentDia <= Int(hyperDiaRedValue){
            diaZoneValue = orangeFlag
            diastolicBpType = HYPER
        }else if currentDia >= Int(hypoDiaRedValue) && currentDia < Int(hypoDiaOrangeValue){
            diaZoneValue = orangeFlag
            diastolicBpType = HYPO
        }else if currentDia > Int(hyperDiaRedValue){
            diaZoneValue = RedFlag
            diastolicBpType = HYPER
        }else if  currentDia < Int(hypoDiaRedValue){
            diaZoneValue = RedFlag
            diastolicBpType = HYPO
        }
        return diaZoneValue
    }
    
    func getBpType() -> String {
        print(systolicBpType, diastolicBpType)
        if systolicBpType == NORMAL && diastolicBpType == NORMAL {
            resultBpType = NORMAL
        }else if systolicBpType == HYPO && diastolicBpType == HYPO{
            resultBpType = HYPO
        }else if systolicBpType == HYPER && diastolicBpType == HYPER{
            resultBpType = HYPER
        }else if systolicBpType == NORMAL && diastolicBpType == HYPO{
            resultBpType = HYPO
        }else if systolicBpType == HYPO && diastolicBpType == NORMAL{
            resultBpType = HYPO
        }else if systolicBpType == NORMAL && diastolicBpType == HYPER{
            resultBpType = HYPER
        }else if systolicBpType == HYPER && diastolicBpType == NORMAL{
            resultBpType = HYPER
        }else{
            resultBpType = HYPER
        }
        return resultBpType
    }
}


