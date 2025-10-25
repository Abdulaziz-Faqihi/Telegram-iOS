# Accessibility Guidelines for Telegram-iOS

This document provides guidelines for implementing accessibility features in Telegram-iOS to ensure the app is usable by everyone, including users who rely on VoiceOver and other assistive technologies.

## Overview

Accessibility in iOS ensures that users with disabilities can perceive, understand, navigate, and interact with the app. This includes support for:

- **VoiceOver**: Screen reader for blind and low-vision users
- **Voice Control**: Hands-free navigation and interaction
- **Switch Control**: Adaptive switches for users with limited mobility
- **Dynamic Type**: Larger text sizes for low-vision users
- **Reduce Motion**: Minimized animations for users with motion sensitivity

## Current State

### Analysis Results

- **3,592** total Swift files in the codebase
- **1,330** files contain UI elements (buttons, views, components)
- **235** files have accessibility implementations (18%)
- **1,095** files missing accessibility support (82% gap)
- **188** high-priority components identified needing fixes

### Existing Utilities

The codebase includes accessibility utilities in:
- `submodules/Display/Source/Accessibility.swift`
- `submodules/Display/Source/AccessibilityAreaNode.swift`

## Implementation Guidelines

### 1. Basic Accessibility Properties

Every interactive UI element should set these basic properties:

```swift
// Make the element accessible
view.isAccessibilityElement = true

// Set the accessibility label (describes what the element is)
view.accessibilityLabel = "Send message"

// Set accessibility traits (describes what type of element it is)
view.accessibilityTraits = .button

// Optional: Set accessibility hint (describes what happens when you interact)
view.accessibilityHint = "Sends the message to the chat"

// Optional: Set accessibility value (for elements with state)
view.accessibilityValue = "3 unread messages"
```

### 2. Buttons and Interactive Elements

All buttons must have:
- `accessibilityTraits = .button`
- Descriptive `accessibilityLabel`
- Optional `accessibilityHint` for complex actions

**Example:**
```swift
public override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
    
    // Set accessibility properties
    self.isAccessibilityElement = true
    self.accessibilityTraits = .button
}

func update(component: SomeComponent) {
    // Update accessibility label based on current state
    self.accessibilityLabel = component.title
}
```

### 3. Switches and Toggles

Switches should indicate their current state:

```swift
self.isAccessibilityElement = true
self.accessibilityLabel = "Enable notifications"
self.accessibilityValue = isOn ? "On" : "Off"
self.accessibilityTraits = .button // Use .button, not .switch, for custom switches

// For disabled states
if !isEnabled {
    self.accessibilityTraits.insert(.notEnabled)
}
```

### 4. Sliders and Adjustable Controls

For sliders, use the adjustable trait:

```swift
sliderView.isAccessibilityElement = true
sliderView.accessibilityTraits = .adjustable
sliderView.accessibilityLabel = "Volume"
sliderView.accessibilityValue = "\(Int(currentValue * 100))%"

// Implement increment/decrement for VoiceOver swipe gestures
override func accessibilityIncrement() {
    // Increase value
}

override func accessibilityDecrement() {
    // Decrease value
}
```

### 5. Images and Icons

Decorative images should be hidden from accessibility:
```swift
decorativeImageView.isAccessibilityElement = false
```

Meaningful images need labels:
```swift
imageView.isAccessibilityElement = true
imageView.accessibilityLabel = "Profile picture"
imageView.accessibilityTraits = .image
```

### 6. Complex Components

For components with multiple sub-elements:

**Option 1: Single Accessibility Element**
```swift
// Make parent accessible and hide children
self.isAccessibilityElement = true
self.accessibilityLabel = "Full message: \(title), \(subtitle)"
titleView.isAccessibilityElement = false
subtitleView.isAccessibilityElement = false
```

**Option 2: Multiple Accessibility Elements**
```swift
// Use AccessibilityAreaNode for specific regions
private let titleAccessibilityArea = AccessibilityAreaNode()
titleAccessibilityArea.accessibilityLabel = title
titleAccessibilityArea.accessibilityTraits = .staticText
```

### 7. Navigation Elements

