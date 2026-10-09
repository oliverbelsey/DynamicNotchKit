@testable import DynamicNotchKit
import SwiftUI
import Testing

extension Tag {
    @Tag static var notchStyle: Self
    @Tag static var glassStyle: Self
}

/// Hey there! Looks like you found DynamicNotchKit's tests.
/// Please note that these tests do NOT actually "test" anything. They are only here to serve as examples of usage of DynamicNotchKit.
/// To run these tests, simply `cd` into the `DynamicNotchKit` directory and run `swift test`. Alternatively, open this package directly in Xcode, and the tests should show up in the sidebar.
@MainActor
@Suite(.serialized)
struct DynamicNotchKitTests {
    // MARK: - DynamicNotchInfo - Simple

    @Test("Info - Simple notch style", .tags(.notchStyle))
    func dynamicNotchInfoSimpleNotchStyle() async throws {
        try await _dynamicNotchInfoSimple(with: .notch)
    }

    @Test("Info - Simple glass style", .tags(.glassStyle))
    func dynamicNotchInfoSimpleGlassStyle() async throws {
        try await _dynamicNotchInfoSimple(with: .glass)
    }

    func _dynamicNotchInfoSimple(with style: DynamicNotchStyle) async throws {
        let notch = DynamicNotchInfo(
            icon: .init(systemName: "info.circle"),
            title: "This is `DynamicNotchInfo`",
            description: "It provides preset styles for easy use.",
            style: style
        )

        await notch.expand()

        try await Task.sleep(for: .seconds(4))

        withAnimation {
            notch.icon = .init(systemName: "arrow.trianglehead.2.clockwise")
            notch.title = "Content can be updated as well!"
            notch.description = "It's that simple!"
        }

        try await Task.sleep(for: .seconds(4))

        await notch.hide()
    }

    // MARK: - DynamicNotchInfo - Advanced

    @Test("Info - Advanced notch style", .tags(.notchStyle))
    func dynamicNotchInfoAdvancedNotchStyle() async throws {
        try await _dynamicNotchInfoAdvanced(with: .notch)
    }

    @Test("Info - Advanced glass style", .tags(.glassStyle))
    func dynamicNotchInfoAdvancedGlassStyle() async throws {
        try await _dynamicNotchInfoAdvanced(with: .glass)
    }

    func _dynamicNotchInfoAdvanced(with style: DynamicNotchStyle) async throws {
        let notch = DynamicNotchInfo(
            icon: .init(systemName: "info.circle"),
            title: "`DynamicNotchInfo`: advanced usage",
            description: "More than just images!",
            style: style,
            minimumWidth: 100
        )

        await notch.expand()

        try await Task.sleep(for: .seconds(4))

        withAnimation {
            notch.icon = .init(progress: .constant(0.5))
            notch.title = "Like progress bars..."
            notch.description = nil
        }

        try await Task.sleep(for: .seconds(4))

        withAnimation {
            notch.icon = nil
            notch.title = "There's also a compact style like iOS!"
            notch.description = "This has changeable width on non notched displays!"
        }

        try await Task.sleep(for: .seconds(4))

        withAnimation {
            notch.compactLeading = .init(systemName: "moon.fill", color: .blue)
        }
        await notch.compact()

        try await Task.sleep(for: .seconds(2))

        withAnimation {
            notch.compactTrailing = .init(systemName: "eyes.inverse", color: .orange)
        }

        try await Task.sleep(for: .seconds(2))

        withAnimation {
            notch.compactLeading = nil
        }

        try await Task.sleep(for: .seconds(2))

        await notch.hide()
    }

    // MARK: - DynamicNotchInfo - Custom

    @Test("Info - Custom notch style & gradient", .tags(.notchStyle))
    func dynamicNotchInfoCustomNotchStyle() async throws {
        try await _dynamicNotchInfoGradientCustomRadii(with: .notch(topCornerRadius: 10, bottomCornerRadius: 25))
    }

    @Test("Info - Custom glass style & gradient", .tags(.glassStyle))
    func dynamicNotchInfoCustomGlassStyle() async throws {
        try await _dynamicNotchInfoGradientCustomRadii(with: .glass(topCornerRadius: 10, bottomCornerRadius: 25))
    }

