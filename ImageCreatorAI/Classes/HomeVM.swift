//
//  HomeVM.swift
//  ImageCreatorAI
//
//  Created by Nirzar Gandhi on 16/05/25.
//

import Foundation
import UIKit

protocol HomeVMDelegate: AnyObject {
    
    func showLoader()
    func hideLoader()
    func showErrorMsg(message: String?)
    func loadImage(imageData: Data?)
}


// MARK: - HomeVM
class HomeVM {
    
    // MARK: - Properties
    var delegate: HomeVMDelegate?
}


// MARK: - WebService Call
extension HomeVM {
    
    internal func getHomeData(text: String) {
        
        self.delegate?.showLoader()
        
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            self.delegate?.showErrorMsg(message: "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Constants.APIKey.ImageCreatorAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "prompt": text,
            "n": 1,
            "size": "512x512"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            self.delegate?.showErrorMsg(message: "Failed to encode JSON body.")
            return
        }
        
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            DispatchQueue.main.async {
                self.delegate?.hideLoader()
            }
            
            if let error = error {
                self.delegate?.showErrorMsg(message: "Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                self.delegate?.showErrorMsg(message: "No data received.")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let error = result?["error"] as? [String: Any] {
                    
                    self.delegate?.showErrorMsg(message: "API Error: \(error)")
                    
                } else if let dataArray = result?["data"] as? [[String: Any]],
                          let imageUrl = dataArray.first?["url"] as? String,
                          let url = URL(string: imageUrl) {
                    
                    self.loadImage(from: url)
                    
                } else {
                    
                    self.delegate?.showErrorMsg(message: "Unexpected response format.")
                }
                
            } catch {
                self.delegate?.showErrorMsg(message: "JSON decode error: \(error)")
            }
            
        }.resume()
    }
    
    fileprivate func loadImage(from url: URL) {
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            if let data = data {
                
                DispatchQueue.main.async {
                    self.delegate?.loadImage(imageData: data)
                }
                
            } else {
                self.delegate?.showErrorMsg(message: "Failed to load image")
            }
            
        }.resume()
    }
}
