//
//  ViewController.swift
//  StanfordCalculator
//
//  Created by Will Xavier on 12/24/15.
//  Copyright (c) 2015 Will Xavier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var display: UILabel!
    
    //Flag para saber se o usuário está digitando
    var userTypingANumber = false
    
    var operandStack = Array<Double>()
    
    //Criando um valor para a tela em Double
    //Getters e Setters em Swift é implicito, dessa forma isso será chamado pelo próprio compilador
    var displayValue: Double{
        get{
            //Retorna o valor convertido de String para Double
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            //Cria um novo valor
            display.text = "\(newValue)"
        }
        
    }
    
    @IBAction func Operator(sender: AnyObject) {
        let operation = sender.currentTitle!
        if userTypingANumber {
            enter()
        }
        switch operation!{
            //Basicamente rola uma magia negra do compilador Swift aqui, caso sua função seja bem feita o compulador vai entender que ela recebe dois argumentos de um tipo e retorna um valor de um tipo. Dessa forma não é necessário nomeá-los ou mesmo colocar dentro dos parênteses da função, o complilador irá entender de toda forma.
            case "✕" : performOperation {$0 * $1}
            //Aqui eu coloquei um método a parte (Que segue basicamente o mesmo esquema) porque na divisão o número pode dar infinito e o erro é pego pela IDE, dando crash. Na função externa trato isso de forma a aparecer no display NaN "Not a Number".
            case "÷" : performOperation(divide)
            case "+" : performOperation {$0 + $1}
            //Temos na divisão e na subtração os dados invertidos, porque damos como base uma pilha de expressões, assim, usando o ultimo como o quociente na divisão e não como dividendo. Analogamente fazemos o mesmo com subtração.
            case "−" : performOperation {$1 - $0}
            //Mesmo esquema de compilador inteligente, basicamente você dar override num método e o compilador irá entender o momento de usar cada um, é parecido com Java, só que mais inteligente XD
            case "√" : performOperation {sqrt($0)}
            default : break
        }
    }
    //I have no idea why, mas o swift não tinha aceitado o poliformismo, então tive que colocar esse private, pelas minhas pesquisas, é um conflito com o Objective-C que não tem poliformismo
    private func performOperation(operation : Double -> Double){
        if(operandStack.count >= 1){
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    
     func performOperation(operation : (Double, Double) -> Double){
        if(operandStack.count >= 2){
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func divide(primeiroValor : Double, segundoValor: Double)->Double{
        var retorno = 0.0
        if(primeiroValor == 0){
            display.text = "NaN"
            retorno = 0.0
        }else{
            retorno = segundoValor / primeiroValor
        }
        return retorno
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        //Testamos se o usuário está digitando
        if userTypingANumber {
            display.text! += digit
        }else{
            display.text! = digit
            userTypingANumber = true
        }
    }

    @IBAction func clearStack() {
        operandStack.removeAll(keepCapacity: true)
        userTypingANumber = false
        display.text = "0"
        println("Pilha de dados: \(operandStack)")
    }
    @IBAction func enter() {
        operandStack.append(displayValue)
        userTypingANumber = false
        println(operandStack)
    }
}

