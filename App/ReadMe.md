## 시스템 구성

1. 비디오의 오디오를 분석하면서 끊을 수 있는 침묵 구간을 잡아낸다. 
    - 활성구간은 10초 이상 1분 이내여야 한다. 
    - 구간정보는 파일의 일련 이름과 CMTimeRange 타입의 인스턴스를 포함.
    - 파일을 저장할 이름을 자동으로 생성해야 함. 일련번호와 같은 역할
    - Speech Recognize 시에 여러번의 응답이 온다는 것을 염두에 두고 Async 한 작업들을 관리한다.
2.  구간의 갯수만큼 for 문을 돌면서 AVAssetExportSession을 만들고 Async하게 Export를 한다.



- 파일로 추출하지 않고 바로 CMTimeRange 인스턴스를 이용해 Speech를 보내는 것도 괜찮음. 하지만 아무래도 메모리를 많이 먹어서 위험하지 않을까? 파일에 저장해 놓고, 저장한 파일을 for 문 돌면서 하는 게 더 안전하지 않나?

- 현재 AVAudioRecorder 클래스에만 averagePower(forChannel:) 메소드가 있음. 아니면 AudioToolbox를 사용해야 함. 이걸 해결하기 위해서는, 
    -  

### AVURLAsset
AVAsset의 서브클래스. URL 로 AVAsset을 만들면 자동으로 이 인스턴스가 리턴. 

### AVAssetExportSession
에셋의 콘텐츠를 추출 preset에서 지정한 형식으로 트랜스코딩하는 오브젝트

presetName을 다음과 같이 설정하면 됨.

- AVAssetExportPresetAppleM4A : Audio-only 프리셋
- outputURL 과 outputFileType 지정.
- timeRange : startTime 과 endTime을 지정한 CMTimeRange 인스턴스.
- exportAsynchronously : 추출 세션을 어싱크러너스 하게 시작하기.

