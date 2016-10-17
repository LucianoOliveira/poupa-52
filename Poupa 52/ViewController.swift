//
//  ViewController.swift
//  Poupa 52
//
//  Created by Luciano Oliveira on 06/08/16.
//  Copyright © 2016 Luciano Oliveira. All rights reserved.
//

import UIKit
import Foundation

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
    
    var semanasPagas :[Bool]=[]
    var semanaPrimeiroDia :[String]=[]
    let defaults = UserDefaults.standard
    var firstWeekDay=0
    var poupaExtra=0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        initCalculations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sem0Poupar (_ sender : AnyObject) {
        let index:Int? = Int(sem0Num.text!)
        
        //com o numero do index por a true a semana onde o pagamento foi feito
        semanasPagas[index!]=true
        defaults.set(semanasPagas, forKey: "semanasPagas")
        
        //correr a função que recalcula o valor poupado
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        getSem0Data()
        
        
    }
    
    @IBAction func sem1Poupar (_ sender : AnyObject) {
        let index:Int? = Int(sem1Num.text!)
        
        //com o numero do index por a true a semana onde o pagamento foi feito
        semanasPagas[index!]=true
        defaults.set(semanasPagas, forKey: "semanasPagas")
        
        //correr a função que recalcula o valor poupado
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        sem1PouparButton.setTitle("Já Poupado", for: UIControlState.normal)
        sem1PouparButton.isUserInteractionEnabled=false
        sem1PouparButton.isEnabled=false
        
        
    }
    
    @IBAction func sem2Poupar(_ sender: AnyObject) {
        let index:Int? = Int(sem2Num.text!)
        
        //com o numero do index por a true a semana onde o pagamento foi feito
        semanasPagas[index!]=true
        defaults.set(semanasPagas, forKey: "semanasPagas")
        
        //correr a função que recalcula o valor poupado
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        getSem2Data()

    }
    
    
    func initCalculations() {
        
        
        //Defenições das datas
        let dataHoje = Date()
        let calendario = Calendar.current
        
        //Obter ano corrente
        let ano = (calendario as NSCalendar).component(NSCalendar.Unit.year, from: dataHoje)

        
        let defaultsAno = defaults.integer(forKey:"savedYear")
        
        if (defaults.object(forKey: "poupaExtra") != nil) {
            poupaExtra=defaults.integer(forKey: "poupaExtra")
        }
        else
        {
            poupaExtra=0
            defaults.set(poupaExtra, forKey: "poupaExtra")
        }
        
        //Se ano igual ao já gravado não faz nada... caso contrario inicializa os arrays
        if  ano == defaultsAno {
            
            if (defaults.object(forKey: "semanasPagas") != nil)
            {
                semanasPagas = defaults.object(forKey: "semanasPagas") as! [Bool]
            }
            else
            {
                initSemanasPagas()
            }
            
            if (defaults.object(forKey: "semanaPrimeiroDia") != nil)
            {
                semanaPrimeiroDia = defaults.object(forKey: "semanaPrimeiroDia") as! [String]
            }
            else
            {
                initSemanaPrimeiroDia()
            }

        }
        else{
            defaults.set(ano, forKey: "savedYear")
            
            initSemanasPagas()
            initSemanaPrimeiroDia()
            
        }
        
        
        
        let currentDate=Date()
        var calender = Calendar.current
        
        //Conseguir o primeiro dia da semana
        obterPrimeiroDiaDeSemana()
        calender.firstWeekday=firstWeekDay
        
        let week1 = (calender as NSCalendar).component(NSCalendar.Unit.weekOfYear, from: currentDate)
        
        
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        
        sem1Num.text=String(week1);
        sem1Inicio.text=String(semanaPrimeiroDia[week1])
        sem1Valor.text=String(week1)+"€"
        
        //se semana ja foi poupada não permite carregar no botão poupar
        if semanasPagas[week1]==true {
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
        
        getSem0Data()
        getSem2Data()
        
    }
    
    func initSemanasPagas() {
        for _ in 0...52{
            semanasPagas.append(false)
        }
        defaults.set(semanasPagas, forKey: "semanasPagas")
    }
    
    func initSemanaPrimeiroDia() {
        //Defenições das datas
        let dF = DateFormatter()
        let dataHoje = Date()
        let calendario = Calendar.current
        
        //Obter ano corrente
        let ano = (calendario as NSCalendar).component(NSCalendar.Unit.year, from: dataHoje)
        
        var primeiroDiaDoAno=DateComponents()
        primeiroDiaDoAno.year=ano;
        primeiroDiaDoAno.month=1;
        primeiroDiaDoAno.day=1;
        let dataPrimeiroDiaDoAno=calendario.date(from: primeiroDiaDoAno)
        let primeiroDiaDeSemana=(calendario as NSCalendar).component(NSCalendar.Unit.weekday, from: dataPrimeiroDiaDoAno!)
        semanaPrimeiroDia.append("00-00-0000")
        for index in 1...52{
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
            
            semanaPrimeiroDia.append(weekString)
            
        }
        defaults.set(semanaPrimeiroDia, forKey: "semanaPrimeiroDia")
    }
    
    func calculaValorPoupado()->Int {
        var valorPoupado=0
        for index in 1...52{
            if semanasPagas[index]==true {
                valorPoupado=valorPoupado+index;
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
                if semanasPagas[semana0]==false {
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
            sem0Inicio.text=String(semanaPrimeiroDia[sem0])
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
                if semanasPagas[semana2]==false{
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
            sem2Inicio.text=String(semanaPrimeiroDia[sem2])
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
        initCalculations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVC2" {
            let VC2: ViewController2 = segue.destination as! ViewController2
            VC2.delegate=self
        }
    }

}

