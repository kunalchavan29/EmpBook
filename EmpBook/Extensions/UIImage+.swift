//
//  UIImage+.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import UIKit

extension UIImageView {
    func download(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill, placeholder: UIImage? = nil) {
        contentMode = mode
        image = placeholder
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error on download \(error ?? URLError(.badServerResponse))")
                return
            }
            guard 200 ..< 300 ~= response.statusCode else {
                print("statusCode != 2xx; \(response.statusCode)")
                return
            }
            guard let image = UIImage(data: data) else {
                print("not valid image")
                return
            }
            DispatchQueue.main.async {
                print("download completed \(url.lastPathComponent)")
                self.image = image
            }
        }.resume()
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}


extension UIView {
    func addShadow() {
        layer.cornerRadius = 20.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 12.0
        layer.shadowOpacity = 0.7
    }
}

class CardView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func commonInit() {
        addShadow()
    }
}
