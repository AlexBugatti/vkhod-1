//
//  PageView.swift
//  vezdecod-pincode
//
//  Created by Александр on 24.04.2021.
//

import UIKit

class PageView: UIView {

    private lazy var stackView: UIStackView = {
        var view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var dottedViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }
    
    func common() {
        self.backgroundColor = .yellow
        self.stackView.backgroundColor = .blue
        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        var v = UIView()
        v.backgroundColor = .cyan
        stackView.addArrangedSubview(v)
        
        for index in 0...5 {
            var dotView = UIView(frame: CGRect.init(x: 0, y: 0, width: 18, height: 18))
            dotView.translatesAutoresizingMaskIntoConstraints = false
//            dotView.widthAnchor.constraint(equalToConstant: 18)
            dotView.backgroundColor = .red
            dotView.tag = index
            self.dottedViews.append(dotView)
            self.stackView.addArrangedSubview(dotView)
        }
        self.setNeedsLayout()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
