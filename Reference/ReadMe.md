## Speech Recognize 기본

 - [SFSpeechRecognizer를 통해 오디오 파일을 텍스트로 변환](https://leihao0.github.io/ko/Audio-File-to-Text-via-SFSpeechRecognizer/)
 - [Recognizing Speech Locally on an iOS Device Using the Speech Framework](https://www.andyibanez.com/posts/speech-recognition-sfspeechrecognizer/)
 - [Transcribing Speech to Text from Apple](https://developer.apple.com/tutorials/app-dev-training/transcribing-speech-to-text)

- [SFSpeechRecognizer is not available --> 시리를 켜라](https://stackoverflow.com/questions/39741938/sfspeechrecognizer-is-not-available)

## 오디오 분리

[Find silence in AVAudioRecorder Session](https://stackoverflow.com/questions/46297615/find-silence-in-avaudiorecorder-session)

: averagePowerForChannel과 peakPowerForChannel을 활용.

[How do I interpret an AudioBuffer and get the power?](https://stackoverflow.com/questions/25253291/how-do-i-interpret-an-audiobuffer-and-get-the-power)

: 오디오 버퍼 읽어서 레벨 미터를 만드려고 하는데, 리턴되는 값은 있는데 읽어내지 못하는 사람의 질문 -> Mike Ash의 2012년 코드 참조 답변. 

이 코드의 결과는 0dB reference 를 사용하는데, 0.0이 최대값이고, 이건 AVAudioPlayer의 averagePowerForChannel과도 동일.

## 화자분리 speaker diarization

[speaker diarization 살펴보기 블로그 by 송치성](https://dos-tacos.github.io/paper%20review/speaker_diarization/)
