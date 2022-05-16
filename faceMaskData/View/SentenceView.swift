import UIKit

class SentenceView: UIStackView {
    
    var sentenceLabelView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .semibold)
        return view
    }()
    
    var authorLabelView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .light)
        
        return view
    }()
    
    public convenience init(sentence: String?, author: String?) {
        self.init(frame: .zero)
        sentenceLabelView.text = sentence
        authorLabelView.text = author
    }
    
    private override init(frame: CGRect) {
          super.init(frame: frame)
          setupViews()
    }
    
    func setupViews() {
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        self.isLayoutMarginsRelativeArrangement = true
        self.addArrangedSubview(sentenceLabelView)
        self.addArrangedSubview(authorLabelView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
