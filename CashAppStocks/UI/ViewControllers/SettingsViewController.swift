//
//  SettingsViewController.swift
//  CashAppStocks
//
//  Created by Luis Perez on 7/29/25.
//

import UIKit

enum ThemeOption: String, CaseIterable {
    case system = "System Default"
    case light = "Light"
    case dark = "Dark"
    
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}


class SettingsViewController: UITableViewController {

    private let themeOptions = ThemeOption.allCases
    private var selectedTheme: ThemeOption {
        get {
            let raw = UserDefaults.standard.string(forKey: Constants.AppStorageKeys.preferredTheme) ?? ThemeOption.system.rawValue
            return ThemeOption(rawValue: raw) ?? .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.AppStorageKeys.preferredTheme)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func updateAppearance(for option: ThemeOption) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.overrideUserInterfaceStyle = option.interfaceStyle
    }

    
    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themeOptions.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Appearance"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = self.themeOptions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = option.rawValue
        cell.contentConfiguration = config
        cell.accessoryType = (option == self.selectedTheme) ? .checkmark : .none

        return cell
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedOption = self.themeOptions[indexPath.row]
        self.selectedTheme = selectedOption
        self.updateAppearance(for: selectedOption)

        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
