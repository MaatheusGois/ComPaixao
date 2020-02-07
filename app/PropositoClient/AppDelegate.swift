//
//  AppDelegate.swift
//  PropositoClient
//
//  Created by Matheus Gois on 01/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.applicationIconBadgeNumber = 0
        Switcher.updateRootVC()
        sleep(1)
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) { }
    func applicationDidEnterBackground(_ application: UIApplication) { }
    func applicationWillEnterForeground(_ application: UIApplication) { }
    func applicationDidBecomeActive(_ application: UIApplication) { }
    func applicationWillTerminate(_ application: UIApplication) { }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //Quando a notificacao é enviada
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler
                                completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        //Aqui definimos que a notificação deve gerar um alerta com som
        completionHandler([.alert, .sound])
    }
    //Quando a notificacao é respondida
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //Chamando identificador de ações
        let identificador = response.actionIdentifier
        //Pegando a resposta da notificação pela resposta da ação
        if identificador == "Soneca"{
            print("Deixa eu dormir mais um pouquinho!")
        } else if identificador == "Desligar" {
            print("Ahhh, vou chegar atrasado mesmo!")
        }
        //Não há retorno
        completionHandler()
    }
    func enviarNotificacao(_ titulo: String,
                           _ subtitulo: String,
                           _ mensagem: String,
                           _ identificador: String,
                           _ tempo: TimeInterval) {
        //Essa instancia de classe é necessária para criar o corpo da notificação
        let contexto = UNMutableNotificationContent()
        //Criando corpo da notificação
        contexto.title = titulo
        contexto.subtitle = subtitulo
        contexto.body = mensagem
        contexto.sound = UNNotificationSound.default
        contexto.badge = 1
        contexto.categoryIdentifier = identificador
        //Colocando a imgem de fundo
        let nomeDaImagem = "logo"
        //Aqui verificamos se a mensagem realmente existe, caso ela não exista ele para a função a retornando.
        guard let imageURL = Bundle.main.url(forResource: nomeDaImagem, withExtension: "png") else { return }
        //Anexando a imagem
        do {
            let anexo = try UNNotificationAttachment(identifier: nomeDaImagem, url: imageURL, options: .none)
            contexto.attachments = [anexo]
        } catch {
            NSLog(error.localizedDescription)
        }
        //Criando a requisição
        let gatilho = UNTimeIntervalNotificationTrigger(timeInterval: tempo, repeats: false)
        let requisicao = UNNotificationRequest(identifier: identificador, content: contexto, trigger: gatilho)
        //Adicionando a requisição ao nosso centro de notificações
        notificationCenter.add(requisicao) { (error) in
            if let error = error {
                print("Deu ruim: \(error.localizedDescription)")
            }
        }
        //Criando os botões de ações
        let acaoDeSoneca = UNNotificationAction(identifier: "Soneca", title: "Soneca", options: [])
        let acaoDeDesligar = UNNotificationAction(identifier: "Desligar", title: "Desligar", options: [.destructive])
        let categoria = UNNotificationCategory(identifier: identificador,
                                               actions: [acaoDeSoneca, acaoDeDesligar],
                                               intentIdentifiers: [],
                                               options: [])
        //Adicionando as ações ao nosso centro de notificações
        notificationCenter.setNotificationCategories([categoria])
    }
}
