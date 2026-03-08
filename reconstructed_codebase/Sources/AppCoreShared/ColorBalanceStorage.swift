import Foundation
import ImageCore

public protocol ColorBalanceStorageContainer: AnyObject {
    func objectForKey(_ key: String) -> Any?
    func setObject(_ object: Any?, forKey key: String)
}

extension MCVariant: ColorBalanceStorageContainer {}
extension MCAdjLayer: ColorBalanceStorageContainer {}

public enum ColorBalanceStorageKeys {
    public static let master = "colorBalance"
    public static let shadow = "colorBalanceShadow"
    public static let midtone = "colorBalanceMidtone"
    public static let highlight = "colorBalanceHighlight"
}

public enum ColorBalanceStorage {
    public static func sanitizedMaster(_ value: ColorBalanceValue) -> ColorBalanceValue {
        ColorBalanceValue(hue: value.hue, saturation: value.saturation, brightness: 0)
    }

    public static func normalizedSettings(_ settings: ColorBalanceSettings) -> ColorBalanceSettings {
        ColorBalanceSettings(
            master: sanitizedMaster(settings.master),
            shadow: settings.shadow,
            midtone: settings.midtone,
            highlight: settings.highlight
        )
    }

    public static func settings(from container: ColorBalanceStorageContainer?) -> ColorBalanceSettings {
        guard let container else {
            return ColorBalanceSettings()
        }

        return normalizedSettings(
            ColorBalanceSettings(
                master: value(forKey: ColorBalanceStorageKeys.master, from: container, normalizeMaster: true),
                shadow: value(forKey: ColorBalanceStorageKeys.shadow, from: container),
                midtone: value(forKey: ColorBalanceStorageKeys.midtone, from: container),
                highlight: value(forKey: ColorBalanceStorageKeys.highlight, from: container)
            )
        )
    }

    public static func apply(_ settings: ColorBalanceSettings, to container: ColorBalanceStorageContainer?) {
        guard let container else {
            return
        }

        let normalized = normalizedSettings(settings)
        setValue(normalized.master, forKey: ColorBalanceStorageKeys.master, on: container)
        setValue(normalized.shadow, forKey: ColorBalanceStorageKeys.shadow, on: container)
        setValue(normalized.midtone, forKey: ColorBalanceStorageKeys.midtone, on: container)
        setValue(normalized.highlight, forKey: ColorBalanceStorageKeys.highlight, on: container)
    }

    public static func value(forKey key: String, from container: ColorBalanceStorageContainer?, normalizeMaster: Bool = false) -> ColorBalanceValue {
        guard
            let container,
            let data = container.objectForKey(key) as? Data,
            let decoded = try? JSONDecoder().decode(ColorBalanceValue.self, from: data)
        else {
            return .neutral
        }

        return normalizeMaster ? sanitizedMaster(decoded) : decoded
    }

    public static func setValue(_ value: ColorBalanceValue, forKey key: String, on container: ColorBalanceStorageContainer?) {
        guard let container else {
            return
        }

        let normalizedValue = key == ColorBalanceStorageKeys.master ? sanitizedMaster(value) : value
        let encoded = try? JSONEncoder().encode(normalizedValue)
        container.setObject(encoded, forKey: key)
    }
}
