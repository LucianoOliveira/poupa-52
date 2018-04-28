//
//  InitCalculations.swift
//  Poupa 52
//
//  Created by Luciano Oliveira on 26/04/2018.
//  Copyright © 2018 Luciano Oliveira. All rights reserved.
//

import UIKit
import CoreData

class InitCalculations: NSObject {
    
    private var items: [Semanas] = []
    private var opcoes: [Options] = []
    
    func startCalc(){
        //Check if we have options
        if !haveOptions() {
            //If no create new options
                //Year
                //Extra saved
            createOptions()
            //Create new semanas
            createSemanas()
            
        }
        else{
            //If yes check if Year is current
            if !currentYear(){
                //If no create new semanas
                createSemanas()
            }
            else{
                //Create semanas again if there are less than 52 weeks
                if getSemanasCount()<52{
                    CRUD().resetSemanas()
                }
                
            }
            
        }
    }
    
    
    
    private func haveOptions()->Bool{
        //Get context of core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //fill array items with all the items in core data
        do {
            try opcoes = context.fetch(Options.fetchRequest())
        } catch  {
            print("Error while trying to find Options on CoreData")
            return false
        }
        if opcoes.count>0 {
            return true
        }
        else{
            return false
        }
    }
    
    private func currentYear()->Bool{
        //Defenições das datas
        let dataHoje = Date()
        let calendario = Calendar.current
        
        //Obter ano corrente
        let yearToCheck = (calendario as NSCalendar).component(NSCalendar.Unit.year, from: dataHoje)
        
        if yearToCheck == opcoes[0].ano {
            return true
        }
        else{
            return false
        }
    }
    
    private func createOptions(){
        //Defenições das datas
        let dataHoje = Date()
        let calendario = Calendar.current
        
        //Obter ano corrente
        let yearToCheck = (calendario as NSCalendar).component(NSCalendar.Unit.year, from: dataHoje)
        
        
        //Get context of core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //Create new object of type entity in the core data
        let opcoesCtx = Options(context: context)
        opcoesCtx.ano = Int16(yearToCheck)
        opcoesCtx.extraPoupado = 0
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    private func createSemanas(){
        
        
        //Obter ano corrente
        let dF = DateFormatter()
        let dataHoje = Date()
        let calendario = Calendar.current
        let ano = (calendario as NSCalendar).component(NSCalendar.Unit.year, from: dataHoje)
        
        var primeiroDiaDoAno=DateComponents()
        primeiroDiaDoAno.year=ano;
        primeiroDiaDoAno.month=1;
        primeiroDiaDoAno.day=1;
        let dataPrimeiroDiaDoAno=calendario.date(from: primeiroDiaDoAno)
        let primeiroDiaDeSemana=(calendario as NSCalendar).component(NSCalendar.Unit.weekday, from: dataPrimeiroDiaDoAno!)
        for index in 1...52{
            //Get context of core data
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            //Create new object of type entity in the core data
            let item = Semanas(context: context)
            
            var weekComponents = DateComponents()
            
            if index==1 {
                weekComponents.year=ano
                weekComponents.month=1;
                weekComponents.weekday=primeiroDiaDeSemana+1;
            }
            else
            {
                weekComponents.year=ano
                weekComponents.weekOfYear=index;
                weekComponents.weekday=primeiroDiaDeSemana;
            }
            
            let weekFirstDay=calendario.date(from: weekComponents)!
            var weekString: String
            dF.dateFormat="dd-MM-YYYY"
            weekString=dF.string(from: weekFirstDay)
            
            item.primeiroDia=weekString
            item.semanaPaga = false
            item.semanaNum = Int16(index)
            
            //save new data object in core data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        }
    }
    
    private func getSemanasCount()->Int{
        //Get context of core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //fill array items with all the items in core data
        do {
            try items = context.fetch(Semanas.fetchRequest())
            return items.count
        } catch  {
            print("Error while trying to find Semanas on CoreData")
            return 0
        }
        
        
    }

}
