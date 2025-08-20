import Foundation
import UserNotifications

final class NotificationService: NSObject {
    static let shared = NotificationService()
    override private init() {}

    // Llama una sola vez al iniciar la app
    func configure() {
        UNUserNotificationCenter.current().delegate = self
    }

    // Pide permisos (hazlo una vez al inicio)
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    // Enviar notificación inmediata
    func notify(title: String, body: String, id: String = UUID().uuidString) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

// Mostrar banner/sonido también con la app en foreground
extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent _: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.banner, .list, .sound])
    }
}
