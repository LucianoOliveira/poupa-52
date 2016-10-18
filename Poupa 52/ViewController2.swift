//
//  ViewController2.swift
//  Poupa 52
//
//  Created by Luciano Oliveira on 13/10/2016.
//  Copyright © 2016 Luciano Oliveira. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(data: String)
}

class ViewController2: UIViewController {
   
    @IBOutlet var valorPoupadoLabel : UILabel!
    @IBOutlet weak var poupaExtraText: UITextField!
    
    
    var semanasPagas :[Bool]=[]
    var semanaPrimeiroDia :[String]=[]
    let defaults = UserDefaults.standard
    var firstWeekDay=0
    var poupaExtra=0
    
    var delegate: DataSentDelegate? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initCalculations()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetSavings(_ sender: AnyObject) {
        resetSemanasPagas()
        poupaExtra=0
        defaults.set(poupaExtra, forKey: "poupaExtra")
        poupaExtraText.text=String(poupaExtra)
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
    }
    
    @IBAction func pouparExtra(_ sender: AnyObject) {
        poupaExtra=Int(poupaExtraText.text!)!
        defaults.set(poupaExtra, forKey: "poupaExtra")
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        
        
    }
    
    @IBAction func returnMainView(_ sender: AnyObject) {
        if delegate != nil{
            let data = "Back"
            delegate?.userDidEnterData(data: data)
            dismiss(animated: true, completion: nil)
            //self.navigationController?.popViewController(animated: true)
        }
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
        poupaExtraText.text=String(poupaExtra)
        
        
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
        
        
        var calender = Calendar.current
        
        //Conseguir o primeiro dia da semana
        obterPrimeiroDiaDeSemana()
        calender.firstWeekday=firstWeekDay
        
        
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        
        
        
    }

    func resetSemanasPagas() {
        for index in 1...52 {
            semanasPagas[index]=false
        }
        defaults.set(semanasPagas, forKey: "semanasPagas")
        
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
    
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
