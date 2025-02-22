//
//  Elements+TestHelpers.swift
//  StripeiOSTests
//
//  Created by Yuki Tokuhiro on 7/20/23.
//

@testable@_spi(STP) import StripePaymentSheet
@testable@_spi(STP) import StripeUICore

extension Element {

    /// A convenience method that nwraps any Elements wrapped in `PaymentMethodElementWrapper`
    /// and returns all Elements underneath this Element, including this Element.
    public func getAllUnwrappedSubElements() -> [Element] {
        switch self {
        case let container as ContainerElement:
            return [container] + container.elements.flatMap { $0.getAllUnwrappedSubElements() }
        case let wrappedElement as PaymentMethodElementWrapper<FormElement>:
            return wrappedElement.element.getAllUnwrappedSubElements()
        case let wrappedElement as PaymentMethodElementWrapper<CheckboxElement>:
            return wrappedElement.element.getAllUnwrappedSubElements()
        case let wrappedElement as PaymentMethodElementWrapper<TextFieldElement>:
            return wrappedElement.element.getAllUnwrappedSubElements()
        case let wrappedElement as PaymentMethodElementWrapper<DropdownFieldElement>:
            return wrappedElement.element.getAllUnwrappedSubElements()
        case let wrappedElement as PaymentMethodElementWrapper<AddressSectionElement>:
            return wrappedElement.element.getAllUnwrappedSubElements()
        default:
            return [self]
        }
    }

    func getTextFieldElement(_ label: String) -> TextFieldElement? {
        return getAllUnwrappedSubElements()
            .compactMap { $0 as? TextFieldElement }
            .first { $0.configuration.label == label }
    }

    func getDropdownFieldElement(_ label: String) -> DropdownFieldElement? {
        return getAllUnwrappedSubElements()
            .compactMap { $0 as? DropdownFieldElement }
            .first { $0.label == label }
    }

    func getMandateElement() -> SimpleMandateElement? {
        return getAllUnwrappedSubElements()
            .compactMap { $0 as? SimpleMandateElement }
            .first
    }
}

extension TextFieldElement: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "<TextFieldElement: \(Unmanaged.passUnretained(self).toOpaque())>  -  \"\(configuration.label)\"  -  \(validationState)"
    }
}

extension DropdownFieldElement: CustomDebugStringConvertible {
    public override var debugDescription: String {
        return "<DropdownFieldElement: \(Unmanaged.passUnretained(self).toOpaque())>  -  \"\(label ?? "nil")\"  -  \(validationState)"
    }
}
