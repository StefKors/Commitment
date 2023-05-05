//
//  MacTextEditorView.swift
//  Commitment
//
//  Created by Stef Kors on 05/05/2023.
//  source: https://github.com/writefreely/writefreely-swiftui-multiplatform/blob/main/macOS/PostEditor/MacEditorTextView.swift

import Combine
import SwiftUI

struct MacEditorTextView: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String? = nil
    var isFirstResponder: Bool = false
    var isEditable: Bool = true
    var font: NSFont? = .systemFont(ofSize: 14)

    var onEditingChanged: () -> Void = {}
    var onCommit: () -> Void = {}
    var onTextChange: (String) -> Void = { _ in }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(
            text: text,
            placeholder: placeholder,
            isEditable: isEditable,
            isFirstResponder: isFirstResponder,
            font: font
        )
        textView.delegate = context.coordinator

        return textView
    }

    func updateNSView(_ view: CustomTextView, context: Context) {
        view.text = text
        view.selectedRanges = context.coordinator.selectedRanges
    }
}

// MARK: - Coordinator

extension MacEditorTextView {

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: MacEditorTextView
        var selectedRanges: [NSValue] = []
        var didBecomeFirstResponder: Bool = false

        init(_ parent: MacEditorTextView) {
            self.parent = parent
        }

        func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            self.parent.text = textView.string
            self.parent.onEditingChanged()
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            self.parent.text = textView.string
            self.selectedRanges = textView.selectedRanges
            self.parent.onTextChange(textView.string)
        }

        func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            self.parent.text = textView.string
            self.parent.onCommit()
        }
    }
}

// MARK: - CustomTextView

final class CustomTextView: NSView {
    private var placeholder: String?
    private var isFirstResponder: Bool
    private var isEditable: Bool
    private var font: NSFont?

    weak var delegate: NSTextViewDelegate?

    var text: String {
        didSet {
            textView.string = text
        }
    }

    var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else {
                return
            }

            textView.selectedRanges = selectedRanges
        }
    }

    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        let textStorage = NSTextStorage()

        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(containerSize: CGSize(width: scrollView.frame.size.width, height: 20))
        textContainer.widthTracksTextView = true

        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )

        layoutManager.addTextContainer(textContainer)

        let paragraphStyle = NSMutableParagraphStyle()
        let lineSpacing: CGFloat = 8.5
        paragraphStyle.lineSpacing = lineSpacing

        let textView = NSTextView(frame: .zero, textContainer: textContainer)

        if let placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: NSColor.placeholderTextColor,
                .paragraphStyle: paragraphStyle,
                .font: font ?? NSFont.systemFont(ofSize: 17),
            ]
            textView.setValue(NSAttributedString(string: placeholder, attributes: attributes), forKey: "placeholderAttributedString")
        }

        // hack for aligning leading inset with SwiftUI
        textView.textContainerInset = CGSize(width: -4, height: 0)
        textView.autoresizingMask = .width
        textView.delegate = self.delegate
        textView.drawsBackground = false
        textView.font = self.font
        textView.defaultParagraphStyle = paragraphStyle
        textView.isEditable = self.isEditable
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        textView.minSize = NSSize(width: 0, height: contentSize.height)
        textView.textColor = NSColor.labelColor
        textView.allowsUndo = true
        textView.usesFindPanel = true
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isRichText = false
        textView.typingAttributes = [
            .paragraphStyle: paragraphStyle,                // H/T Daniel Jalkut
            .font: font ?? NSFont.systemFont(ofSize: 17),   // Fall back to system font if we can't unwrap font argument
            .foregroundColor: NSColor.labelColor
        ]

        return textView
    }()

    // MARK: - Init
    init(text: String, placeholder: String?, isEditable: Bool, isFirstResponder: Bool, font: NSFont?) {
        self.font = font
        self.placeholder = placeholder
        self.isFirstResponder = isFirstResponder
        self.isEditable = isEditable
        self.text = text

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewWillDraw() {
        super.viewWillDraw()

        setupScrollViewConstraints()
        setupTextView()

        if isFirstResponder {
            self.window?.makeFirstResponder(self.textView)
        }
    }

    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

    func setupTextView() {
        scrollView.documentView = textView
    }
}
