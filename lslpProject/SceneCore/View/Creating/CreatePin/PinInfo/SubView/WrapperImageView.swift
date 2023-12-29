//
//  WrapperImageView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
final class WrapperImageView: BaseView{
    var image:UIImage?{
        didSet{
            guard let image else {return}
            imageView.image = image
            let size = image.size
            let ratio = size.width / size.height
            imageView.snp.makeConstraints { make in
                make.width.equalTo(imageView.snp.height).multipliedBy(ratio)
            }
        }
    }
    var images: [UIImage]?{
        didSet{
            guard let images else {return}
            isAction.toggle()
            //            startTimer()
        }
    }
    private let imageView = UIImageView()
    private lazy var playBtn = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = .init(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14)))
        config.background.cornerRadius = 8
        config.background.backgroundColor = .systemBackground
        config.cornerStyle = .medium
        config.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
        btn.configuration = config
        btn.tintColor = .text
        btn.addAction(.init(handler: { [weak self] _ in
            self?.isAction.toggle()
        }), for: .touchUpInside)
        return btn
    }()
    deinit{
        print("WrapperImageView Deinit!!")
    }
    private var idx = 1
    private var isAction = false{
        didSet{
            playBtn.configuration?.image = UIImage(systemName: "\(!isAction ? "play" : "pause").fill",withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 14)))
            if isAction{
                startTimer()
            }else{
                print("gogogo \(isAction)")
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    var timer: Timer?
    override func configureView() {
        Task{@MainActor in
            await MainActor.run {
                self.imageView.layer.cornerRadius = 16
                self.imageView.layer.cornerCurve = .circular
                self.imageView.clipsToBounds = true
            }
        }
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
    }
    override func configureLayout() {
        addSubview(imageView)
        addSubview(playBtn)
    }
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        playBtn.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(8)
        }
    }
    convenience init(image:UIImage?){
        self.init()
        self.image = image
    }
}
extension WrapperImageView{
    func startTimer() {
        print("타이머 생성하기")
        timer = Timer.scheduledTimer(timeInterval: 1 * Double(images?.count ?? 0), target: self, selector: #selector(slider), userInfo: nil, repeats: true)
        guard let imageList = images,imageList.count > 1 else {return}
        goAnim(imageList: imageList)
    }
    @objc func slider(){
        guard let imageList = images,imageList.count > 1 else {return}
        Task{@MainActor[weak self] in
            guard let self else {return}
            for _ in (0..<imageList.count){
                goAnim(imageList: imageList)
                try await Task.sleep(for: .seconds(1))
            }
        }
    }
    func goAnim(imageList:[UIImage]){
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.imageView.alpha = 0.1
        }completion: {[weak self] _ in
            UIView.animate(withDuration: 0.4) {[weak self] in
                guard let self else {return}
                // 여기서 캡쳐링
                imageView.image = imageList[idx]
                imageView.alpha = 1
                idx = (idx + 1) % imageList.count
            }
            
        }
    }
}
