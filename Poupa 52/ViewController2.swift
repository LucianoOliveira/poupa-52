//
//  ViewController2.swift
//  Poupa 52
//
//  Created by Luciano Oliveira on 13/10/2016.
//  Copyright © 2016 Luciano Oliveira. All rights reserved.
//

import UIKit
import CoreData

protocol DataSentDelegate {
    func userDidEnterData(data: String)
}

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
   
    @IBOutlet var valorPoupadoLabel : UILabel!
    @IBOutlet weak var poupaExtraText: UITextField!
    @IBOutlet weak var tableViewVC2: UITableView!
    
    
    var semanasPagas :[Bool]=[]
    var semanaPrimeiroDia :[String]=[]
    var firstWeekDay=0
    var poupaExtra=0.00
    
    var items: [Semanas] = []
    var opcoes: [Options] = []
    
    var delegate: DataSentDelegate? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshValorPoupado), name: NSNotification.Name(rawValue: "refresh"), object: nil)

        tableViewVC2.delegate = self
        tableViewVC2.dataSource = self
        // Do any additional setup after loading the view.
        initCalculations()
        getData()
        
        
        loadTableView()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController2.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetSavings(_ sender: AnyObject) {
        CRUD().resetSemanas()
        opcoes[0].extraPoupado = 0.00
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        getData()
        
        poupaExtra=0.00
        poupaExtraText.text=String(poupaExtra)
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        
        tableViewVC2.reloadData()
    }
    
    @IBAction func pouparExtra(_ sender: AnyObject) {
        poupaExtra=Double(poupaExtraText.text!)!
        opcoes[0].extraPoupado = Double(poupaExtra)
        //save new data object in core data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        getData()
        
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
        
        getData()
        
        poupaExtraText.text=String(opcoes[0].extraPoupado)
        
        var calender = Calendar.current
        
        //Conseguir o primeiro dia da semana
        obterPrimeiroDiaDeSemana()
        calender.firstWeekday=firstWeekDay
        
        
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
        tableViewVC2.reloadData()
        
        
        
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
    
    private func getData(){
        getOptions()
        getItems()
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
        poupaExtra = opcoes[0].extraPoupado
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
    
    private func loadTableView(){
        let currentDate=Date()
        let calender = Calendar.current
        let week1 = (calender as NSCalendar).component(NSCalendar.Unit.weekOfYear, from: currentDate)
        let index = IndexPath(row: week1-1, section: 0)
        self.tableViewVC2.scrollToRow(at: index, at: .top, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getData()
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell1", for: indexPath)
        let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
        let row = indexPath.row
        cell.semanaText.text = items[row].primeiroDia
        cell.valueText.text = String(items[row].semanaNum)+"€"
        cell.valueSemana.text = String(items[row].semanaNum)
        if items[row].semanaPaga {
            cell.statusText.text = "Poupado"
            cell.buttonOutlet.setTitle("Apagar", for: .normal)
            cell.imageCell.backgroundColor = UIColor(red: 144/255, green: 190/255, blue: 173/255, alpha: 1)
        }
        else{
            cell.statusText.text = "Não Poupado"
            cell.buttonOutlet.setTitle("Poupar", for: .normal)
            cell.imageCell.backgroundColor = UIColor(red: 0, green: 128/255, blue: 255/255, alpha: 1)
        }
        cell.imageCell.layer.cornerRadius = cell.imageCell.frame.size.width/2
        cell.imageCell.clipsToBounds = true
        
        
        return cell
    }
    
    func refreshValorPoupado() {
        getData()
        valorPoupadoLabel.text="Valor Poupado "+String(calculaValorPoupado())+"€"
    }
    
    @objc func dismissKeyboard(){
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
