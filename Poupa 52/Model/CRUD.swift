//
//  CRUD.swift
//  Poupa 52
//
//  Created by Luciano Oliveira on 26/04/2018.
//  Copyright © 2018 Luciano Oliveira. All rights reserved.
//

import UIKit
import CoreData

class CRUD: NSObject {
    
    private var items: [Semanas] = []
    private var opcoes: [Options] = []

    func newYear(ano: Int){
        //save new year
        opcoes[0].ano = Int16(ano)
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //Apaga todas as semanas
        deleteSemanas()
        
        //Insere as novas semanas
        insertSemanas()
        
    }
    
    func retiraPouparSemana(week: Int){
        getItems()
        items[week-1].semanaPaga=false
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func poupaSemana(week: Int){
        getItems()
        items[week-1].semanaPaga=true
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func resetSemanas(){
        //Apaga todas as semanas
        deleteSemanas()
        
        //Insere as novas semanas
        insertSemanas()
    }
    
    private func getItems(){
        //Get context of core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //fill array items with all the items in core data
        do {
            try items = context.fetch(Semanas.fetchRequest())
        } catch  {
            print("Error while catching from CoreData")
        }
    }
    
    private func deleteSemanas(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Semanas")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    private func insertSemanas(){
        
        
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
        //semanaPrimeiroDia.append("00-00-0000")
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
    
}
