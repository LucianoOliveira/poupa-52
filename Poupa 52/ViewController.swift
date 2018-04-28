//
//  ViewController.swift
//  Poupa 52
//
//  Created by Luciano Oliveira on 06/08/16.
//  Copyright © 2016 Luciano Oliveira. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, DataSentDelegate {
    
    //we need to add a transition effect for the (i) button
    //www.hackingwithswift.com/example-code/uikit/how-to-flip-a-uiview-with-a-3d-effect-transitionwith

    
    @IBOutlet var valorPoupadoLabel : UILabel!
    @IBOutlet var sem0Num : UILabel!
    @IBOutlet var sem0Inicio : UILabel!
    @IBOutlet var sem0Valor : UILabel!
    @IBOutlet var sem1Num : UILabel!
    @IBOutlet var sem1Inicio : UILabel!
    @IBOutlet var sem1Valor : UILabel!
    @IBOutlet var sem2Num : UILabel!
    @IBOutlet var sem2Inicio : UILabel!
    @IBOutlet var sem2Valor : UILabel!
    @IBOutlet var sem0PouparButton : UIButton!
    @IBOutlet var sem1PouparButton : UIButton!
    @IBOutlet var sem2PouparButton: UIButton!
    
    var items: [Semanas] = []
    var opcoes: [Options] = []
    
    var semanasPagas :[Bool]=[]
    var semanaPrimeiroDia :[String]=[]
    var firstWeekDay=0
    var poupaExtra=0.00

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        InitCalculations().startCalc()
        getData()
        loadButoes()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func sem0Poupar (_ sender : AnyObject) {
        let index:Int? = Int(sem0Num.text!)
        
        //com o numero do index por a true a semana onde o pagamento foi feito
        items[index!-1].semanaPaga = true
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
        
        //correr a função que recalcula o valor poupado
        valorPoupadoLabel.text=""+String(calculaValorPoupado())+"€"
        getSem0Data()
        
        
    }
    
    @IBAction func sem1Poupar (_ sender : AnyObject) {
        let index:Int? = Int(sem1Num.text!)
        
        //com o numero do index por a true a semana onde o pagamento foi feito
        items[index!-1].semanaPaga = true
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        //correr a função que recalcula o valor poupado
        valorPoupadoLabel.text=""+String(calculaValorPoupado())+"€"
        sem1PouparButton.setTitle("Já Poupado", for: UIControlState.normal)
        sem1PouparButton.isUserInteractionEnabled=false
        sem1PouparButton.isEnabled=false
        
        
    }
    
    @IBAction func sem2Poupar(_ sender: AnyObject) {
        let index:Int? = Int(sem2Num.text!)
        
        //com o numero do index por a true a semana onde o pagamento foi feito
        items[index!-1].semanaPaga = true
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        
        //correr a função que recalcula o valor poupado
        valorPoupadoLabel.text=""+String(calculaValorPoupado())+"€"
        getSem2Data()

    }
    
    func getData(){
        getOptions()
        getItems()
    }
    
    func calculaValorPoupado()->Double {
        var valorPoupado=0.00
        for index in 0...51{
            if items[index].semanaPaga==true {
                valorPoupado=valorPoupado+Double(index+1);
            }
        }
        valorPoupado = valorPoupado+poupaExtra
        return valorPoupado
    }
    
    
    func getSem0Data() {
        let currentDate=Date()
        var calender = Calendar.current
        obterPrimeiroDiaDeSemana()
        calender.firstWeekday=firstWeekDay
        let semana1 = (calender as NSCalendar).component(NSCalendar.Unit.weekOfYear, from: currentDate)
        
        var sem0=0;
        
        if semana1>1 {
            var semana0=semana1-1
            while sem0==0 && semana0>0{
                if items[semana0-1].semanaPaga==false {
                    //esta é a semana 0 que temos de mostrar
                    sem0=semana0;
                }
                else
                {
                    semana0=semana0-1;
                }
            }
            

        }
        
        //Se sem0 é 0 não apresentar nada
        //Caso contrario preencher com os dados da semana 0
        if sem0 != 0
        {
            sem0Num.text=String(sem0)
            sem0Inicio.text=items[sem0-1].primeiroDia
            sem0Valor.text=String(sem0)+"€"
            sem0PouparButton.isUserInteractionEnabled=true
            sem0PouparButton.isEnabled=true
        }
        else
        {
            sem0Num.text=""
            sem0Inicio.text=""
            sem0Valor.text=""
            sem0PouparButton.isUserInteractionEnabled=false
            sem0PouparButton.isEnabled=false
        }
        
        
    }
    
    private func getSem1Data(){
        let currentDate=Date()
        let calender = Calendar.current
        let week1 = (calender as NSCalendar).component(NSCalendar.Unit.weekOfYear, from: currentDate)
        
        
        valorPoupadoLabel.text=""+String(calculaValorPoupado())+"€"
        
        sem1Num.text=String(week1);
        sem1Inicio.text=items[week1-1].primeiroDia
        sem1Valor.text=String(week1)+"€"
        
        //se semana ja foi poupada não permite carregar no botão poupar
        if items[week1-1].semanaPaga==true {
            sem1PouparButton.setTitle("Já Poupado", for: UIControlState.normal)
            sem1PouparButton.isUserInteractionEnabled=false
            sem1PouparButton.isEnabled=false
            
            
        }
        else
        {
            sem1PouparButton.setTitle("Poupar", for: UIControlState.normal)
            sem1PouparButton.isUserInteractionEnabled=true
            sem1PouparButton.isEnabled=true
        }        
    }
    
    func getSem2Data() {
        let currentDate=Date()
        var calender = Calendar.current
        obterPrimeiroDiaDeSemana()
        calender.firstWeekday=firstWeekDay
        let semana1 = (calender as NSCalendar).component(NSCalendar.Unit.weekOfYear, from: currentDate)
        
        var sem2=0
        
        if semana1<53
        {
            var semana2=semana1+1
            while sem2==0 && semana2<53
            {
                if items[semana2-1].semanaPaga==false{
                    sem2=semana2
                }
                else{
                    semana2=semana2+1
                }
            }
        }
        
        //Se sem2 é 0 não apresentar nada
        //Caso contrario preencher com os dados da semana2
        if sem2 != 0
        {
            sem2Num.text=String(sem2)
            sem2Inicio.text=items[sem2-1].primeiroDia
            sem2Valor.text=String(sem2)+"€"
            sem2PouparButton.isUserInteractionEnabled=true
            sem2PouparButton.isEnabled=true
        }
        else
        {
            sem2Num.text=""
            sem2Inicio.text=""
            sem2Valor.text=""
            sem2PouparButton.isUserInteractionEnabled=false
            sem2PouparButton.isEnabled=false
        }
    }
    
    func obterPrimeiroDiaDeSemana() {
        
        //Defenições das datas
        let dataHoje = Date()
        let calendario = Calendar.current
        
        //Obter ano corrente
        let ano = (calendario as NSCalendar).component(NSCalendar.Unit.year, from: dataHoje)
        
        var primeiroDiaDoAno=DateComponents()
        primeiroDiaDoAno.year=ano;
        primeiroDiaDoAno.month=1;
        primeiroDiaDoAno.day=1;
        let dataPrimeiroDiaDoAno=calendario.date(from: primeiroDiaDoAno)
        firstWeekDay=(calendario as NSCalendar).component(NSCalendar.Unit.weekday, from: dataPrimeiroDiaDoAno!)
        
        
    }
    
    func userDidEnterData(data: String) {
        InitCalculations().startCalc()
        getData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVC2" {
            let VC2: ViewController2 = segue.destination as! ViewController2
            VC2.delegate=self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        InitCalculations().startCalc()
        getData()
        loadButoes()
    }
    
    private func getOptions(){
        //Get context of core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //fill array items with all the items in core data
        do {
            try opcoes = context.fetch(Options.fetchRequest())
        } catch  {
            print("Error while catching from CoreData")
        }
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
    
    private func loadButoes(){
        getSem1Data()
        getSem0Data()
        getSem2Data()
    }

}

