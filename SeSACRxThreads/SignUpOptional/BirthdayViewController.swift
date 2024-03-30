//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxCocoa
import RxSwift

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let today = BehaviorSubject(value: Date.now)
    let infoText = BehaviorSubject(value: "만 17세 이상만 가입 가능합니다")
    let yearText = PublishRelay<String>()
    let monthText = PublishRelay<String>()
    let dayText = PublishRelay<String>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        infoText.bind(to: infoLabel.rx.text).disposed(by: disposeBag)
        yearText.bind(to: yearLabel.rx.text).disposed(by: disposeBag)
        monthText.bind(to: monthLabel.rx.text).disposed(by: disposeBag)
        dayText.bind(to: dayLabel.rx.text).disposed(by: disposeBag)
        
        today.bind(with: self) { owner, date in
            let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
            
            owner.yearText.accept("\(component.year!)년")
            owner.monthText.accept("\(component.month!)월")
            owner.dayText.accept("\(component.day!)일")
            owner.birthDayPicker.date = date
            
            owner.infoLabel.rx.textColor.onNext(UIColor.red)
            owner.nextButton.rx.backgroundColor.onNext(UIColor.lightGray)
            owner.nextButton.rx.isEnabled.onNext(false)
        }
        .disposed(by: disposeBag)
        
        birthDayPicker.rx.date.changed.bind(with: self) { owner, date in
            let nowComponent = Calendar.current.dateComponents([.year], from: .now)
            let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
            
            guard let nowYear = nowComponent.year, 
                    let selectYear = component.year,
                    let selectMonth = component.month,
                    let selectDay = component.day else { return }
            
            owner.yearText.accept("\(selectYear)년")
            owner.monthText.accept("\(selectMonth)월")
            owner.dayText.accept("\(selectDay)일")
            
            if nowYear - selectYear < 17 {
                owner.infoText.onNext("만 17세 이상만 가입 가능합니다")
                owner.infoLabel.rx.textColor.onNext(UIColor.red)
                owner.nextButton.rx.backgroundColor.onNext(UIColor.lightGray)
                owner.nextButton.rx.isEnabled.onNext(false)
            } else {
                owner.infoText.onNext("가입 가능한 나이입니다.")
                owner.infoLabel.rx.textColor.onNext(UIColor.blue)
                owner.nextButton.rx.backgroundColor.onNext(UIColor.blue)
                owner.nextButton.rx.isEnabled.onNext(true)
            }
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let nav = UINavigationController(rootViewController: SampleViewController())
            
            sceneDelegate?.window?.rootViewController = nav
            sceneDelegate?.window?.makeKeyAndVisible()
        }
        .disposed(by: disposeBag)
    }

    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
