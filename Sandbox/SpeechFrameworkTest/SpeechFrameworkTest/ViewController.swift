//
//  ViewController.swift
//  SpeechFrameworkTest
//
//  Created by LingoStar on 2021/10/05.
//

import Cocoa
import Speech
import AVFoundation

class ViewController: NSViewController {
    
    var videoFileURL:URL?
    @IBOutlet weak var videoPath: NSPathControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation { [weak self] in
                switch authStatus {
                case .notDetermined, .denied, .restricted:
                    print(".notDetermined, .denied, .restricted")
                case .authorized:
                    //self?.startRecognizeFile()
                    print("no error")
                @unknown default:
                    print("fatal error")
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    //private let speechRecognizer: SFSpeechRecognizer?
    //private var recognitionRequest: SFSpeechURLRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    @IBAction func startSpeechRecognize(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
        } else {
            startAnalyzing()
        }
    }
    
    func startAnalyzing() {

        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko_KR")) else {
            return
        }
        
        if !speechRecognizer.isAvailable {
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: videoPath.url!)
        
        speechRecognizer.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                // Recognition failed, so check error for details and handle it
                print("err: ", error.debugDescription)
                return
            }

            
            let str = result.bestTranscription.formattedString
//            OperationQueue.main.addOperation {
//                completion(result.isFinal, str)
//            }
            print (str)

        }
    }
    
    
}

extension ViewController : NSPathControlDelegate, NSOpenSavePanelDelegate {
    func pathControl(_ pathControl: NSPathControl, willDisplay openPanel: NSOpenPanel) {
        openPanel.delegate = self
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        openPanel.prompt = "Choose"
    }
    
    
//: -
    
    func panelSelectionDidChange(_ sender: Any?) {
        print("didChange")
    }
    
}


