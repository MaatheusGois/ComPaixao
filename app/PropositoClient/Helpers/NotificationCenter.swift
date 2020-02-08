//
//  NotificationCenter.swift
//  PropositoClient
//
//  Created by Matheus Silva on 07/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit
import UserNotifications
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
    func enviarNotificacao(titulo: String,
                           subtitulo: String,
                           mensagem: String,
                           identificador: String,
                           timeInterval: TimeInterval,
                           repeats: Bool) {
        //Essa instancia de classe é necessária para criar o corpo da notificação
        let contexto = UNMutableNotificationContent()
        //Criando corpo da notificação
        contexto.title = titulo
        contexto.subtitle = subtitulo
        contexto.body = mensagem
        contexto.sound = UNNotificationSound.default
        contexto.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        contexto.categoryIdentifier = identificador
        //Colocando a imgem de fundo
        let imageName = Global.isDark ? "logo" : "logo_dark"
        //Aqui verificamos se a mensagem realmente existe, caso ela não exista ele para a função a retornando.
        if let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") {
            //Anexando a imagem
            do {
                let anexo = try UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
                contexto.attachments = [anexo]
            } catch {
                NSLog(error.localizedDescription)
            }
        }
        //Criando a requisição
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let requisicao = UNNotificationRequest(identifier: identificador, content: contexto, trigger: trigger)
        //Adicionando a requisição ao nosso centro de notificações
        notificationCenter.add(requisicao) { (error) in
            if let error = error {
                print("Deu ruim: \(error.localizedDescription)")
            }
        }
        //Criando os botões de ações
        let done = UNNotificationAction(identifier: "done", title: "Feito", options: [])
        let todo = UNNotificationAction(identifier: "todo", title: "Me lembre mais tarde", options: [.destructive])
        let categoria = UNNotificationCategory(identifier: identificador,
                                               actions: [done, todo],
                                               intentIdentifiers: [],
                                               options: [])
        //Adicionando as ações ao nosso centro de notificações
        notificationCenter.setNotificationCategories([categoria])
    }
}
