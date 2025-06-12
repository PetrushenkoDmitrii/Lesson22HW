
//2. Добавьте на главный экран UIPickerView с компонентами для выбора города. Вы можете
//
//использовать список городов, например: "Москва", "Нью-Йорк", "Лондон", «Париж».
//• Добавьте UILabel для отображения выбранного города.
//• При выборе города в UIPickerView, отобразите выбранный город в UILabel.
//
//3. Добавьте на главный экран еще одну кнопку с надписью "Загрузить изображение».
//• При нажатии на кнопку, открывайте UIImagePickerController, который позволит
//
//пользователю выбрать изображение из фотоальбома устройства.
//
//• После выбора изображения, отображайте его на экране (например, в UIImageView).

import UIKit

class ViewController: UIViewController {
    
    private let buttonShownMessege: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap me", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        return button
    }()
    
    private let labelThankYou: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Спасибо за поддержку!"
        label.alpha = 0
        return label
    }()
    
    private let townPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private let tonwPickerData: [String] = ["Москва", "Нью-Йорк", "Лондон", "Париж", "Минск"]
    
    private var labelTown: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        
        townPickerView.delegate = self
        townPickerView.dataSource = self
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(buttonShownMessege)
        view.addSubview(labelThankYou)
        view.addSubview(townPickerView)
        view.addSubview(labelTown)
        
        
        NSLayoutConstraint.activate([
            buttonShownMessege.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonShownMessege.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonShownMessege.widthAnchor.constraint(equalToConstant: 100),
            
            labelThankYou.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelThankYou.bottomAnchor.constraint(equalTo: buttonShownMessege.topAnchor, constant: -16),
            
            labelTown.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            townPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            townPickerView.topAnchor.constraint(equalTo: labelTown.bottomAnchor, constant: 8),
            
        ])
    }
    
    func setupAction() {
        buttonShownMessege.addAction(for: .touchUpInside) { _ in
            self.buttonShownMessegeTapped()
        }
    }
    
    private func buttonShownMessegeTapped() {
        let alert = UIAlertController(title: "Важное сообщение",
                                     message: "Спасибо, что выбрали наше приложение!",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK",
                              style: .default,
                              handler: { _ in
            UIView.animate(withDuration: 0.5) {
                self.labelThankYou.alpha = 1
                UIView.animate(withDuration: 2, delay: 2, options: .curveEaseIn) {
                    self.labelThankYou.alpha = 0
                }
            }
        }))
        
        alert.addAction(.init(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}


extension UIControl {
    func addAction(for event: UIControl.Event, action: @escaping
                   UIActionHandler) {
        addAction(UIAction(handler: action), for: event)
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tonwPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tonwPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelTown.text = "Вы выбрали город: \(tonwPickerData[row])"
    }
}