    func _dynamicNotchInfoGradientCustomRadii(with style: DynamicNotchStyle) async throws {
        let notch = DynamicNotchInfo(
            icon: .init {
                LinearGradient(
                    colors: [.blue, .red],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(.rect(cornerRadius: 4))
                .aspectRatio(contentMode: .fit)
            },
            title: "This a gradient!",
            description: "It ships with a `matchedGeometryEffect` for easy animations.",
            style: style
        )

        await notch.expand()
        try await Task.sleep(for: .seconds(4))
        await notch.compact()
        try await Task.sleep(for: .seconds(2))
        await notch.expand()
        try await Task.sleep(for: .seconds(2))
        await notch.compact()
        try await Task.sleep(for: .seconds(2))
        await notch.hide()
    }

    // MARK: DynamicNotchInfo - App Icon

    @Test("Info - Notch with custom icon", .tags(.notchStyle))
    func dynamicNotchInfoAppIcon() async throws {
        try await _testInfoWithAppIcon(with: .notch)
    }

    @Test("Info - Glass with custom icon", .tags(.glassStyle))
    func dynamicNotchInfoAppIconGlass() async throws {
        try await _testInfoWithAppIcon(with: .glass)
    }

    func _testInfoWithAppIcon(with style: DynamicNotchStyle) async throws {
        let notch = DynamicNotchInfo(
            icon: .init(image: Image(nsImage: NSImage(named: NSImage.applicationIconName)!)),
            title: "We support custom icons as well!",
            description: "As always, with a provided `matchedGeometryEffect`.",
            compactTrailing: .init(systemName: "square.and.arrow.up", color: .blue),
            style: style
        )

        await notch.expand()
        try await Task.sleep(for: .seconds(4))
        await notch.compact()
        try await Task.sleep(for: .seconds(1))
        withAnimation {
            notch.compactTrailing = .init(progress: .constant(1.0), color: .blue)
        }
        try await Task.sleep(for: .seconds(2))
        await notch.hide()
    }

    @Test("Info - Notch with changing compact icons - Notch Style", .tags(.notchStyle))
    func dynamicNotchInfoCompactIconsNotchStyle() async throws {
        try await _testDifferentCompactIcons(with: .notch)
    }
    
    @Test("Info - Notch with changing compact icons - Glass Style", .tags(.glassStyle))
    func dynamicNotchInfoCompactIconsGlassStyle() async throws {
        try await _testDifferentCompactIcons(with: .glass)
    }

    func _testDifferentCompactIcons(with style: DynamicNotchStyle) async throws {
        let notch = DynamicNotchInfo(
            icon: .init(systemName: "info.circle"),
            title: "Compact icons can change!",
            description: "This will show some combos.",
            compactLeading: .init(systemName: "moon.fill", color: .blue),
            compactTrailing: .init(systemName: "eyes.inverse", color: .orange),
            style: style
        )

        await notch.expand()
        try await Task.sleep(for: .seconds(4))
        await notch.compact()
        try await Task.sleep(for: .seconds(2))
        withAnimation {
            notch.compactLeading = .init(systemName: "arrow.triangle.2.circlepath", color: .teal)
        }
        try await Task.sleep(for: .seconds(2))
        withAnimation {
            notch.compactTrailing = .init(progress: .constant(0.75))
        }
        try await Task.sleep(for: .seconds(2))
        withAnimation {
            notch.compactLeading = .init(systemName: "scribble.variable", color: .indigo)
        }
        try await Task.sleep(for: .seconds(2))
        withAnimation {
            notch.compactTrailing = .init(systemName: "rectangle.pattern.checkered", color: .yellow)
        }
        try await Task.sleep(for: .seconds(2))
        withAnimation {
            notch.compactLeading = .init(image: Image(nsImage: NSImage(named: NSImage.applicationIconName)!))
        }
        try await Task.sleep(for: .seconds(2))
        await notch.hide()
    }

    @Test("DynamicNotch - Usage showcase - Notch style", .tags(.notchStyle))
    func dynamicNotchShowcaseNotchStyle() async throws {
        try await _dynamicNotchShowcase(with: .notch)
    }

    @Test("DynamicNotch - Usage showcase - Glass style", .tags(.glassStyle))
    func dynamicNotchShowcaseGlassStyle() async throws {
        try await _dynamicNotchShowcase(with: .glass)
    }

    func _dynamicNotchShowcase(with style: DynamicNotchStyle) async throws {
        let notch = DynamicNotch(style: style) {
            VStack(spacing: 10) {
                ForEach(0 ..< 10) { i in
                    Text("Hello World \(i)")
                }
            }
        } compactLeading: {
            Image(systemName: "moon.fill")
                .foregroundStyle(.blue)
        } compactTrailing: {
            Capsule()
                .frame(width: 8)
                .foregroundStyle(.white)
        }

        await notch.expand()
        try await Task.sleep(for: .seconds(2))
        await notch.compact()
        try await Task.sleep(for: .seconds(2))
        await notch.hide()
    }

    @Test("DynamicNotch - Rapid Fire - Notch style", .tags(.notchStyle))
    func dynamicNotchRapidFireNotchStyle() async throws {
        try await _dynamicNotchRapidFire(with: .notch)
    }
    
    @Test("DynamicNotch - Rapid Fire - Glass style", .tags(.glassStyle))
    func dynamicNotchRapidFireGlassStyle() async throws {
        try await _dynamicNotchRapidFire(with: .glass)
    }
    
    func _dynamicNotchRapidFire(with style: DynamicNotchStyle) async throws {
        for i in 0 ..< 30 {
            let notch = DynamicNotchInfo(
                icon: .init(systemName: "gauge.with.dots.needle.100percent"),
                title: "Rapid Fire Test \(i + 1)",
                style: style
            )

            await notch.expand()
            await notch.hide()
        }
    }
}
