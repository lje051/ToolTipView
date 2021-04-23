//
//  ToolTipView.swift
//  jobplanet
//
//  Created by Jeeeun Lim on 2020/11/24.
//  Copyright © 2020 Braincommerce. All rights reserved.
//
import Foundation
import UIKit

/**
 툴팁 커스텀뷰
 let p = 타겟이 되는뷰.center
 let tipWidth: CGFloat = 툴팁 가로사이즈
 let tipHeight: CGFloat = 툴팁 세로사이즈

 let tipX = p.x - (tipWidth/2)
 let tipY: CGFloat = p.y - tipHeight-12
 ToolTipView(frame: CGRect(x: tipX, y: tipY, width: tipWidth, height: tipHeight), text: "전체/연차별 답변 결과도 확인하세요.", tipPos: .right).show(self.view)
 */

public struct InfoModel {
    let title: [String]
    public init(title: [String]) {
        self.title = title
    }
}

open class ToolTipView: UIView {
    public enum ToolTipPosition: Int {
        case left
        case right
        case middle
    }

    private var roundRect: CGRect! // text background
    private let toolTipWidth: CGFloat = 0.0 // 뒤집어진 삼각형 가로
    private let toolTipHeight: CGFloat = 0.0// 뒤집어진 삼각형 세로
    private let tipOffset: CGFloat = 0.0 // 뒤집어진 삼각형 여백
    private var tipPosition: ToolTipPosition = .middle

    /// initiating View
    /// - Parameters:
    ///   - frame:CGRect(x: tipX, y: tipY, width: 원하는 툴팁 가로사이즈, height: 원하는 툴팁 세로사이즈)
    ///   - text: 툴팁안의 텍스트
    ///   - tipPos: 툴팁의 뒤집어진 삼각형 포지션 정렬
    public convenience init(frame: CGRect, model: InfoModel, tipPos: ToolTipPosition?) {
        self.init(frame: frame)
        self.backgroundColor = .white
        self.tipPosition = tipPos ?? .right
        createReviewTooltip(model)
    }

    public convenience init(frame: CGRect, data: String, tipPos: ToolTipPosition?) {
        self.init(frame: frame)
        self.backgroundColor = .white
        self.tipPosition = tipPos ?? .right
        createHeaderTooltip(data)
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.borderColor = UIColor(red: 229 / 255, green: 230 / 255, blue: 233 / 255, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 5
        createShapeLayer(rect)
    }

    /// 툴팁밑의 삼각형 위치
    fileprivate func createTipPath() -> UIBezierPath {
        let tooltipRect = CGRect(x: roundRect.maxX - 47, y: roundRect.maxY, width: toolTipWidth, height: toolTipHeight)
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
        trianglePath.addLine(to: CGPoint(x: tooltipRect.maxX, y: tooltipRect.minY))
        trianglePath.addLine(to: CGPoint(x: tooltipRect.midX, y: tooltipRect.maxY))
        trianglePath.addLine(to: CGPoint(x: tooltipRect.minX, y: tooltipRect.minY))
        trianglePath.close()
        return trianglePath
    }

    fileprivate func drawToolTip(_ rect: CGRect) {
        roundRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - toolTipHeight)
        let roundRectBez = UIBezierPath(roundedRect: roundRect, cornerRadius: 5.0)
        let trianglePath = createTipPath()
        roundRectBez.append(trianglePath)
        let shape = CAShapeLayer()
        shape.path = roundRectBez.cgPath
        self.layer.insertSublayer(shape, at: 0)
    }

