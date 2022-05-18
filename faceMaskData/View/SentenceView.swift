import UIKit

class SentenceView: UIStackView {
    
    var sentenceLabel: UILabel = {
        let view               = UILabel()
        view.numberOfLines     = 0
        view.lineBreakMode     = .byWordWrapping
        view.font              = UIFont.monospacedSystemFont(ofSize: 15, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
    
        return view
    }()
    
    var authorLabel: UILabel = {
        let view             = UILabel()
        view.numberOfLines   = 0
        view.lineBreakMode   = .byWordWrapping
        view.font            = UIFont.monospacedSystemFont(ofSize: 15, weight: .light)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(dailySentence: [faceMaskDataDailySentence]) {
        self.init(frame: .zero)
        if let dailySentence = dailySentence.first
        {
            
            sentenceLabel.text = dailySentence.sentence
            authorLabel.text   = dailySentence.author
            
        }
        
        
    }
    
    private override init(frame: CGRect) {
          super.init(frame: frame)
          setupViews()
    }
    
    func setupViews() {
        self.axis = .vertical
        self.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isLayoutMarginsRelativeArrangement        = true
        
        self.addArrangedSubview(sentenceLabel)
        self.addArrangedSubview(authorLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
