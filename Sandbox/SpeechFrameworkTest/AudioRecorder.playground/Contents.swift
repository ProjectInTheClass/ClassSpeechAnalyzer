import Cocoa

var greeting = "Hello, playground"

//StartNewRecordingIfSilenceFor5Second
    func newSessionIfSilence(){

        //get Audio file name to store
        let AudioFileName = getDocumentsDirectory().appendingPathComponent("\(getUniqueName()).wav")
        //Declare a value that will be updated when silence is detected
        var statusForDetection = Float()
        //Recorder Settings used
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            ]
        //Try block
        do {
            //Start Recording With Audio File name
            let recorder = try AVAudioRecorder(url: AudioFileName, settings: settings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorder?.record()

            //Tracking Metering values here only
            let meterTimer = Timer.scheduledTimer(withTimeInterval: 0.10, repeats: true, block: { (timer: Timer) in

                //Update Recording Meter Values so we can track voice loudness
                //Getting Recorder from another class
                //i managed my recorder from Manager class
                if let recorder = recorder
                {
                    //Start Metering Updates
                    recorder.updateMeters()

                    //Get peak values
                    let recorderApc0 = recorder.averagePower(forChannel: 0)
                    let recorderPeak0 = recorder.peakPower(forChannel: 0)

                    //it’s converted to a 0-1 scale, where zero is complete quiet and one is full volume.
                    let ALPHA: Double = 0.05
                    let peakPowerForChannel = pow(Double(10), (0.05 * Double(recorderPeak0)))

//                    static var lowPassResults: Double = 0.0
                    var lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults

                    if(lowPassResults > 0){
                        print("Mic blow detected")
                        //Do what you wanted to do here

                        //if blow is detected update silence value as zero
                        statusForDetection = 0.0
                    }
                    else
                    {

                        //Update Value for Status is blow being detected or not
                        //As timer is called at interval of 0.10 i.e 0.1 So add value each time in silence Value with 0.1
                        statusForDetection += 0.1


                        //if blow is not Detected for 5 seconds
                        if statusForDetection > 5.0 {
                            //Update value to zero
                            //When value of silence is greater than 5 Seconds
                            //Time to Stop recording
                            statusForDetection = 0.0

                            //Stop Audio recording
                            recorder.stop()

                        }
                    }
                }
            })

        } catch {
            //Finish Recording with a Error
            print("Error Handling: \(error.localizedDescription)")
            //self.finishRecording(success: false)
        }

    }
