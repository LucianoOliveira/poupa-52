//: Playground - noun: a place where people can play

import UIKit



var semanasPagas = [Int: Bool]()
for index in 1...52{
    semanasPagas[index]=false
}

//Defenições das datas
let dF = DateFormatter()
let dataHoje = Date()
let calendario = Calendar.current

//Obter ano corrente
var ano = (calendario as NSCalendar).component(NSCalendar.Unit.year, from: dataHoje)


//Obter weekday do dia 1 de janeiro do ano corrente
var primeiroDiaDoAno=DateComponents()
primeiroDiaDoAno.year=ano;
primeiroDiaDoAno.month=1;
primeiroDiaDoAno.day=1;
let dataPrimeiroDiaDoAno=calendario.date(from: primeiroDiaDoAno)
let primeiroDiaDeSemana=(calendario as NSCalendar).component(NSCalendar.Unit.weekday, from: dataPrimeiroDiaDoAno!)




var semanaPrimeiroDia = [Int: String]()
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
    
    semanaPrimeiroDia[index]=weekString
    
}

semanaPrimeiroDia[1]
