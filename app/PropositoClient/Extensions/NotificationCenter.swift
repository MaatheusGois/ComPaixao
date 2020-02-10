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
        let uuid = response.notification.request.identifier
        let type = response.notification.request.content.categoryIdentifier
        if type == "action" {
            if response.actionIdentifier == "done" {
                ActionHandler.done(uuid: uuid) { (response) in
                    switch response {
                    case .error(let description):
                        NSLog(description)
                    case .success(_:):
                        EventManager.shared.trigger(eventName: "reloadAction")
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    }
                }
            } else {
                ActionHandler.getOne(uuid: uuid) { (response) in
                    switch response {
                    case .error(let description):
                        NSLog(description)
                    case .success(let action):
                        EventManager.shared.trigger(eventName: "toActionDetail", information: action)
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    }
                }
            }
        } else if type == "prayer" {
            if response.actionIdentifier == "done" {
                PrayerHandler.done(uuid: uuid) { (response) in
                    switch response {
                    case .error(let description):
                        NSLog(description)
                    case .success(_:):
                        EventManager.shared.trigger(eventName: "reloadPrayer")
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    }
                }
            } else {
                PrayerHandler.getOne(uuid: uuid) { (response) in
                    switch response {
                    case .error(let description):
                        NSLog(description)
                    case .success(let prayer):
                        EventManager.shared.trigger(eventName: "toPrayerDetail", information: prayer)
                        UIApplication.shared.applicationIconBadgeNumber -= 1
                    }
                }
            }
        }
        completionHandler()
    }
    func enviarNotificacao(titulo: String,
                           subtitulo: String,
                           mensagem: String,
                           identificador: String,
                           type: String,
                           timeInterval: TimeInterval,
                           repeats: Bool) {
        //Essa instancia de classe é necessária para criar o corpo da notificação
        let contexto = UNMutableNotificationContent()
        //Criando corpo da notificação
        contexto.title = titulo != "" ? titulo : "Sem título"
        contexto.subtitle = subtitulo
        contexto.body = mensagem
        contexto.sound = .default
        print(UIApplication.shared.applicationIconBadgeNumber)
        contexto.badge = 1 as NSNumber
        contexto.categoryIdentifier = type
        //Colocando a imgem de fundo
        let imageName = !Global.isDark ? "logo" : "logo_dark"
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
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false) //TODO: - Alertas nunca repetem
        let requisicao = UNNotificationRequest(identifier: identificador, content: contexto, trigger: trigger)
        //Adicionando a requisição ao nosso centro de notificações
        notificationCenter.add(requisicao) { (error) in
            if let error = error {
                NSLog("Deu ruim: \(error.localizedDescription)")
            }
        }
        //Criando os botões de ações
        let done = UNNotificationAction(identifier: "done", title: "Concluir", options: [])
        let categoria = UNNotificationCategory(identifier: identificador,
                                               actions: [done],
                                               intentIdentifiers: [],
                                               options: [])
        //Adicionando as ações ao nosso centro de notificações
        notificationCenter.setNotificationCategories([categoria])
    }
}
