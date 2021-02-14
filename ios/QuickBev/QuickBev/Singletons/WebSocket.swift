//
//  WebSocket.swift
//  QuickBev
//
//  Created by Peter Vail Driscoll II on 2/11/21.
//  Copyright © 2021 Peter Vail Driscoll II. All rights reserved.
//
//
//
//import Foundation
//
//protocol WebSocketConnection {
//    func send(text: String)
//    func send <Body:Encodable>(data: Body)
//    func connect()
//    func disconnect()
//    var delegate: WebSocketConnectionDelegate? {
//        get
//        set
//    }
//}
//
//protocol WebSocketConnectionDelegate {
//    func onConnected(connection: WebSocketConnection)
//    func onDisconnected(connection: WebSocketConnection, error: Error?)
//    func onError(connection: WebSocketConnection, error: Error)
//    func onMessage(connection: WebSocketConnection, text: String)
//    func onMessage(connection: WebSocketConnection, data: Data)
//}
//
//class WebSocketTaskConnection: NSObject, WebSocketConnection, URLSessionWebSocketDelegate {
//    var delegate: WebSocketConnectionDelegate?
//    private var webSocketTask: URLSessionWebSocketTask!
//    private var urlSession: URLSession!
//    private let delegateQueue = OperationQueue()
//    private var isConnected = false
//    private override init() {
//        super.init()
//        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
//        print("URL ws://localhost:8765", URL(string: "ws://localhost:8765")! as URL)
//        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://localhost:5000")!)
//    }
//    
//    static let shared = WebSocketTaskConnection()
//    
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        self.delegate?.onConnected(connection: self)
//    }
//    
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        self.delegate?.onDisconnected(connection: self, error: nil)
//    }
//    
//    func connect() {
//        if isConnected{
//            self.disconnect()
//            isConnected = false
//        }
//        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
//        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://localhost:5000")!)
//        webSocketTask.resume()
//        listen()
//        isConnected = true
//    }
//    
//    func disconnect() {
//        webSocketTask.cancel(with: .goingAway, reason: nil)
//    }
//    
//    func listen()  {
//        webSocketTask.receive { result in
//            print("result", result)
//            switch result {
//            case .failure(let error):
//                self.delegate?.onError(connection: self, error: error)
//            case .success(let message):
//                switch message {
//                case .string(let text):
//                    self.delegate?.onMessage(connection: self, text: text)
//                case .data(let data):
//                    self.delegate?.onMessage(connection: self, data: data)
//                @unknown default:
//                    fatalError()
//                }
//            }
//
//        }
//    }
//    func ping(completion: @escaping (Bool) -> Void) {
//      webSocketTask.sendPing { error in
//        if let error = error {
//          print("Error when sending PING \(error)")
//            // connection has died
//            completion(false)
//        } else {
//            completion(true)
//            print("Web Socket connection is alive")
//        }
//      }
//    }
//    func send(text: String) {
//        ping {
//            result in
//            print("ping result", result)
//
//            switch result{
//            case true:
//                self.webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { error in
//                    if let error = error {
//                        self.delegate?.onError(connection: self, error: error)
//                    }
//                }
//            case false:
//                
//                self.connect()
//                self.webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { error in
//                    if let error = error {
//                        self.delegate?.onError(connection: self, error: error)
//                    }
//                }
//            }
//        }
//    }
//    
//    func send <Body: Encodable>(data: Body) {
//        print("data", data)
//        let encodedData = try! JSONEncoder().encode(data)
//        ping {
//            result in
//            print("ping result", result)
//
//            switch result{
//            case true:
//                self.webSocketTask.send(URLSessionWebSocketTask.Message.data(encodedData)) { error in
//                    if let error = error {
//                        self.delegate?.onError(connection: self, error: error)
//                    }
//                }
//            case false:
//                self.connect()
//                self.webSocketTask.send(URLSessionWebSocketTask.Message.data(encodedData)) { error in
//                    if let error = error {
//                        self.delegate?.onError(connection: self, error: error)
//                    }
//                }
//            }
//            
//        }
//    }
//}