Back buttons and navigation items:
```swift
self.isAccessibilityElement = true
self.accessibilityTraits = .button
self.accessibilityLabel = "Back, \(previousScreenTitle)"
self.accessibilityHint = "Navigate back"
```

### 8. Text Input Fields

Text fields should have clear labels:
```swift
textField.accessibilityLabel = "Message"
textField.accessibilityHint = "Type your message here"
textField.accessibilityTraits = .allowsDirectInteraction
```

## Common Accessibility Traits

| Trait | Usage |
|-------|-------|
| `.button` | Buttons and tappable elements |
| `.link` | Links that navigate elsewhere |
| `.staticText` | Non-interactive text labels |
| `.image` | Images and icons |
| `.header` | Section headers |
| `.adjustable` | Sliders and steppers |
| `.notEnabled` | Disabled interactive elements |
| `.selected` | Currently selected items |

## Testing Accessibility

### Manual Testing with VoiceOver

1. Enable VoiceOver: **Settings > Accessibility > VoiceOver**
2. Navigate through the app:
   - Swipe right/left to move between elements
   - Double-tap to activate
   - Three-finger swipe to scroll
3. Verify:
   - All interactive elements are reachable
   - Labels are descriptive and clear
   - Actions are announced correctly
   - State changes are communicated

### Xcode Accessibility Inspector

1. Open **Xcode > Open Developer Tool > Accessibility Inspector**
2. Select your app in the target dropdown
3. Use the "Inspection Pointer" to check elements
4. Run the "Audit" to find common issues

### Voice Control Testing

1. Enable Voice Control: **Settings > Accessibility > Voice Control**
2. Try commanding: "Tap Send", "Show names", "Show numbers"
3. Verify all buttons can be activated by voice

## Fixed Components

The following components have been updated with accessibility support:

- ✅ PlainButtonComponent
- ✅ OptionButtonComponent
- ✅ MoreHeaderButton
- ✅ GroupHeaderActionButton
- ✅ GroupExpandActionButton
- ✅ ItemListInviteLinkDateLimitItem
- ✅ ListSwitchItemComponent
- ✅ CheckComponent
- ✅ ListActionItemComponent
- ✅ BackButtonComponent

## Priority Components Needing Fixes

High-priority components identified for accessibility improvements:

1. **Button Components**: ButtonComponent, CameraButtonComponent, ActionPanelComponent
2. **List Items**: CategoryListItemComponent, AutomaticBusinessMessageListItemComponent
3. **Navigation**: ChatAvatarNavigationNode, NavigationBarContentNode
4. **Media Controls**: AudioTranscriptionButtonComponent, CaptureControlsComponent
5. **Custom Views**: AvatarStoryIndicatorComponent, BoostSlowModeButton

## Best Practices

### DO:
- ✅ Set `isAccessibilityElement = true` for all interactive elements
- ✅ Provide clear, concise accessibility labels
- ✅ Update accessibility values when state changes
- ✅ Group related elements when appropriate
- ✅ Test with VoiceOver regularly
- ✅ Use existing utilities like `AccessibilityAreaNode`

### DON'T:
- ❌ Leave interactive elements without accessibility labels
- ❌ Use implementation details in labels (e.g., "Button" suffix)
- ❌ Make decorative elements accessible
- ❌ Forget to update accessibility on state changes
- ❌ Use vague labels like "More" without context

## Resources

- [Apple Accessibility Documentation](https://developer.apple.com/accessibility/)
- [UIAccessibility Protocol Reference](https://developer.apple.com/documentation/uikit/uiaccessibility)
- [VoiceOver Gestures Guide](https://support.apple.com/guide/iphone/learn-voiceover-gestures-iph3e2e2281/ios)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

## Contributing

When adding new UI components:

1. Always implement accessibility from the start
2. Follow the patterns in this guide
3. Test with VoiceOver before submitting
4. Update this document if adding new accessibility patterns
5. Add accessibility labels to all interactive elements

## Support

For questions or assistance with accessibility implementation:
- Review existing accessible components in this codebase
- Consult the Display/Source/Accessibility.swift utilities
- Test thoroughly with VoiceOver and Voice Control
