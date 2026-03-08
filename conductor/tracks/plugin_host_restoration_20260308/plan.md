# Implementation Plan: Plugin Host Architecture Restoration

## Objective
Reconstruct the Plugin Host Architecture (INT-003) from `PluginCore`, enabling the discovery, loading, and management of plugins, along with the foundation for XPC service communication (`COPluginAgent`, `COPluginHostConnection`).

## Key Files & Context
- `AppCoreShared/PluginModels.swift`: Data models for `COPlugin`, representing an installed plugin.
- `AppCoreShared/PluginManager.swift`: Reconstructed `COPluginManager` for discovering and loading plugins from bundle paths.
- `AppCoreShared/PluginHostConnection.swift`: Reconstructed mock of the XPC host interface (`COPluginHostInterface`, `COPluginAgentInterface`).
- `CaptureOneUI/PreferencesWindowController.swift`: UI to view installed plugins.

## Implementation Steps

### Phase 1: Plugin Models & Discovery (AppCoreShared)
- [x] Task: Reconstruct the `COPlugin` data model (id, name, version, path, type). fc89690
- [x] Task: Reconstruct `COPluginManager` to scan `pluginsPaths` (mocked directories) and populate `COPlugin` instances. fc89690
- [x] Task: Commit Phase 1 & Build Check. fc89690

### Phase 2: Plugin Agent Interface Mock (AppCoreShared)
- [ ] Task: Reconstruct `COPluginAgentInterface` and `COPluginHostInterface` structures.
- [ ] Task: Implement `COPluginHostConnection` as a mock wrapper simulating an XPC connection to a plugin.
- [ ] Task: Commit Phase 2 & Build Check.

### Phase 3: Plugin UI & Preferences (CaptureOneUI)
- [ ] Task: Create a `PluginsPreferencesView` displaying a list of discovered plugins.
- [ ] Task: Add a button to "Load Plugin" (simulating a mock plugin install).
- [ ] Task: Commit Phase 3 & Build Check.

### Phase 4: Integration (CaptureOneApp)
- [ ] Task: Initialize `COPluginManager.shared` at app launch.
- [ ] Task: Create a test case: verify `COPluginManager` detects a mocked `.coplugin` bundle and successfully parses its metadata.
- [ ] Task: Commit Phase 4 & Build Check.

## Verification & Testing
- Test Case: Drop a mock `.coplugin` into the application support directory -> Verify `PluginManager` loads it.
- Test Case: Open Preferences -> Plugins -> Verify the mock plugin is listed with the correct version.
