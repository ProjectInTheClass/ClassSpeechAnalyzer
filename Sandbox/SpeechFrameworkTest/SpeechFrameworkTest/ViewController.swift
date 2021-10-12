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
    var videoAsset:AVAsset?
    var newpath:URL?
    
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
            createAssetsFolder()
            prepareAssets()
            //startAnalyzing()
        }
    }
    
    func createAssetsFolder() {
        let fileManager = FileManager.default
        newpath = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("Assets", isDirectory: true)
        do {
            try fileManager.createDirectory(at: newpath!, withIntermediateDirectories: true, attributes: nil)
            //let str = "Test Message"
            //let texturl = newpath.appendingPathComponent("message.txt")
            //try str.write(to: texturl, atomically: true, encoding: .utf8)
            //let input = try String(contentsOf: texturl)
            //print(input)
        } catch {print("Fail")}
        print(newpath!)
    }
    
    func prepareAssets() {
        videoAsset = AVAsset(url: videoPath.url!)
        
        let duration = CMTimeGetSeconds(videoAsset!.duration)
        let numOfSegments = Int(ceil(duration / 30) - 1)
        for index in 0...numOfSegments {
            splitAudio(asset: videoAsset!, segment: index)
        }
    }
    
    func splitAudio(asset: AVAsset, segment: Int) {
        // Create a new AVAssetExportSession
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
        // Set the output file type to m4a
        exporter.outputFileType = AVFileType.m4a
        // Create our time range for exporting
        let startTime = CMTimeMake(value: Int64(30 * segment), timescale: 1)
        let endTime = CMTimeMake(value: Int64(30 * (segment+1)), timescale: 1)
        // Set the time range for our export session
        exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        // Set the output file path
        
        exporter.outputURL = newpath?.appendingPathComponent("audio-\(segment).m4a", isDirectory: false)
        
        // Do the actual exporting
        exporter.exportAsynchronously(completionHandler: {
            switch exporter.status {
                case AVAssetExportSession.Status.failed:
                    print("Export failed.")
                default:
                    print("Export complete.")
            }
        })
        return
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