    fileprivate func createShapeLayer(_ rect: CGRect) {
        self.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height), cornerRadius: 7.0).cgPath
        self.layer.shadowColor = UIColor(red: 229 / 255, green: 230 / 255, blue: 233 / 255, alpha: 1.0).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.shadowRadius = 7.0
        self.layer.shadowOpacity = 0.6
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    fileprivate func createReviewTooltip(_ initModel: InfoModel) {
        // 카테고리명
        let label = UILabel(frame: .zero)
        label.text = initModel.title[0]
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13.0)
        label.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0 / 255, green: 195 / 255, blue: 98 / 255, alpha: 1.0)
        // 여백
        let emptyView = UIView(frame: .zero)
        emptyView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        // 오렌지 dot
        let orangeSuperView = UIView(frame: .zero)
        orangeSuperView.widthAnchor.constraint(equalToConstant: 6).isActive = true
        let orangeImg = UIView(frame: .zero)
        orangeImg.layer.cornerRadius = 3
        orangeImg.backgroundColor = UIColor(red: 255 / 255, green: 152 / 255, blue: 0 / 255, alpha: 1.0)
        orangeSuperView.addSubview(orangeImg)
        orangeImg.anchor(top: orangeSuperView.topAnchor, leading: orangeSuperView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 7, left: 0, bottom: 0, right: 0), size: .init(width: 6, height: 6))
        // 라벨
        let reviewLabel = UILabel(frame: .zero)
        reviewLabel.text = "\(initModel.title[1])"
        reviewLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13.0)
        reviewLabel.textColor = UIColor(red: 75 / 255, green: 76 / 255, blue: 80 / 255, alpha: 1.0)
        // 여백
        let emptyView2 = UIView(frame: .zero)
        emptyView2.widthAnchor.constraint(equalToConstant: 12).isActive = true
        // 파란 dot
        let blueSuperView = UIView(frame: .zero)
        blueSuperView.widthAnchor.constraint(equalToConstant: 6).isActive = true
        let blueImg = UIView(frame: .zero)
        blueImg.backgroundColor = UIColor(red: 66 / 255, green: 165 / 255, blue: 245 / 255, alpha: 1.0)
        blueSuperView.addSubview(blueImg)
        blueImg.anchor(top: blueSuperView.topAnchor, leading: blueSuperView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 7, left: 0, bottom: 0, right: 0), size: .init(width: 6, height: 6))
        blueImg.layer.cornerRadius = 3
        //  라벨
        let surveyData = UILabel(frame: .zero)
        surveyData.text = "\(initModel.title[2])"
        surveyData.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13.0)
        surveyData.textColor = UIColor(red: 75 / 255, green: 76 / 255, blue: 80 / 255, alpha: 1.0)
        // 여백
        let emptyView3 = UIView(frame: .zero)
        // 종료버튼 뷰
        let btnView = UIView(frame: .zero)
        let btnImage = UIImageView(frame: .zero)
        btnView.addSubview(btnImage)
        btnImage.widthAnchor.constraint(equalToConstant: 12).isActive = true
        btnImage.image = UIImage(named: "imgCloseTooltip210125")
        btnImage.anchor(top: btnView.topAnchor, leading: nil, bottom: nil, trailing: btnView.trailingAnchor, padding: .init(top: 3, left: 0, bottom: 0, right: 16))
        let btn = UIButton(frame: .zero)
        btnView.addSubview(btn)
        btn.fillSuperview()
        btn.addTarget(self, action: #selector(closeTooltip(sender:)), for: .touchUpInside)

        // 가로모양 스택뷰
        let stackView = VerticalStackView(arrangedSubViews: [label, emptyView, orangeSuperView, reviewLabel, emptyView2, blueSuperView, surveyData, emptyView3, btnView], spacing: 8)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 16, bottom: 12, right: 0))
    }

    fileprivate func createHeaderTooltip(_ data: String) {
        // 라벨
        let label = UILabel(frame: .zero)
        let attrString: NSMutableAttributedString = .init(string: data, attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-Regular", size: 13.0)!,
            .foregroundColor: UIColor(red: 87 / 255, green: 89 / 255, blue: 91 / 255, alpha: 1.0)
        ])
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attrString.length))
        label.attributedText = attrString
        label.numberOfLines = 0
        // 종료 이미지
        let btnImage = UIImageView(frame: .zero)
        btnImage.image = UIImage(named: "imgCloseTooltip210125")
        let btnView = UIView(frame: .zero)
        btnView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        btnView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        btnView.addSubview(btnImage)
        btnImage.anchor(top: btnView.topAnchor, leading: nil, bottom: nil, trailing: btnView.trailingAnchor, padding: .init(top: 3, left: 0, bottom: 0, right: 16), size: CGSize(width: 12, height: 12))
        // 종료버튼
        let btn = UIButton(frame: .zero)
        btnView.addSubview(btn)
        btn.fillSuperview()
        btn.addTarget(self, action: #selector(closeTooltip(sender:)), for: .touchUpInside)
        // 가로 스택뷰
        let stackView = VerticalStackView(arrangedSubViews: [label, btnView], spacing: 0)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 16, bottom: 12, right: 0))
    }

    @objc func closeTooltip(sender: UIButton) {
        self.removeFromSuperview()
    }

    public func show(_ target: UIView) {
        var exist = false
        for view in target.subviews where view.tag == 100 {
            exist = true
        }
        if !exist {
            self.tag = 100
            target.addSubview(self)
            target.bringSubviewToFront(self)
        }
    }
}

extension UIView {
    struct AnchoredConstraints {
        var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
    }

    class VerticalStackView: UIStackView {
        init(arrangedSubViews: [UIView], spacing: CGFloat = 0) {
            super.init(frame: .zero)
            arrangedSubViews.forEach { addArrangedSubview($0)
            }
            self.spacing = spacing
            self.axis = .vertical
        }

        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()

        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }

        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }

        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }

        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }

        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }

        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }

        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach { $0?.isActive = true }

        return anchoredConstraints
    }

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }

        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }

        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }

        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }

    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }

        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }

    func centerYInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }

    func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}
