# Technical Requirements for PayPal Mobile Development Course

## Development Environment Requirements

### Essential Software
- **Flutter SDK**: Latest stable version (3.0.0 or higher)
- **Dart SDK**: 3.0.0 or higher (included with Flutter SDK)
- **Git**: 2.30.0 or higher
- **VS Code**: Latest version with extensions:
  - Flutter extension
  - Dart extension
  - Flutter Widget Snippets
  - Flutter Riverpod Snippets

### Platform-Specific Requirements

#### For iOS Development
- **Operating System**: macOS Monterey (12.0) or higher
- **Xcode**: Version 14.0 or higher
- **iOS Simulator**: Included with Xcode
- **CocoaPods**: Latest version

#### For Android Development
- **Android Studio**: Latest version
- **Android SDK**: API level 33 (Android 13.0) or higher
- **Android Emulator**: With Google Play Services
- **Java Development Kit (JDK)**: Version 11 or higher

## Hardware Requirements

### Minimum Specifications
- **RAM**: 8GB (16GB recommended)
- **Storage**: 20GB free space
  - Flutter SDK: ~2.8GB
  - Android Studio + SDK: ~8GB
  - Xcode: ~15GB (Mac only)
  - Project files and dependencies: ~2GB
- **Processor**: 
  - Intel: Core i5 6th generation or higher
  - AMD: Ryzen 5 or higher
  - Apple: M1 or higher
- **Display**: 1920x1080 resolution or higher

### Operating System Requirements
- **macOS**: 
  - Required for iOS development
  - Monterey (12.0) or higher
  - Both Intel and Apple Silicon supported
- **Windows**: 
  - Windows 10 version 1903 or higher
  - 64-bit operating system
- **Linux**:
  - Ubuntu 20.04 LTS or higher
  - Other distributions must support snap packages

## Virtualization Requirements

### Corporate Environment Considerations
- **Sandbox Environment**:
  - Docker Desktop for containerization
  - VMware Workstation Pro or Parallels (for macOS)
  - Minimum VM specifications:
    * 4 CPU cores
    * 8GB RAM
    * 50GB storage
    * Virtualization technology enabled in BIOS

### Virtualization Technology
- **Windows**:
  - Hyper-V enabled (Windows 10 Pro or higher required)
  - Intel HAXM for AMD processors
- **macOS**:
  - Apple Hypervisor Framework (built-in)
- **Linux**:
  - KVM virtualization enabled

## Network Requirements

### Connectivity
- Stable internet connection (10 Mbps or higher)
- Access to:
  - pub.dev (Flutter packages)
  - github.com
  - flutter.dev
  - developer.apple.com
  - developer.android.com

### Corporate Network Configuration
- **Required Ports**:
  - 8080, 8081 (Development servers)
  - 5037 (Android Debug Bridge)
  - 3000 (Web development)
- **Firewall Exceptions**:
  - Flutter SDK
  - Android SDK
  - iOS Simulator
  - Development IDEs
- **Proxy Configuration**:
  - Support for HTTPS traffic
  - Authentication requirements
  - Certificate installation

## Corporate Security Considerations

### Code Isolation
- Dedicated development VM/container recommended
- Separate user account for development
- Isolated network configuration

### Security Policies
- **Code Scanning Requirements**:
  - Static code analysis tools
  - Dependency vulnerability scanning
  - Code signing certificates

### Data Handling
- Test data isolation
- No production data in development
- Secure storage of API keys and secrets

## Version Control Requirements

### Git Configuration
- Git LFS for large binary files
- SSH key authentication
- Corporate Git server access

### Repository Access
- GitHub Enterprise access
- Two-factor authentication
- GPG signing for commits

## Additional Tools

### Recommended Development Tools
- **Postman**: API testing
- **Visual Studio Code Live Share**: Collaborative development
- **Flutter DevTools**: Performance profiling
- **Firebase CLI**: Backend services

### Team Collaboration
- Slack or Microsoft Teams
- Jira or similar project management tool
- Confluence or similar documentation platform

## Support and Resources

### Documentation
- Flutter official documentation
- Internal PayPal development guidelines
- Course-specific documentation

### Technical Support
- IT support contact information
- Development team leads
- Course instructors

## Installation Verification

### System Check
```bash
flutter doctor -v  # Verify Flutter installation
flutter devices   # Check available devices
flutter pub get   # Test package management
```

### Troubleshooting
- Common installation issues
- Network configuration problems
- Corporate security conflicts

Note: These requirements are specifically tailored for PayPal's corporate environment. Some requirements may need adjustment based on specific corporate policies or security requirements.
